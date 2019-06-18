原文：[Swift Interview Questions and Answers](https://www.raywenderlich.com/762435-swift-interview-questions-and-answers)


Swift 只有四年的历史，但它已经成为iOS开发的默认语言。随着Swift 发展到 5.0 版，它已经变成一种复杂而强大的语言，包含面向对象和功能模式。每次发布都会带来更多的进化和变化。

但你对 Swift 了解多少？在这篇文章中，有一些面试问题的示例。

你可以用这些问题来面试应聘者，以测试他们的 Swift 知识。当然你也可以自己测试！如果你不知道答案，不要担心：每个问题都有解决方案，这样你才能有所收获。

你会发现问题分为三个层次：

* 初学者：适合初学者 Swift 知识储备。你读过一两本关于这个主题的书，并且在自己的应用程序中使用了 Swift。

* 中级：适合对 Swift 语言有浓厚兴趣的人。你已经读了很多关于Swift 的文章，并做了进一步的实验。

* 高级：适合最有经验的开发人员--那些喜欢彻底探索语言和使用尖端技术的人。


在每一个层次上，你会发现两种类型的问题：

* 书面问题：很适合通过电子邮件进行编程测试，因为这些测试可能涉及到编写代码。

* 口头问题：适合通过电话或面对面的面试提问，因为你的面试者可以口头回答。

当你进行这些问题和思考答案的时候，打开 playground，这样你就可以在回答之前使用附加到问题上的代码。我们已经根据Xcode 10.2和Swift 5测试了所有答案。

## Beginner 书面问题

#### 1. 思考下列代码：

`tutorial1.difficulty`和`tutorial2.difficulty`的值分别是多少？如果`Tutorial `是 class类 类型，结果会有不同吗？为什么。

```
struct Tutorial {
  var difficulty: Int = 1
}

var tutorial1 = Tutorial()
var tutorial2 = tutorial1
tutorial2.difficulty = 2

```

释：

* `tutorial1.difficulty`值为 1，`tutorial2.difficulty`值为 2。

* 若`Tutorial `是 class类，则两者值均为 2。

* 因为`Tutorial`是 Struct 结构体，属于值类型，以下代码创建了一个`tutorial1`的副本，并将其分配给`tutorial2`。因此`tutorial2`和`tutorial1`分别引用了不同的对象。

	```
	var tutorial2 = tutorial1
	```

	若`Tutorial`为 class 类型 ，则为 引用类型，`tutorial2`和`tutorial1`分别指向同一个对象实例，故值相同。


#### 2. 以`var`声明了`view1`，以`let`声明了`view2`,它们之间有什么不同？最后一行代码是否可以通过编译？

```
import UIKit

var view1 = UIView()
view1.alpha = 0.5

let view2 = UIView()
view2.alpha = 0.5 // Will this line compile?

```

释：

* `view1`是一个变量,`var`声明的是变量，值可以更改，即可以将它重新分配给`UIView`的新实例；而用`let`声明的变量，值不可更改，即只能分配一次值。因此不会编译以下代码：

	```
	view2 = view1 // Error: view2 is immutable

	```
* 最后一行可以编译通过。`UIView `是一个具有引用语义的类，因此可以改变`view2`的属性。


#### 3. 下面的复杂代码实现了按字母顺序排序 names 数组，请简化闭包实现。

```
var animals = ["fish", "cat", "chicken", "dog"]
animals.sort { (one: String, two: String) -> Bool in
    return one < two
}
print(animals)

```

释：

* 简化一：`类型推断系统`会自动计算闭包中参数的类型和返回类型，故可以去掉它们了。

	```
	animals.sort { (one, two) in return one < two }

	```

* 简化二：可以用`$i`符号替换参数名：

	```
	animals.sort { return $0 < $1 }
	
	```

* 简化三：在单语句闭包中，可以省略`return `关键字。最后一条语句的值将成为闭包的返回值：

	```
	animals.sort { $0 < $1 }

	```

* 简化四：由于 Swift 知道数组的元素符合`Equatable`，因此您可以简单地编写：

	```
	animals.sort(by: <)

	```
	
	
	
#### 4. 代码中创建了2个类：`Address`、`Person`，接着实例化了2个`Person`实例：Ray 和 Brian。

```
class Address {
  var fullAddress: String
  var city: String
  
  init(fullAddress: String, city: String) {
    self.fullAddress = fullAddress
    self.city = city
  }
}

class Person {
  var name: String
  var address: Address
  
  init(name: String, address: Address) {
    self.name = name
    self.address = address
  }
}

var headquarters = Address(fullAddress: "123 Tutorial Street", city: "Appletown")
var ray = Person(name: "Ray", address: headquarters)
var brian = Person(name: "Brian", address: headquarters)

```

假如 Brian 更改了地址，可能像如下修改：

```
brian.address.fullAddress = "148 Tutorial Street"

```

编译无错误，但如果检测 Ray 的地址，他的地址也随之更改了。

```
print (ray.address.fullAddress)

```

为什么出现这种问题？如何修复？

释：

* `Address `是一个类，具有引用语义，所以不管通过 Ray 还是Brian 访问，`headquarters`都是一个相同的实例。更改`headquarters`地址将同时更改。

* 解决方案是创建一个新`Address `来分配给 Brian，或者**将地址声明为`结构体`而不是`类`。**

* 附：另外一个概念：inout 参数。函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误。这意味着你不能错误地更改参数值。如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数。




## Beginner 口头问题


#### 1. `optional`是什么？它解决了什么问题？


* `optional`：可选类型。一个`optional`类型允许任何类型的变量表示缺省值。在 Obj-C中，只有在使用 nil 特殊值的引用类型中才可以使用值缺失。值类型（如 int 或 float）不具有此功能。

* Swift 将缺省值概念扩展到`引用类型`和`值类型`。可选变量可以表示`值`或`nil`(表示缺省值)。


#### 2. 汇总 结构体（structure） 和 类（class） 的主要区别。


|区别| structure | class |
|:--:|:--:|:--:|
|类型|值类型|引用类型|
|继承性|不支持|支持|
|构造器|成员逐一|默认无参数|
|变异方法|改变self时需要|不需要|


#### 3. 什么是泛型（generics），它们解决了什么问题？

* 在 Swift 中，可以在`函数`和`数据类型`中使用泛型，例如在类、结构或枚举中。

* 泛型解决了代码重复的问题。当有一个方法接受一种类型的参数时，通常会复制它以适应不同类型的参数。


例如，在下面的代码中，第二个函数是第一个函数的“克隆”，但它接受字符串而不是整数。

```
func areIntEqual(_ x: Int, _ y: Int) -> Bool {
  return x == y
}

func areStringsEqual(_ x: String, _ y: String) -> Bool {
  return x == y
}

areStringsEqual("ray", "ray") // true
areIntEqual(1, 1) // true

```
通过采用泛型，可以将这两个函数合并为一个函数，同时**保持类型安全**。下面是通用实现：

```
func areTheyEqual<T: Equatable>(_ x: T, _ y: T) -> Bool {
  return x == y
}

areTheyEqual("ray", "ray")
areTheyEqual(1, 1)
```

由于在本例中测试的是相等性，所以将参数限制为实现`Equatable `协议的任何类型。此代码实现了预期的结果，并防止传递不同类型的参数。

#### 4. 在某些情况下，不能避免使用隐式展开的`optional`。什么时候？为什么？

最常见原因是：

1. 在实例化期间，不能初始化本质上不是零的属性时。典型的例子是一个 XIB outlet，它总是在其所有者之后初始化。在这种特定的情况下——假设它在 XIB 中正确配置了——在使用之前，您已经保证 outlet 是非 nil 的。

2. 解决强引用循环问题，即两个实例相互引用，需要对另一个实例进行非 nil 引用。在这种情况下，您将引用的一侧标记为 `unowned`，而另一侧使用隐式展开的可选选项。


#### 5. 展开`optional`的方法有哪些？他们安全性评估如何？（提示：有7种方式）

```
var x : String? = "Test"

```

1. 强制展开--非安全：

	```
	let a: String = x!
	```
2. 隐式展开的变量声明-在许多情况下不安全。

	```
	var a = x!

	```
	
3. 可选绑定--安全：

   ```
   if let a = x {
   		//do something
   }
   ```
   
4. 可选链--安全：

	```
	let a = x?.count
	``` 
	
5. 空合并（Nil coalescing）操作--安全：

	```
	let a = x ?? ""
	```
	
6. `Guard `声明--安全：

	```
	guard let a = x else{
		//do something
	}
	```
	
7. 可选模式--安全：

	```
	if case let a? = x{
		// do something
	}
	```
	
	
## Intermediate 书面问题

#### 1. `nil`和`.none`的区别是什么？

* 无区别。

* `.none`即`Optional.none`缩写，与`nil`是等价的。
* 比较常见是使用`nil`，也是推荐的方式。

* 实际上，下面陈述语句为 true：

	```
	nil == .none
	```

#### 2. 有一个温度计的模型，作为一个类和一个结构体。编译器会抱怨最后一行。为什么它不能编译？

> 提示：在 playground 运行测试之前，请仔细阅读代码并思考。


```
public class ThermometerClass {
  private(set) var temperature: Double = 0.0
  public func registerTemperature(_ temperature: Double) {
    self.temperature = temperature
  }
}

let thermometerClass = ThermometerClass()
thermometerClass.registerTemperature(56.0)

public struct ThermometerStruct {
  private(set) var temperature: Double = 0.0
  public mutating func registerTemperature(_ temperature: Double) {
    self.temperature = temperature
  }
}

let thermometerStruct = ThermometerStruct()
thermometerStruct.registerTemperature(56.0)

```

释：

* 正确声明了`ThermometerStruct`结构体，并使用一个可变异函数来更改其内部变量`temperature`。编译器会抱怨，因为您在`let`创建的实例上调用了变异方法`registerTemperature(_:)`，因此它是不可变的。

* 将`let`更改为`var`以使示例编译正常。

* 对于结构体，必须将更改内部状态的方法标记为`mutating`可变方法，但不能从不可变变量(`let`)调用它们。



#### 3. 代码将会输出什么？为什么？

```
var thing = "cars"

let closure = { [thing] in
  print("I love \(thing)")
}

thing = "airplanes"

closure()

```

释：

1. 打印输出`I love cars `。
2. **当声明闭包时，捕获列表会创建对象的副本。**这意味着即使给对象分配一个新的值，捕获的值也不会改变。

3. 附：**如果在闭包中省略了捕获列表，那么编译器将使用引用而不是副本(容易造成强引用循环)。**因此，当调用闭包时，它会反映变量的任何更改。您可以在以下代码中看到：

	```
	var thing = "cars"
let closure = {    
  print("I love \(thing)")
}
thing = "airplanes"
closure() // Prints: "I love airplanes"

	```
	

#### 4. 全局函数：用以计算数组中单一值的个数。

```
func countUniques<T: Comparable>(_ array: Array<T>) -> Int {
  let sorted = array.sorted()
  let initial: (T?, Int) = (.none, 0)
  let reduced = sorted.reduce(initial) {
    ($1, $0.0 == $1 ? $0.1 : $0.1 + 1)
  }
  return reduced.1
}

```

它使用了`sorted `方法，比限制`T`必须满足`Comparable `协议。

可以调用如下：

```
countUniques([1, 2, 3, 3]) // result is 3
```

重写该函数，使之作为`Array`的扩展方法，以使可以调用如下：

```
[1, 2, 3, 3].countUniques() // should print 3

```


释：修改后如下

```
extension Array where Element: Comparable {
  func countUniques() -> Int {
    let sortedValues = sorted()
    let initial: (Element?, Int) = (.none, 0)
    let reduced = sortedValues.reduce(initial) { 
      ($1, $0.0 == $1 ? $0.1 : $0.1 + 1) 
    }
    return reduced.1
  }
}

```

附：新方法仅在泛型 Element 实现了`Comparable`协议时才可用。


#### 5. 函数用来实现两个可选的双精度数的除法。在执行实际除法之前，有三个先决条件需要验证：

1. 被除数(dividend)必须为非 nil 值
2. 除数(divisor)必须为非 nil 值
3. 除数(divisor)必须不为 0


```
func divide(_ dividend: Double?, by divisor: Double?) -> Double? {
  if dividend == nil {
    return nil
  }
  if divisor == nil {
    return nil
  }
  if divisor == 0 {
    return nil
  }
  return dividend! / divisor!
}

```

使用`guard`语句、并不含强制展开，改善函数实现。

**释：**

```
func divide(_ dividend: Double?, by divisor: Double?) -> Double?{
    guard let dividend = dividend, let divisor = divisor, divisor != 0 else {
        return nil
    }
    return dividend / divisor
}
```
注意最后一行没有隐式展开的运算符，因为已经展开了被除数和除数，并将它们存储在非可选的不可变变量中。

注意，`guard`语句中展开的可选变量结果可用于语句所在的代码块的其余部分。


Swift 2.0 中引入的`guard`语句在不满足某个条件时提供一个出口路径。它在检查前提条件时非常有用，因为它可以以一种清晰的方式表达它们——而不需要嵌套 if 语句的厄运金字塔。下面是一个例子：

```
guard dividend != nil else { return nil }
```

**可以使用`guard`语句进行可选绑定，这样可以在`guard`语句之后访问展开的变量。**

```
guard let dividend = dividend else { return .none }

```


#### 6. 以`if let`重写问题 5 的方法

```
func divide(_ dividend: Double?, by divisor: Double?) -> Double?{
    
    if let dividend = dividend, let divisor = divisor, divisor != 0  {
        return dividend / divisor
    }
    return nil
}
```

`if let`语句展开可选变量并在该代码块中（if let 块）使用该值。请注意，您不能在 `if let`块外部的访问该展开可选值。



## Intermediate 口头问题


#### 1. 在 Obj-C 中，声明常量如下：

```
const int number = 0;

```

在 Swift 中声明常量：

```
let number = 0

```

它们之间有什么区别？

**释：**

* `const`常量是在**编译时初始化的**变量，其值或表达式必须在编译时可解析。

* `let`创建的不可变项是**运行时**确定的常量。可以使用静态表达式或动态表达式初始化它。允许声明如下：

	```
	let higherNumber = number + 5

	```
	附：其值只能被分配一次。


#### 2. 值类型中，若要声明静态属性或静态函数，使用`static `修饰符。下面是一个结构体示例：

```
struct Sun {
  static func illuminate() {}
}

```

但是对于引用类型，对于类，可以使用`static `或`class `修饰符。他们实现了相同的目标，但方式不同。解释一下它们有什么不同吗？


**释：**

* `static`使属性或函数成为静态的且不可重写(overridable)。但使用`class `可以重写属性或函数。

* 当应用于类时，`static`将成为`class final`的别名。


例如，在这段代码中，当试图重写illuminate()方法时，编译器会报错：

```
class Star {
  class func spin() {}
  static func illuminate() {}
}
class Sun : Star {
  override class func spin() {
    super.spin()
  }
  // error: class method overrides a 'final' class method
  override static func illuminate() { 
    super.illuminate()
  }
}
```


#### 3. 可以在某个类型的扩展中添加存储属性吗？为什么？

不能。

可以使用扩展向现有类型添加新行为，但不能更改类型本身或其接口。

**如果添加存储属性，则需要额外内存来存储新值。扩展无法管理此类任务。**


#### 4. 在 Swift 中， protocol 是什么？

* `protocol`是定义方法、属性和其他需求的蓝图设计类型。然后，类、结构体或枚举均可采用协议来实现这些需求。

* 适配某协议并实现其要求的类型需符合（conform）该协议。

* 协议本身不实现任何功能，而只是定义功能。

* 可以扩展一个协议，以提供符合类型可以利用的某些需求或附加功能的默认实现。



## Advanced 书面问题

#### 1. 考虑下面的温度计模型结构体：

```
public struct Thermometer {
  public var temperature: Double
  public init(temperature: Double) {
    self.temperature = temperature
  }
}

```

创建实例，使用如下：

```
var t: Thermometer = Thermometer(temperature:56.8)

```

但以这种方式初始化它会更好：

```
var thermometer: Thermometer = 56.8

```

可以吗？怎么做？


**释：**


Swift定义了协议`ExpressibleByXXXLiteral `，使您能够使用`赋值运算符`并用`文本值`初始化类型。

采用相应的协议并实现 公共的初始构造器，允许对特定类型进行文本初始化。

在温度计的案例中，实现如下协议`ExpressibleByFloatLiteral`:

```
extension Thermometer: ExpressibleByFloatLiteral {
  public init(floatLiteral value: FloatLiteralType) {
    self.init(temperature: value)
  }
}
```


#### 3. Swift 有一组预定义的运算符来执行算术或逻辑操作。它还允许创建自定义运算符，一元或二元。

使用以下规范实现自定义幂运算符`^^`：

* 使用 2 个`Int`类型作为参数
* 返回第一个参数的幂
* 使用标准的代数运算顺序正确评估方程
* 忽略溢出错误的可能性

**释：**

通过两个步骤创建新的自定义运算符：声明和实现。

1. **声明：**使用`operator`关键字指定类型（一元或二元运算符）、组成运算符的字符序列、其关联性和优先级。Swift 3.0 将优先级的实现更改为使用优先级组。

	* 操作符是`^^`且类型是`infix`（二元运算符）。
	* 关联性是右的；
	* 相等优先级`^^`运算符应该从右向左计算公式。
	* 在 Swift 中，指数幂运算没有[预先定义的标准优先级](https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations)。按照代数的标准运算顺序，指数幂应在乘法/除法之前计算。**因此，您需要创建一个自定义优先级，使它们高于乘法。**

	声明如下：
	
	```
	precedencegroup ExponentPrecedence {
  higherThan: MultiplicationPrecedence
  associativity: right
}
infix operator ^^: ExponentPrecedence

	```

2. **实现：**

	```
	func ^^(base: Int, exponent: Int) -> Int {
  let l = Double(base)
  let r = Double(exponent)
  let p = pow(l, r)
  return Int(p)
}

	```

附：由于代码不考虑溢出，如果操作产生 Int 不能表示的结果，例如大于 Int.max 的值，则会发生运行时错误。




####  3. 考虑以下代码，将`Pizza `定义为结构体，`Pizzeria`定义为协议，该协议具有一个扩展，并包括`makeMargherita()`的默认实现：

```
struct Pizza {
  let ingredients: [String]
}

protocol Pizzeria {
  func makePizza(_ ingredients: [String]) -> Pizza
  func makeMargherita() -> Pizza
}

extension Pizzeria {
  func makeMargherita() -> Pizza {
    return makePizza(["tomato", "mozzarella"])
  }
}

```

接下来定一个餐厅`Lombardis `:

```
struct Lombardis: Pizzeria {
  func makePizza(_ ingredients: [String]) -> Pizza {
    return Pizza(ingredients: ingredients)
  }

  func makeMargherita() -> Pizza {
    return makePizza(["tomato", "basil", "mozzarella"])
  }
}
```

下述代码创建了2个`Lombardis `实例，这两个实例中的哪一个会用`basil `制作`margherita `？

```
let lombardis1: Pizzeria = Lombardis()
let lombardis2: Lombardis = Lombardis()

lombardis1.makeMargherita()
lombardis2.makeMargherita()

```


**释：**

他们都会，都满足。

Pizzeria 协议声明 makeMargherita() 方法并提供默认实现。Lombardis 实现协议重写默认方法。由于在这两种情况下都在协议中声明了该方法，因此将在运行时调用正确的实现(实现中的优先、默认实现次之)。


如果协议没有声明 makeMargherita() 方法，但是扩展仍然提供了一个默认的实现，那么会怎么样？

```
protocol Pizzeria {
  func makePizza(_ ingredients: [String]) -> Pizza
}

extension Pizzeria {
  func makeMargherita() -> Pizza {
    return makePizza(["tomato", "mozzarella"])
  }
}

```

此时，只有`lombardis2 `用`basil`做比萨，而`lombardis1`不用`basil`做比萨，因为它将使用协议扩展中定义的方法。



#### 4. 代码有编译时错误。发现它并解释它为什么会发生？有什么方法可以解决？

```
struct Kitten {
}

func showKitten(kitten: Kitten?) {
  guard let k = kitten else {
    print("There is no kitten")
  }   
  print(k)
}

```

**释：**


`guard`的 else 块需要一个出口路径，可以使用 return、抛出异常、调用 @noreturn 3种方式解决。

1. 使用 return 语句：

	```
	func showKitten(kitten: Kitten?) {
  guard let k = kitten else {
    print("There is no kitten")
    return
  }
  print(k)
}

	```
	
2. 抛出异常：

	```
	enum KittenError: Error {
  case NoKitten
}
struct Kitten {
}
func showKitten(kitten: Kitten?) throws {
  guard let k = kitten else {
    print("There is no kitten")
    throw KittenError.NoKitten
  }
  print(k)
}
try showKitten(kitten: nil)

	```

3. 使用`@noreturn`方法，如使用`fatalError()`

	```
	struct Kitten {
}
func showKitten(kitten: Kitten?) {
  guard let k = kitten else {
    print("There is no kitten")
    fatalError()
  }
  print(k)
}
	```


## Advanced 口头问题

#### 1. 闭包是值类型还是引用类型？

是引用类型。

如果将一个闭包赋给一个变量，并将该变量复制到另一个变量中，那么还可以复制对同一个闭包及其捕获列表的引用。


#### 2. 使用`UInt`类型保存无符号整数，它实现了以下构造方法以从有符号整数转换：

```
init(_ value: Int)

```

然而，如果提供负值，以下代码将生成编译时错误异常：

```
let myNegative = UInt(-1)

```

定义的无符号整数不能为负。但是，可以使用负数的内存表示形式转换为无符号整数。在保持其内存表示形式的同时，如何将 Int 负数转换为 UInt？

**释：**

有一个构造器：

```
UInt(bitPattern: Int)

```

实现如下：

```
let myNegative = UInt(bitPattern: -1)

```

#### 3. 能描述 Swift 中的循环引用吗？怎么解决它?


* 当两个实例彼此拥有强引用时会发生循环引用，会导致内存泄漏，因为这两个实例都不会被释放。原因是，只要有一个对实例的强引用，就不能释放该实例，但是每个实例由于其强引用而使另一个实例始终保持存活状态。


* 可以通过将强引用的一方替换为`weak`引用或`unowned`无主引用来打破强引用循环来解决问题。




#### 4. Swift 允许创建递归枚举。下面是这样一个枚举的例子，有一个 case `Node`,并有 2 种关联值类型：T 和List：

```
enum List<T> {
  case node(T, List<T>)
}

```
将出现编译错误。缺少的关键字是什么？

**释：**

它是允许递归枚举情况的`indirect`关键字，如下所示：

```
enum List<T> {
  indirect case node(T, List<T>)
}

```



## 其它

* [Swift Apprentice](https://store.raywenderlich.com/products/swift-apprentice)
* [Algorithms & Data Structures](https://www.raywenderlich.com/library?category_ids%5B%5D=156&domain_ids%5B%5D=1&sort_order=released_at)




















