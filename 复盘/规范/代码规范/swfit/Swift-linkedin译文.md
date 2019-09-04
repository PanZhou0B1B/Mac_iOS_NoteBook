# linkedin规范

原文链接：[linkedin规范](https://github.com/linkedin/swift-style-guide)

确保已阅读：[Apple's API Design Guidelines.](https://swift.org/documentation/api-design-guidelines/)

该指南针对于Swift4.0、更新于2018-02-14

## 1. 代码格式

###### 1.1 针对tabs 使用4个空格。
###### 1.2 强制约定每行最多字符数为160，避免一行过长。（Xcode->Preferences->Text Editing->Page guide at column: 160）
###### 1.3 确保每个文件的结尾处有一空行。
###### 1.4 确保在任何地方都无额外多余的空格出现。（Xcode->Preferences->Text Editing->Automatically trim trailing whitespace + Including whitespace-only lines）
###### 1.5 不要在新的一行放置花括号，我们使用[1TBS style](https://en.m.wikipedia.org/wiki/Indentation_style#1TBS)。

```
class SomeClass {
    func someMethod() {
        if x == y {
            /* ... */
        } else if x == z {
            /* ... */
        } else {
            /* ... */
        }
    }

    /* ... */
}

```
###### 1.6 针对属性、常量、变量、字典的key、protocol、父类等进行类型书写时，不要在冒号前添加空格。在其后添加空格。
```
// 类型定义
let pirateViewController: PirateViewController

// dictionary syntax (注意是左对齐而非冒号对齐)
let ninjaDictionary: [String: AnyObject] = [
    "fightLikeDairyFarmer": false,
    "disgusting": true
]

// 函数声明
func myFunction<T, U: SomeProtocol>(firstArgument: U, secondArgument: T) where T.RelatedType == U {
    /* ... */
}
// calling a function
someFunction(someArgument: "Kitten")

// superclasses
class PirateViewController: UIViewController {
    /* ... */
}

// protocols
extension PirateViewController: UITableViewDataSource {
    /* ... */
}
```
###### 1.7 一般而言，逗号后面应该有空格。
```
let myArray = [1, 2, 3, 4, 5]
```
###### 1.8 二元运算符前后应均有一个空格。如`+`、`==`、`->`。
###### 1.9 在`(`之后和`)`之前不应有空格。
```
let myValue = 20 + (30 / 2) * 3
if 1 + 1 == 3 {
    fatalError("The universe is broken.")
}
func pancake(with syrup: Syrup) -> Pancake {
    /* ... */
}
```

###### 1.10 遵循Xcode推荐的缩进风格。（即当按下CTRL-I时，你的代码无变化）
> 当声明一个跨越多行的函数时，倾向于使用Xcode（从7.3版本开始）默认的语法。

```
// Xcode indentation for a function declaration that spans multiple lines
func myFunctionWithManyParameters(parameterOne: String,
                                  parameterTwo: String,
                                  parameterThree: String) {
    // Xcode indents to here for this kind of statement
    print("\(parameterOne) \(parameterTwo) \(parameterThree)")
}

// Xcode indentation for a multi-line `if` statement
if myFirstValue > (mySecondValue + myThirdValue)
    && myFourthValue == .someEnumValue {

    // Xcode indents to here for this kind of statement
    print("Hello, World!")
}
```

###### 1.11 调用具有许多参数的函数时，将每个参数置于单独的行中，并使用一个额外的缩进。

```
someFunctionWithManyArguments(
    firstArgument: "Hello, I am a string",
    secondArgument: resultFromSomeFunction(),
    thirdArgument: someOtherLocalProperty)
```
###### 1.12 当处理一个足够大的隐式数组或字典，并保证将其分解成多行时，将`[`和`]`视为方法中的大括号`{`来处理。if语句、方法中的闭包等，类似处理。

```
someFunctionWithABunchOfArguments(
    someStringArgument: "hello I am a string",
    someArrayArgument: [
        "dadada daaaa daaaa dadada daaaa daaaa dadada daaaa daaaa",
        "string one is crazy - what is it thinking?"
    ],
    someDictionaryArgument: [
        "dictionary key 1": "some value 1, but also some more text here",
        "dictionary key 2": "some value 2"
    ],
    someClosure: { parameter1 in
        print(parameter1)
    })
```

###### 1.13 优先使用本地常量或其他缓解技术，以尽可能避免多行谓词出现。

```
// PREFERRED
let firstCondition = x == firstReallyReallyLongPredicateFunction()
let secondCondition = y == secondReallyReallyLongPredicateFunction()
let thirdCondition = z == thirdReallyReallyLongPredicateFunction()
if firstCondition && secondCondition && thirdCondition {
    // do something
}

// 不推荐
if x == firstReallyReallyLongPredicateFunction()
    && y == secondReallyReallyLongPredicateFunction()
    && z == thirdReallyReallyLongPredicateFunction() {
    // do something
}
```

## 2. 命名

###### 2.1 在Swift中不需要Objective-C风格的前缀。（如命名`GuybrushThreepwood `而非`LIGuybrushThreepwood `）

###### 2.2 使用`PascalCase`拼写法，来命名类型名称。（如 struct、enum、class、typedef、associatedtype等）
> 帕斯卡拼写法:一种计算机编程中的变量命名方法。它主要的特点是将描述变量作用所有单词的首字母大写，然后直接连接起来，单词之间没有连接符。

###### 2.3 使用camelCase（初始小写字母）拼写法，命名`函数，方法，属性，常量，变量，参数名称，枚举类型`等。

###### 2.4 处理缩略词或首字母纯大写的缩略词时，均原样使用该缩略词即可。 但有个例外：若该词是在一个名字的开始，需要以小写字母开头 - 在这种情况下，使用全部小写的缩写词。

```
// "HTML" is at the start of a constant name, so we use lowercase "html"
let htmlBodyContent: String = "<p>Hello, World!</p>"
// Prefer using ID to Id
let profileID: Int = 1
// Prefer URLFinder to UrlFinder
class URLFinder {
    /* ... */
}

```

###### 2.5 所有常量都应该是静态的，独立的。所有常量置于class、struct、enum的醒目处，且它们含有众多的常量，应依照相同的前缀、后缀或者用途将所属常量分组。

```
// PREFERRED
class MyClassName {
    // MARK: - Constants
	static let buttonPadding: CGFloat = 20.0
	static let indianaPi = 3
    
   static let shared = MyClassName()
   }
    // 不推荐
   class MyClassName {
      // Don't use `k`-prefix
     static let kButtonPadding: CGFloat = 20.0
	
    // Don't namespace constants
    enum Constant {
         static let indianaPi = 3	         
     }	    
}
```

###### 2.6 对于泛型（generics）和关联（associated）类型，使用`PascalCase`描述泛型。
> 1. 如果这个词与它所符合的协议或它的子类冲突,可以将`Type`后缀附加到泛型、关联类型名称后面。

```
class SomeClass<Model> { /* ... */ }
protocol Modelable {
    associatedtype Model
}
protocol Sequence {
    associatedtype IteratorType: Iterator
}
```

###### 2.7 命名具有可描述性和无歧义性。

```
// PREFERRED
class RoundAnimatingButton: UIButton { /* ... */ }

// NOT PREFERRED
class CustomButton: UIButton { /* ... */ }

```

###### 2.8 不可简化，缩短单词，或单一字符来命名。

```
// PREFERRED
class RoundAnimatingButton: UIButton {
    let animationDuration: NSTimeInterval

    func startAnimating() {
        let firstSubview = subviews.first
    }

}

// 不推荐
class RoundAnimating: UIButton {
    let aniDur: NSTimeInterval

    func srtAnmating() {
        let v = subviews.first
    }
}
```

###### 2.9 如果不是很明显，则在常量或变量名称中包含类型信息。

```
class ConnectionTableViewCell: UITableViewCell {
    let personImageView: UIImageView

    let animationDuration: TimeInterval

    // it is ok not to include string in the ivar name here because it's obvious
    // that it's a string from the property name
    let firstName: String

    // though not preferred, it is OK to use `Controller` instead of `ViewController`
    let popupController: UIViewController
    let popupViewController: UIViewController

    // when working with a subclass of `UIViewController` such as a table view
    // controller, collection view controller, split view controller, etc.,
    // fully indicate the type in the name.
    let popupTableViewController: UITableViewController

    // when working with outlets, make sure to specify the outlet type in the
    // property name.
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!

}
```

###### 2.10 函数命名：函数名、参数名需具有可描述性，可理解其作用。

###### 2.11 协议命名,依据协议作用分以下情况：

> 1. 使用名词命名：描述什么做什么。如CollectionView。
> 2. 使用后缀`able`、`ible`或`ing`：描述具备什么样的能力。如Equatable。
> 3. 视具体使用场景：其它情况。如使用后缀`Protocol `等。

```
// here, the name is a noun that describes what the protocol does
protocol TableViewSectionProvider {
    func rowHeight(at row: Int) -> CGFloat
    var numberOfRows: Int { get }
    /* ... */
}

// here, the protocol is a capability, and we name it appropriately
protocol Loggable {
    func logCurrentState()
    /* ... */
}

// suppose we have an `InputTextView` class, but we also want a protocol
// to generalize some of the functionality - it might be appropriate to
// use the `Protocol` suffix here
protocol InputTextViewProtocol {
    func sendTrackingEvent()
    func inputText() -> String
    /* ... */
}
```

## 3. 代码规范

#### 3.1 通用

###### 3.1.1 任何场景下，只要允许，尽可能使用`let`，而非`var`。

###### 3.1.2 当从一个集合转换到另一个集合时，优先考虑`map`、`filter`、`reduce`等的组合。
> 1. 确保在使用这些方法时避免使用有副作用的闭包

```
// PREFERRED
let stringOfInts = [1, 2, 3].flatMap { String($0) }
// ["1", "2", "3"]

// 不推荐
var stringOfInts: [String] = []
for integer in [1, 2, 3] {
    stringOfInts.append(String(integer))
}

// PREFERRED
let evenNumbers = [4, 8, 15, 16, 23, 42].filter { $0 % 2 == 0 }
// [4, 8, 16, 42]

// 不推荐
var evenNumbers: [Int] = []
for integer in [4, 8, 15, 16, 23, 42] {
    if integer % 2 == 0 {
        evenNumbers.append(integer)
    }
}
```

###### 3.1.3 若果可以通过推断得出常量、变量的类型，那就不用显式声明类型方式。

###### 3.1.4 若函数返回值有多个，则使用元祖（Tuple）而非`inout`参数返回。

> 1. 若返回值不易解读，最好使用标记元祖来清晰表达返回值作用。
> 2. 若多次使用某个元祖，可以考虑使用别名`typealias `
> 3. 若返回元祖中含有>=3个元素，则考虑使用`struct`或`class`替代方案。

```
func pirateName() -> (firstName: String, lastName: String) {
    return ("Guybrush", "Threepwood")
}

let name = pirateName()
let firstName = name.firstName
let lastName = name.lastName
```

###### 3.1.5 使用delegate、protocol时，注意循环引用问题。一般而言，此类属性命名，需要声明为`weak`。
###### 3.1.6 在escaping闭包中直接调用self，注意循环引用问题。使用[capture list](https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-XID_163)解决。

```
myFunctionWithEscapingClosure() { [weak self] (error) -> Void in
    // you can do this

    self?.doSomething()

    // or you can do this

    guard let strongSelf = self else {
        return
    }

    strongSelf.doSomething()
}
```

###### 3.1.7 不要使用可标记的Breaks。

###### 3.1.8 不要在控制流谓词上添加括号。

```
// PREFERRED
if x == y {
    /* ... */
}

// 不推荐
if (x == y) {
    /* ... */
}
```

###### 3.1.9 在enum枚举中：避免写出enum完整方式，尽可能使用简写方式。

```
// PREFERRED
imageView.setImageWithURL(url, type: .person)

// 不推荐
imageView.setImageWithURL(url, type: AsyncImageView.Type.person)
```
###### 3.1.10 在类方法中：避免使用缩写方式，因为从类方法中推断上下文通常比较困难。

```
// PREFERRED
imageView.backgroundColor = UIColor.white

// NOT PREFERRED
imageView.backgroundColor = .white
```

###### 3.1.11 除非必要，不使用`self.`。

###### 3.1.12 书写方法，是否考虑其后续被重写。
> 1. 若后续重写，则不需要考量。
> 2. 若后续不重写，需使其标记为`final`。（有助于优化编译时间）
> 3. 注：在Library中和在主项目中使用`final`，意义不同。


###### 3.1.13 使用诸如`else`、`catch`等语法时，其后跟随block块。遵循`1TBS style`。

```
if someBoolean {
    // do something
} else {
    // do something else
}

do {
    let fileContents = try readFile("filename.txt")
} catch {
    print(error)
}
```

###### 3.1.14 定义类函数或类属性时，推荐使用`static`而非`class`。
* 仅当在子类中重写类方法或属性时，使用`class`。当然此时更推荐使用`protocol`技术作为替代方案。

###### 3.1.15 若函数无参数，无歧义，且有返回值。可以考虑使用计算属性来实现。


> demo TODO:




#### 3.2 访问权限修饰符

###### 3.2.1 权限修饰符写在最前：

```
// PREFERRED
private static let myPrivateNumber: Int
// NOT PREFERRED
static private let myPrivateNumber: Int
```

###### 3.2.2 修饰符需与要修饰语句在同一行，不应隔行展示:
```
// PREFERRED
open class Pirate {
    /* ... */
}
// NOT PREFERRED
open
class Pirate {
    /* ... */
}
```

###### 3.2.3 一般情况下，不必显式的添加`internal `修饰符，因它是访问权限默认值。

###### 3.2.4 若某属性需在单元测试中可访问，则更改修饰符为`internal`,并使用`@testable import ModuleName`。
> 若属性本应修饰为`private`，但为了单元测试，更改为`internal`。记得添加文本注释解释原因。如下使用warning标记语法阐述之：

```
/**
 This property defines the pirate's name.
 - warning: Not `private` for `@testable`.
 */
let pirateName = "LeChuck"
```

###### 3.2.5 若可能，尽量使用`private`而非`fileprivate`。

###### 3.2.6 当需在`public`和`open`修饰符中选择其一时：
1. 使用open：当需要在给定模块Module外部子类化时。
2. 否则使用public。

> 注：open、public和internal修饰符使用`@testable import`测试时，均可子类化。所以测试目的并不是使用open的原因。
> 
> 一般而言，在Lib库中时，使用open自由度较高的修饰符；在代码库中的模块中，偏向于使用较为保守的修饰符，如在app内部，同步更改较为容易。（翻译不精确，可参考原文）


#### 3.3 自定义运算符


* 建议为自定义运算符创建命名函数

* 如果你想引入一个自定义的操作符，确保你有一个很好的理由，解释为什么要引入一个新的操作符到全局范围，而不是使用其他的构造。

* 你可以覆盖现有的运算符来支持新的类型（特别是==）。 但是，您的新定义必须保留运算符的语义。 例如，==必须总是测试相等并返回一个布尔值。

#### 3.4 Switch 语句和 enum

###### 3.4.1 使用switch语句时，若检测的是有限集合分支，则不需添加`default case`，代之以：将未使用的案例放在底部，并使用break关键字来防止执行。

###### 3.4.2 因在swift中每个case后面是隐式具有break功能的，若无必要，无需再次手动追加break关键字。

###### 3.4.3 case语句应按照Swift默认标准与switch语句本身保持一致。

###### 3.4.4 当定义的case 具有关联值，确保这个值也被恰当地标记。（如`case hunger(hungerLevel: Int)`而非`case hunger(Int)`）

```
enum Problem {
    case attitude
    case hair
    case hunger(hungerLevel: Int)
}

func handleProblem(problem: Problem) {
    switch problem {
    case .attitude:
        print("At least I don't have a hair problem.")
    case .hair:
        print("Your barber didn't know when to stop.")
    case .hunger(let hungerLevel):
        print("The hunger level is \(hungerLevel).")
    }
}
```

###### 3.4.5 若可能，尽量使用值列表展示（如 `case 1,2,3`），而非`fallthrough `。

###### 3.4.6 若你有一个`default case`,不应被适配。建议使用error throw来完善。（其它类似技术均可，如asserting）

```
func handleDigit(_ digit: Int) throws {
    switch digit {
    case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
        print("Yes, \(digit) is a digit!")
    default:
        throw Error(message: "The given number was not a digit.")
    }
}
```

#### 3.5 Optionals

###### 3.5.1 唯一一次你应该使用隐式解包选项`optional`是@IBOutlets。 在其他情况下，最好使用非可选non-optional或常规的`ptional`可选属性。 是的，在某些情况下，除非您可以“保证”使用该属性时永远不会为nil，但最好是安全一致。 不要使用强制解包。

###### 3.5.2 不要使用`	as!`、`try!`。

###### 3.5.3 如果不打算实际使用存储在可选项中的值，但是需要确定该值是否为零，则建议显式检查该值是否为nil，而不是使用`if let`语法。

```
// PREFERERED
if someOptional != nil {
    // do something
}

// NOT PREFERRED
if let _ = someOptional {
    // do something
}
```

###### 3.5.4 不要使用`unowned`。 你可以认为`unowned`等价于一个隐含unwraped的`weak`属性（虽然`unowned`完全忽略引用计数，性能上有轻微的改进）。 既然我们不想有隐含的解包，我们同样不想要`unowned`修饰的属性。
```
// PREFERRED
weak var parentViewController: UIViewController?

// NOT PREFERRED
weak var parentViewController: UIViewController!
unowned var parentViewController: UIViewController
```

###### 3.5.5 当unwraping optionals时，在适当的场景下使用相同的名称来表示常量或变量。

```
guard let myValue = myValue else {
    return
}
```

#### 3.6 Protocols

当实现某协议时，有两种代码组织方式：

1. 使用`// MARK:`注释来隔离协议实现与其它代码段。
2. 在`class、struct`实现代码外添加扩展extension来实现协议。（但仍在同一个文件中）

> 注：当使用扩展时，扩展中的方法不能被子类覆盖重写，这会使测试变得困难。 如果这是一个常见的用例，那么坚持使用`方法#1`来保持一致性可能会更好。 否则，使用`方法＃2`可以更清楚地分离关注点。
> 
> 即使在使用`方法＃2`时，无论如何也要添加`// MARK：`语句，以便在Xcode的`method / property / class /`等中更易读。 列表UI。


#### 3.7 Properties

###### 3.7.1 若创建一个只读的，计算的属性，提供的getter方法，无需`get {}`。

```
var computedProperty: String {
    if someBool {
        return "I'm a mighty pirate!"
    }
    return "I'm selling these fine leather jackets."
}
```

###### 3.7.2 当使用` get {}`, `set {}`, `willSet`, `didSet`, 注意blocks区块缩进。

###### 3.7.3 尽管可以为`willSet`、`didSet`和`set`创建新值或旧值的自定义名称，但推荐使用默认提供的标准newValue / oldValue标识符。

```
var storedProperty: String = "I'm selling these fine leather jackets." {
    willSet {
        print("will set to \(newValue)")
    }
    didSet {
        print("did set from \(oldValue) to \(storedProperty)")
    }
}

var computedProperty: String  {
    get {
        if someBool {
            return "I'm a mighty pirate!"
        }
        return storedProperty
    }
    set {
        storedProperty = newValue
    }
}
```

###### 3.7.4 单例属性声明如下：

```
class PirateManager {
    static let shared = PirateManager()

    /* ... */
}
```

#### 3.8 Closures闭包


###### 3.8.1 如果参数的类型是明显的，可以省略类型名称，但是显式的也是可以的。 有时通过添加明确的细节，有时通过重复的部分，增强可读性 - 使用你最好的判定方案。

```
// omitting the type
doSomethingWithClosure() { response in
    print(response)
}

// explicit type
doSomethingWithClosure() { response: NSURLResponse in
    print(response)
}

// using shorthand in a map statement
[1, 2, 3].flatMap { String($0) }
```

###### 3.8.2 如果指定一个闭包为某个确定的类型时，不需要用圆括号包装它，除非它是必需的。（例如，如果该类型是可选的，或者闭包在另一个闭包中）。
> 总是将闭包内的参数封装在一组圆括号中:use（）指示没有参数,并使用Void来表示没有返回。

```
let completionBlock: (Bool) -> Void = { (success) in
    print("Success? \(success)")
}

let completionBlock: () -> Void = {
    print("Completed!")
}
//需要以（）包装的类型
let completionBlock: (() -> Void)? = nil
```

###### 3.8.3 如果没有太多的水平溢出，尽量将`参数名称列表`保持在与封闭的`左括号`相同的行上。
> 确保一行少于160个字符

###### 3.8.4 使用`尾随闭包语法`，除非闭包的含义在没有参数名称的情况下不明显（例如，如果方法有成功和失败闭包的参数）。
```
// trailing closure
doSomething(1.0) { (parameter1) in
    print("Parameter 1 is \(parameter1)")
}

// no trailing closure
doSomething(1.0, success: { (parameter1) in
    print("Success with \(parameter1)")
}, failure: { (parameter1) in
    print("Failure with \(parameter1)")
})
```

#### 3.9 Arrays

###### 3.9.1 访问数组方式：
1. 通常，避免直接使用下标访问数组。 
2. 如果可能的话，使用访问器，如`.first`或`.last`，这是可选的，不会崩溃。 
3. 在可能的情况下，优先使用`for item in items`语法，而不是`for i in 0 ..< items.count`语法。
4.  如果您需要直接访问数组下标，请确保进行适当的边界检查。 您可以在`items.enumerated（）`中使用`for（index，value）`来获取索引和值。

###### 3.9.2 数组操作：
1. 切勿使用`+ =`或`+`运算符将元素追加/连接到数组。 代之以，使用`.append（）`或`.append（contentsOf :)`，因为这些在Swift的当前状态下性能更高（至少就编译而言）。
2.  如果你正在声明一个基于其他数组的数组，并希望保持它不可变，使用`let myNewArray = [arr1，arr2] .joined（）`,而非`myNewArray = arr1 + arr2，`。

#### 3.10 Error Handling

1. 假设函数myFunction应该返回一个字符串，但是，在某些时候它可能会出现错误。 一个常用的方法是让这个函数返回一个可选的String？ 如果出现问题，我们将返回nil。

	```
 func readFile(named filename: String) -> String? {
     guard let file = openFile(named: filename) else {
        return nil
     }

     let fileContents = file.read()
     file.close()
     return fileContents
   }
 //
 func printSomeFile() {
     let filename = "somefile.txt"
     guard let fileContents = readFile(named: filename) else {
        print("Unable to open file \(filename).")
        return
     }
     print(fileContents)
  }
	```

2. 1的替代方案：适当场景使用Swift的try / catch行为来了解失败的原因。

	```
	//struct定义
	struct Error: Swift.Error {
    public let file: StaticString
    public let function: StaticString
    public let line: UInt
    public let message: String

    public init(message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.file = file
        self.function = function
        self.line = line
        self.message = message
     }
	}
	```
	
	```
	//应用
	func readFile(named filename: String) throws -> String {
    guard let file = openFile(named: filename) else {
        throw Error(message: "Unable to open file named \(filename).")
    }

    let fileContents = file.read()
    file.close()
    return fileContents
   }
//
   func printSomeFile() {
     do {
         let fileContents = try readFile(named: filename)
         print(fileContents)
      } catch {
         print(error)
      }
    }
	```
	
> 有一些例外，更倾向于使用方案1而不是方案2。 当结果在语义上可能为nil而不是在检索结果时出错的情况下，返回`optional`值更有意义，而不是使用错误处理。
> 
> 一般而言，假如方法可以`失败`，并且失败的原因并不能使用返回值类型明显的描述出来，则使用方案2更为合适。


#### 3.11 使用`guard`语法

###### 3.11.1 一般来说，我们倾向于使用“早期return”策略，而不是在`if`语法嵌套代码。 对这个用例使用guard语句通常是有帮助的，且可以提高代码的可读性。

```
// PREFERRED
func eatDoughnut(at index: Int) {
    guard index >= 0 && index < doughnuts.count else {
        // return early because the index is out of bounds
        return
    }

    let doughnut = doughnuts[index]
    eat(doughnut)
}

// NOT PREFERRED
func eatDoughnut(at index: Int) {
    if index >= 0 && index < doughnuts.count {
        let doughnut = doughnuts[index]
        eat(doughnut)
    }
}
```

###### 3.11.2 当展开`optionals`时，首选guard语法而不是if语句来减少代码中嵌套缩进量。

```
// PREFERRED
guard let monkeyIsland = monkeyIsland else {
    return
}
bookVacation(on: monkeyIsland)
bragAboutVacation(at: monkeyIsland)

// NOT PREFERRED
if let monkeyIsland = monkeyIsland {
    bookVacation(on: monkeyIsland)
    bragAboutVacation(at: monkeyIsland)
}

// EVEN LESS PREFERRED
if monkeyIsland == nil {
    return
}
bookVacation(on: monkeyIsland!)
bragAboutVacation(at: monkeyIsland!)
```

###### 3.11.3 当不涉及展开`optionals`时，决定是使用if语句还是使用guard语句，最重要的是要注意代码的可读性。 
>  这里有很多可能的情况，比如依赖于两个不同的布尔值；一个涉及多重比较的复杂逻辑语句等。所以一般来说，用你最好的判断来编写可读性高的代码。 如果你不确定用`guard`还是`if`，或者无法判定哪个可读性更高，或者看起来可读性相同，则推荐使用`guard`。

```
// an `if` statement is readable here
if operationFailed {
    return
}

// a `guard` statement is readable here
guard isSuccessful else {
    return
}

// double negative logic like this can get hard to read - i.e. don't do this
guard !operationFailed else {
    return
}
```


###### 3.11.4 如果在两种不同状态之间进行选择，则使用if语句更有意义而不是guard语句。

```
// PREFERRED
if isFriendly {
    print("Hello, nice to meet you!")
} else {
    print("You have the manners of a beggar.")
}

// NOT PREFERRED
guard isFriendly else {
    print("You have the manners of a beggar.")
    return
}

print("Hello, nice to meet you!")
```


###### 3.11.5  当前上下文中，当且仅当失败时退出流程，应使用`guard`。 
> 下面是一个使用两个if语句更有意义,而不是使用两个`guard`的例子.我们有两个不相关的条件，不应该相互阻塞。

```
if let monkeyIsland = monkeyIsland {
    bookVacation(onIsland: monkeyIsland)
}

if let woodchuck = woodchuck, canChuckWood(woodchuck) {
    woodchuck.chuckWood()
}
```


###### 3.11.6 通常，我们可能遇到一种情况:即需要使用`guard`语法来展开多个`optionals`。 
> 一般来说，如果处理每个解包的失败结果是相同的（例如，一个`return`, `break`, `continue`, `throw`, `@noescape`），则将解包合并为单个`guard`语法。

```
// combined because we just return
guard let thingOne = thingOne,
    let thingTwo = thingTwo,
    let thingThree = thingThree else {
    return
}

// separate statements because we handle a specific error in each case
guard let thingOne = thingOne else {
    throw Error(message: "Unwrapping thingOne failed.")
}

guard let thingTwo = thingTwo else {
    throw Error(message: "Unwrapping thingTwo failed.")
}

guard let thingThree = thingThree else {
    throw Error(message: "Unwrapping thingThree failed.")
}
```

###### 3.11.7 使用`guard`语法不要单行展示。

```
// PREFERRED
guard let thingOne = thingOne else {
    return
}

// NOT PREFERRED
guard let thingOne = thingOne else { return }
```


## 4. 文档、注释

#### 4.1 文档

1. 如果一个函数比一个简单的O（1）操作更复杂，那么通常来说，应该考虑为该函数添加一个doc文档注释，因为可能有一些信息无法通过方法签名轻易的获取到。 
2. 如果函数的实现有什么奇怪的方式，无论技术上是否有趣、棘手、不明显等，这都应该添加doc记录。
3. 复杂的`类`、`结构`、`枚举`、`协议`和`属性`等均应为其添加文档。 
4. 所有公开的`函数`、`类`、`属性`、`常量`、`结构`、`枚举`、`协议`等，也应为其添加文档。（他们的签名/名称不能显式的描述其意义/功能）

* 务必查看[苹果文档](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/Attention.html#//apple_ref/doc/uid/TP40016497-CH29-SW1)中有关Swift注释标记中提供的全部功能。

###### 4.1.1 160个字符的列限制。(如代码)

###### 4.1.2 即使文档注释占用一行，也使用注释块（/ ** * /）。

###### 4.1.3 不要在每个附加行加上*。

###### 4.1.4 使用新的`- parameter`语法，而不是旧的`：param：`语法（确保使用小写`parameter `，而不是大写`Parameter `）。 
> 按住`option`键，点击你写的方法，使用快速帮助检测注释是否正确。

```
class Human {
    /**
     This method feeds a certain food to a person.

     - parameter food: The food you want to be eaten.
     - parameter person: The person who should eat the food.
     - returns: True if the food was eaten by the person; false otherwise.
    */
    func feed(_ food: Food, to person: Human) -> Bool {
        // ...
    }
}
```
###### 4.1.5  如果你要doc记录一个方法的参数/返回/抛出，即使一些文档最终有些重复（最好的文档看起来也不完善）。 有时候，如果只有一个参数需要证明文件，那么只需在说明中提到它就可以了。

###### 4.1.6 对于复杂的类，推荐用一些可能的例子来描述类的用法。 
> 注：`markdown `语法在Swift注释文档中是有效的。 换行符、列表因此是适合的。

```
/**
 ## Feature Support

 This class does some awesome things. It supports:

 - Feature 1
 - Feature 2
 - Feature 3

 ## Examples

 Here is an example use case indented by four spaces because that indicates a
 code block:

     let myAwesomeThing = MyAwesomeClass()
     myAwesomeThing.makeMoney()

 ## Warnings

 There are some things you should be careful of:

 1. Thing one
 2. Thing two
 3. Thing three
 */
class MyAwesomeClass {
    /* ... */
}
```

###### 4.1.7 设计代码注释部分，使用 `

```
/**
 This does something with a `UIViewController`, perchance.
 - warning: Make sure that `someValue` is `true` before running this function.
 */
func myFunction() {
    /* ... */
}
```

###### 4.1.8 书写doc文档时，倾向于简介明了。


#### 4.2 其它注释指南：

###### 4.2.1 `//`之后，注释之前，添加一个空格。
###### 4.2.2 总是注释自身所在的行。
###### 4.2.3 当使用`// MARK`时,无论如何，在注释之后添加一换行符。

```
class Pirate {

    // MARK: - instance properties

    private let pirateName: String

    // MARK: - initialization

    init() {
        /* ... */
    }

}
```
