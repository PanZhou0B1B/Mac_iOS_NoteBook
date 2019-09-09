本文翻译自：[How Mirror Works](https://swift.org/blog/how-mirror-works/)，并做简化。

Swift 更多的注重静态类型，但它仍然支持有关类型的丰富元数据，允许代码在 runtime 期间检查和操作任意值。通过 Mirror API 向 Swift 程序员公开此功能。有人可能好奇：像 Mirror 这样的东西是如何在一种非常强调静态类型的语言中工作的？让我们拭目以待！


## 免责声明

这里的一切都是内部实现细节。截至撰写本文时，代码是最新的，但可能会发生变化。当 ABI 稳定性达到时，元数据将成为固定，可靠的格式，但此刻仍有待改变。如果您正在编写正常的 Swift 代码，请不要依赖任何此类代码。如果您正在编写比 Mirror 所能提供的更复杂反射机制的代码，这将为您提供一个起点，但需保持改变，直到 ABI 稳定。如果你想处理 Mirror 代码本身，这应该让你很好地了解它们是如何组合的，但请记住，事情可能会发生变化。


## 接口

`Mirror(reflecting:)` 初始化方法接收任意值，然后，生成的 Mirror 实例提供有关该值的信息，主要是它包含的子项。

子项：由**值**和**可选标签**组成。然后，您可以在子项的值上​​使用 Mirror 来遍历整个对象图，而无需在编译时知道任何类型。

Mirror 允许类型通过实现 `CustomReflectable` 协议来提供自定义表示。对于想要实现某些特定功能，相较于`内省（introspection）`方式 ，是更好的方案。

例如，Array 实现`CustomReflectable `协议，并将其元素公开为未标记的子项，Dictionary 同理将其`key/value`对展开为标记的子项。

对于所有其他类型，Mirror 会根据值的实际内容提供子项列表。对于 struct 和 class，它将`存储属性`显示为子元素；对于 tuple，它呈现元组元素。enum 显示枚举 case 和相关值（如果有）。

具体细节如何实现，让我们继续！

###### Structure

反射 API 部分在 Swift 中实现，部分在 C++ 中实现。Swift 更适合实现 Swifty 接口，并使实现许多任务变得更容易。Swift 运行时的较低层级是用 C++ 实现的，直接从 Swift 访问这些 C++ 类是不可能的，因此 C 层 连接这两个：`ReflectionMirror.swift`实现 Swift 端；`ReflectionMirror.mm`实现 C++ 端。

这两个部分通过暴露给 Swift 的一小组 C++ 函数进行通信，而不是使用 Swift 的内置 C 桥接。它们在 Swift 中声明了一个指定自定义符号名称的指令，然后精心设计一个具有该名称的 C++ 函数，可直接被 Swift 调用。这允许两个部分直接通信而无需担心桥接器在幕后对值做什么，但它需要知道 Swift 如何传递参数和返回值。除非你正在处理运行时代码并需要它，否则不应尝试这个。


示例，试着观察`ReflectionMirror.swift`中的`_getChildCount `函数：

```
//通知 Swift 编译器将此函数映射到名为swift_reflectionMirror_count的符号上，而非通常的Swift 编码应用于_getChildCount
@_silgen_name("swift_reflectionMirror_count")
internal func _getChildCount<T>(_: T, type: Any.Type) -> Int
```

请注意，开头的下划线表示此属性是为标准库保留的，在 C++ 端，该函数如下：

```
SWIFT_CC(swift) SWIFT_RUNTIME_STDLIB_INTERFACE
intptr_t swift_reflectionMirror_count(OpaqueValue *value,
                                      const Metadata *type,
                                      const Metadata *T) {
```

`SWIFT_CC(swift)`:告诉编译器这个函数使用 Swift 调用约定而不是 C/C++ 约定。
`SWIFT_RUNTIME_STDLIB_INTERFACE`:将此标记为一个函数，表示它是 Swift 端接口的一部分，并具有将其标记为`extern C`的效果，它避免了 C++ 名称编码并确保此函数具有 Swift 端期望的符号名称。仔细安排 C++ 参数序列以匹配 Swift 声明时调用此函数的方式。当 Swift 代码调用`_getChildCount`时，C++ 函数将被调用，并带有参数 value 指针指向 Swift 值，type 参数含有对应值，T 参数包含与通用模板 < T > 对应的类型。


Mirror 的 Swift 和 C++ 的完整接口包含这些函数：

```
@_silgen_name("swift_reflectionMirror_normalizedType")
internal func _getNormalizedType<T>(_: T, type: Any.Type) -> Any.Type

@_silgen_name("swift_reflectionMirror_count")
internal func _getChildCount<T>(_: T, type: Any.Type) -> Int

internal typealias NameFreeFunc = @convention(c) (UnsafePointer<CChar>?) -> Void

@_silgen_name("swift_reflectionMirror_subscript")
internal func _getChild<T>(
  of: T,
  type: Any.Type,
  index: Int,
  outName: UnsafeMutablePointer<UnsafePointer<CChar>?>,
  outFreeFunc: UnsafeMutablePointer<NameFreeFunc?>
) -> Any

// Returns 'c' (class), 'e' (enum), 's' (struct), 't' (tuple), or '\0' (none)
@_silgen_name("swift_reflectionMirror_displayStyle")
internal func _getDisplayStyle<T>(_: T) -> CChar

@_silgen_name("swift_reflectionMirror_quickLookObject")
internal func _getQuickLookObject<T>(_: T) -> AnyObject?

@_silgen_name("_swift_stdlib_NSObject_isKindOfClass")
internal func _isImpl(_ object: AnyObject, kindOf: AnyObject) -> Bool
```


## 怪异的动态调度

