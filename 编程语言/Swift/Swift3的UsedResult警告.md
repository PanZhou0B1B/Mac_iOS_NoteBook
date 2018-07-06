原文连接：https://useyourloaf.com/blog/swift-3-warning-of-unused-result/

译文如下：

# 标题：Swift3 的Used Result 警告

使用Xcode8的迁移工具将项目转换成Swift3的语法格式。转换之后，却产生了许多类似``Result of call to sumeFunction``形式的警告。

在Swift3中，调用一个具有返回值的函数时，若不使用其返回值，默认是给出警告的。这篇文章将针对如何忽略警告，做一些总结：

## Swift2.x时期

在Swift2.x中，我们可以告知编译器，当忽略函数的返回值时，给予警告。

使用关键字`@warn_unused_result`，如

```
@warn_unused_result func doSomething() -> Bool {
  return true
}
```

直接调用上述函数，而不处理返回值时，则会得到如下警告：

> Result of call to 'doSomething()' is unused

同理在OC中使用属性标注，可以得到类似效果：

```
- (BOOL)doSomething __attribute__((warn_unused_result)) {
  return YES;
}
```

直接调用上述函数，而不处理返回值时，则会得到如下警告：

> Ignoring return value of function declared with warn_unused_result attribute


## Swift3的变更

**在Swift3中不使用返回值，默认是给予警告的。**而在Obj-C和Swift2.x中，不使用返回值，默认是不给予警告的。

这也是为什么项目从Swift2.x迁移至Swift3时，会产生很多新的警告。

## Swift3消除警告

1. 声明函数时使用关键字` @discardableResult` 重写之。

	```
	@discardableResult func doSomething() -> Bool {
  return true
}
	```
	意即不使用返回值时，不显示（丢弃）警告。
	
	同理在Obj-C中，所有返回非空的函数默认均自动添加了` @discardableResult`属性，而不是`warn_unused_result`属性了。
	
2. 调用返回值非空函数时，使用`_`明确丢弃返回值.

	```
	_ = doSomething()
	
	```

## Optional Chaining中属性丢失

在Xcode8 beta3中有种情景，即使用` @discardableResult`属性却没有得到预期效果。如推出ctrl：

```
navigationController?.popViewController(animated: true)

```

警告如下(经测试，在正式版中也有该警告)：

```
Expression of type 'UIViewController?' is unused

```
原因：

1. `popViewController(animated: Bool)`函数这是一个Obj-C的API，故默认添加了` @discardableResult`属性。

2. navigationContrller必须是可选类型（Optional Chaining），取值可以为nil

3. ` @discardableResult`属性在遇到Optional Chaining之后会丢失

解决方案：

```
_ = navigationController?.popViewController(animated: true)


```

## 延伸阅读：

* [SE-0047 Defaulting non-Void functions so they warn on unused results](https://github.com/apple/swift-evolution/blob/master/proposals/0047-nonvoid-warn.md)
* [Swift Bug SR-1681 spurious unused result warning in Swift 3](https://bugs.swift.org/browse/SR-1681)
* [Swift Evolution Proposal Status](https://apple.github.io/swift-evolution/)