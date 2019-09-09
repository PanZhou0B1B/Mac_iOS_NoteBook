
本文翻译自链接：[Reflection and Mirror in Swift](http://www.vadimbulavin.com/2018-03-09-reflection-and-mirror-in-swift/),有所精简。


尽管 Swift 是一种静态类型语言，但其类型系统在`运行时`却有另一种生命特征，即它为一些动态特性实现铺平了道路。这允许我们查看在代码中定义的类型和方法，并在此基础上构建更高的抽象。该技术称为**反射（Reflection）**。本文我们将探究`反射`以及`反射类型（Mirror）`，同时也展示若干使用示例。

## 反射及反射类型

`反射`（[Reflection](https://en.wikipedia.org/wiki/Reflection_(computer_programming))）：具备在`运行时` 检查、内省、修改 `自身结构和行为`能力的程序。

> 内省（[Introspection](https://en.wikipedia.org/wiki/Type_introspection)）：是程序在运行时检查对象类型或属性的能力。


Swift的反射是有局限的，提供对类型元数据子集的只读访问权限。此类元数据封装在`反射类型`中。在幕后，每个 Swift 元数据类型都有对应的反射类型（Mirror）实现：`Tuple`、`Struct`、`Enum`、`Class`、`Metatype`、[Opaque](https://developer.apple.com/library/content/documentation/CoreFoundation/Conceptual/CFDesignConcepts/Articles/OpaqueTypes.html)，全部派生自`ReflectionMirrorImpl `抽象类。

这些类能够读取相应元类型的任意字段。通过`Objective-C runtime`实现( crawled )父类-子类层级结构。前者具有平台限制，因为需要与Obj-C进行无桥接的互操作，而Obj-C又仅由Apple平台支持。**这意味着，在其它平台上使用反射类型，会使 app 崩溃。**



## 使用案例


###### 1. json解析

关于反射的应用，首先想到的便是JSON解析。为演示基本概念，让我们看一个简单例子：

```
//协议
protocol JSONSerializable {
    func toJSON() throws -> Any?
}
//枚举
enum CouldNotSerializeError: Error {
    case noImplementation(source: Any, type: String)
    case undefinedKey(source: Any, type: String)
}

extension JSONSerializable {

    func toJSON() throws -> Any? {
        let mirror = Mirror(reflecting: self)

        guard !mirror.children.isEmpty else { return self }

        var result: [String: Any] = [:]

        for child in mirror.children {
            if let value = child.value as? JSONSerializable {
                if let key = child.label {
                    result[key] = try value.toJSON()
                } else {
                    throw CouldNotSerializeError.undefinedKey(source: self, type: String(describing: type(of: child.value)))
                }
            } else {
                throw CouldNotSerializeError.noImplementation(source: self, type: String(describing: type(of: child.value)))
            }
        }

        return result
    }
}
```

接下来添加json序列功能，即实现上述`JSONSerializable `协议。


```
struct Order {
    let uid = UUID()
    let itemsCount = 1
    let isDeleted = false
    let name = "A cup"
    let subtitle: String? = nil
    let category = Category(name: "Cups")
}
struct Category {
    let name: String
}

extension String: JSONSerializable {}
extension Int: JSONSerializable {}
extension Bool: JSONSerializable {}
extension Optional: JSONSerializable {}
extension UUID: JSONSerializable {}
extension Order: JSONSerializable {}
extension Category: JSONSerializable {}

do {
    try Order().toJSON()
} catch {
    print(error)
}

```


`Order`实例序列化为：

```
["itemsCount": 1, "name": "A cup", "isDeleted": false, "category": ["name": "Cups"], "uid": F888F5A7-F499-4748-BB28-2B9BDD4D8399, "subtitle": nil]

```

通过扩展 `Optional` 类型的实现序列化协议来过滤掉所有的 nil 值：

```
extension Optional: JSONSerializable {
    func toJSON() throws -> Any? {
        if let x = self {
            guard let value = x as? JSONSerializable else {
                throw CouldNotSerializeError.noImplementation(source: x, type: String(describing: type(of: x)))
            }
            return try value.toJSON()
        }
        return nil
    }
}
```

现在过滤掉所有的 nil 值，并将上面示例中的Order实例序列化：

``["itemsCount": 1, "name": "A cup", "isDeleted": false, "category": ["name": "Cups"], "uid": 07614D63-5A08-465D-8CC8-195434A2C371]
``

全部代码链接:[JSON serialization.swift](https://gist.github.com/V8tr/3ab9ab1a550415fae5d61aa39d3a2185)。



###### 2. 自动等价和哈希一致性

实现`Equatable `和`Hashable `，总是容易发生错误。每次添加新属性时，都很容易忘记更新相应的`哈希值`和`相等运算符`。

有一系列 `dump` 函数通过使用它们的镜像来组合给定项的文本表示。这种方法假设 相等的对象总是具有相同的镜像（Mirrors）。在将域模型合并到生产环境之前，请对该方案进行评估。

```
protocol AutoEquatable: Equatable {}

extension AutoEquatable {

    static func ==(lhs: Self, rhs: Self) -> Bool {
        var lhsDump = String()
        dump(lhs, to: &lhsDump)

        var rhsDump = String()
        dump(rhs, to: &rhsDump)

        return rhsDump == lhsDump
    }
}
```

创建一些简单的结构来展示这个方案：

```
struct Order {
    let uid: UUID
    let count: Int
    let orderedAt: Date
    let item: Item
}

struct Item {
    let uid: UUID
    let title: String
    let description: String?
    let priceUSD: Double
}

struct Person {
    let name: String
}

extension Order: AutoEquatable {}
extension Person: AutoEquatable {}
//测试并判断数据的等价性
class AutoEquatableTests: XCTestCase {

    let coffee = Item(uid: UUID(), title: "Coffee", description: "Nescafe Original", priceUSD: 5)
    lazy var twoCoffees: Order = { Order(uid: UUID(), count: 2, orderedAt: Date(), item: coffee) }()

    func test_isEqual_samePersons_areEqual()
    {
        XCTAssertEqual(Person(name: "name"), Person(name: "name"))
    }

    func test_notEqual_personsWithDifferentNames_areNotEqual()
    {
        XCTAssertNotEqual(Person(name: "name"), Person(name: "anotherName"))
    }

    func test_isEqual_sameOrders_areEqual()
    {
        XCTAssertEqual(twoCoffees, twoCoffees)
    }

    func test_notEqual_differentOrders_areNotEqual()
    {
        let sandwich = Item(uid: UUID(), title: "Sandwich", description: nil, priceUSD: 5)
        let oneSandwich = Order(uid: UUID(), count: 1, orderedAt: Date(), item: sandwich)

        XCTAssertNotEqual(twoCoffees, oneSandwich)
    }
}
```

需要注意 Item 不是 AutoEquatable，意味着只有顶级类型必须符合 AutoEquatable。

`AutoHashable ` 大体类似，简单看下示例：

```
protocol AutoHashable: Hashable {}

extension AutoHashable {

    var hashValue: Int {
        var buf = String()
        dump(self, to: &buf)
        return buf.hashValue
    }
}

extension Order: AutoHashable {}
extension Person: AutoHashable {}

class AutoHashableTests: XCTestCase {

    let coffee = Item(uid: UUID(), title: "Coffee", description: "Nescafe Original", priceUSD: 5)
    lazy var twoCoffees: Order = { Order(uid: UUID(), count: 2, orderedAt: Date(), item: coffee) }()

    func test_hashValue_personsWithEqualNames_haveEqualHash()
    {
        XCTAssertEqual(Person(name: "name").hashValue, Person(name: "name").hashValue)
    }

    func test_hashValue_personsWithDifferentNames_haveDifferentHash()
    {
        XCTAssertNotEqual(Person(name: "name").hashValue, Person(name: "anotherName").hashValue)
    }

    func test_hashValue_sameOrders_haveEqualHash()
    {
        XCTAssertEqual(twoCoffees.hashValue, twoCoffees.hashValue)
    }

    func test_hashValue_differentOrders_haveDifferentHash()
    {
        let sandwich = Item(uid: UUID(), title: "Sandwich", description: nil, priceUSD: 5)
        let oneSandwich = Order(uid: UUID(), count: 1, orderedAt: Date(), item: sandwich)

        XCTAssertNotEqual(twoCoffees.hashValue, oneSandwich.hashValue)
    }
}
```

[示例源码](https://gist.github.com/V8tr/4507110d40e0b62fb09f1600bd992a96)


## 结语

`反射`提供了将其`动态特性`与 `Swift 静态类型系统`相结合的功能。尽管有局限性，但它仍可为您减少样板代码的编写，以之带来高效性。

除了上述所谓动态反射的示例外，也有一些`静态代码生成器`技术，如 [Sourcery](https://github.com/krzysztofzablocki/Sourcery)和[SwiftGen](https://github.com/SwiftGen/SwiftGen)，可能也是解决同质问题的好方法。

