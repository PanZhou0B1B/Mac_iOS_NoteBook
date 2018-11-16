原文链接：[https://swift.org/documentation/api-design-guidelines/](https://swift.org/documentation/api-design-guidelines/)


## 基本原则

* **代码明晰**是你主要目标。实体诸如方法和属性，一次声明，往往会被使用多次。故设计APIs时尽量使之清晰并且简练。评估某个API设计是否合理，单从阅读其声明并不足以下结论，往往需要在真实示例下，才能确保它在上下文中是清晰正确的。
* **明晰优先于简练**。尽管Swift代码可以书写的非常紧凑简练，但实现最少代码量并非是我们的目标。Swift代码的简练，只是`强类型系统和自然降低功能样板`产生的附加效果而已。
* 为每个声明**书写文档注释**。通过书写文档获得的经验见解会对你的设计产生深远的影响，所以不要忽视之。

	> 如果你无法使用简洁的术语描述你的APIs功能，那么你可能设计了错误的APIs。
	
###### 详情

* **使用Swift的[Markdown语法](https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/)**。
* **以摘要开始**，描述声明实体的功能。一般的，通过其声明和摘要信息，API会被人清晰的理解。

	```
	/// Returns `self`的"view"逆向集合。即包含相同元素，但顺序相反。
func reversed() -> ReverseCollection
	```
	* **专注于摘要：**这是最为重要的部分。很多优秀的文档注释只包含一个优质的摘要，别无它物。
	* 尽可能**使用单句片段**，并以句点结束。不要使用完整冗长的句子。
	* **描述方法或函数的功能和返回值**，忽略无意义的null功能和Viod返回：

		```
	/// 在`self`起始处插入 `newHead` 。
mutating func prepend(_ newHead: Int)
/// 返回一个包含`head`并由`self`跟随的列表。func prepending(_ head: Element) -> List
/// 若self非空，删除并返回第一个元素;
/// 否则返回`nil`。
mutating func popFirst() -> Element?
		```
	提示：在极少数情况下，如上面的popFirst，摘要是由分号分隔的多个句子片段组成。
	* **下标注释**：即描述下标访问的内容：

		```
		/// 访问下标为 第`index`个的元素。
subscript(index: Int) -> Element { get set }
		```
		
	* **构造方法**：即描述初始化方法创建的内容：

		```
		/// 创建实例：该实例中包含n个`x`。
init(count n: Int, repeatedElement x: Element)
		```
		
	* **其它声明类场景，所声明的实体务必描述清晰。**

		```
		/// 集合对象：在任何位置均支持同等高效的插入、删除操作。
struct List {
  /// `self`非空，`self`的首个元素；
  ///否则，返回`nil`。
  var first: Element?
  ...
		```
		
* **（可选）**，连续使用一个或多个段落和项目符号项。段落用空行分隔并使用完整的句子。

	```
	/// 将`items`中每个元素的文本表示，执行标准输出。   ← 摘要
///                                              ← 空行
/// 每个元素`x`的文本表示均由`String(x)`表达式生成 ← 补充说明
///
/// - 参数 separator: 元素之间的打印文本。           ⎫
/// - 参数 terminator: 结尾打印的文本               ⎬ 参数部分
///                                              ⎭
/// - 备注: 若不要在结尾新起一行，
///则置`terminator: ""`即可。                      ⎫
///- 其它关联: `CustomDebugStringConvertible`,     ⎬ 命令符号
///   `CustomStringConvertible`, `debugPrint`.   ⎭
public func print(
  _ items: Any..., separator: String = " ", terminator: String = "\n")
	```
	
	* 在适当场景，在摘要之外使用**[可识别的符号文档标记元素](https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html#//apple_ref/doc/uid/TP40016497-CH51-SW1)**添加信息。
	* **使用[符号命令语法](https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html#//apple_ref/doc/uid/TP40016497-CH51-SW13)，使用已识别的项目符号。**

	> 流行的IDE工具（如Xcode）对以下关键字开头的项目符号进行了特殊的处理:
	
	|关键字|||
	|:--:|:--:|:--:|:--:|
	|Attention|Author|Authors|Bug|
	|Complexity|Copyright|Date|Experiment|
	|Important|Invariant|Note|Parameter|
	|Parameters|Postcondition|Precondition|Remark|
	|Requires|Returns|SeeAlso|Since|
	|Throws|ToDo|Version|Warning|
	
	
## 命名

###### 提高明晰方法

* 为了便于阅读代码，在进行命名时，要**涵盖所有必须的单词，以避免歧义**。

	> 例如，一个方法：在集合中删除给定位置的元素。
	
	```
	code1:✅
	extension List {
  public mutating func remove(at position: Index) -> Element
}
employees.remove(at: x)
	```
	如果我们从方法签名中省略单词`at`，则可能使读者认为该方法是用于搜索并删除等于x的元素，而不是使用x来指示要删除的元素的位置。
	
	```
	code2:❎
	employees.remove(x) // 不清晰：是删除x吗？
	```

* **务必忽略不必须的单词。**命名中的每个单词都应在使用场景中传达重要的信息。

	有时需要更多的单词来阐明意图或消除歧义，但应省略那些众所周知的冗余词。特别是要省略那些仅为重复类型信息的单词。
	
	```
	code:❎
	public mutating func removeElement(_ member: Element) -> Element?
allViews.removeElement(cancelButton)
	```
	
	在该示例中，`Element `在调用场景中没有传达任何重要信息，故该API可优化为：
	
	```
	code:✅
	public mutating func remove(_ member: Element) -> Element?
allViews.remove(cancelButton) // clearer
	```
	
	有时，重复类型信息对于避免歧义是有必要的。但通常而言，最好使用**描述参数角色而不是其类型**的单词。有关详细信息，请参阅下一项。
	
* **根据角色来命名变量，参数和关联类型，**而不是根据类型约束。

	```
	code:❎
	var string = "Hello"
protocol ViewController {
  associatedtype ViewType : View
}
class ProductionLine {
  func restock(from widgetFactory: WidgetFactory)
}
	```
	
	以这种方式重新定位类型名称无法优化清晰度和表现力。相反，努力选择一个表达实体角色的名称反而更好。
	
	```
	code: ✅
	var greeting = "Hello"
protocol ViewController {
  associatedtype ContentView : View
}
class ProductionLine {
  func restock(from supplier: WidgetFactory)
}
	```
	
	如果关联类型与其协议约束紧密绑定以使协议名称为角色，请通过将`Protocol `附加到协议名称来避免冲突：
	
	```
	protocol Sequence {
  associatedtype Iterator : IteratorProtocol
}
protocol IteratorProtocol { ... }
	```
	
* **补偿弱类型信息**以阐明参数的作用。

	尤其当参数类型是`NSObject`，`Any`，`AnyObject`或诸如Int或String的`基本类型`时，类型信息和在使用处的上下文可能无法完全传达意图。 在此示例中，声明可能是明确的，但使用点是模糊的：
	
	```
	code：❎
	func add(_ observer: NSObject, for keyPath: String)
grid.add(self, for: graphics) // 模糊
	```
	
	为了恢复清晰度，在每个弱类型参数前面加上描述其角色的名词：
	
	```
	code：✅
	func addObserver(_ observer: NSObject, forKeyPath path: String)
grid.addObserver(self, forKeyPath: graphics) // 清晰
	```
	
###### 力求流畅使用

* 使用标准英语语法规则来命名方法和函数。

	```
	code: ✅
	x.insert(y, at: z)          “x, insert y at z”
x.subViews(havingColor: y)  “x's subviews having color y”
x.capitalizingNouns()       “x, capitalizing nouns”
	```
	
	```
	code: ❎
	x.insert(y, position: z)
x.subViews(color: y)
x.nounCapitalize()
	```
	
	在第一个或第二个参数之后，当这些参数不是调用方法的核心时，流利性降级是可以接受的。即如果不影响方法要表达的含义，那可以简化第一个或者前两个参数，这样使用起来更加流畅。
	
	```
	AudioUnit.instantiate(
  with: description, 
  options: [.inProcess], completionHandler: stopProgressBar)
	```
	
* **用`make`前缀开始工厂方法的名称命名。**如 x.makeIterator()。
* **构造方法和工厂方法**调用的第一个参数不应该形成以基本名称开头的短语。如  x.makeWidget(cogCount: 47)。

	例如，这些调用方法的第一个参数不会作为与基本名称相同的短语的一部分读取：
	
	```
	code: ✅
	let foreground = Color(red: 32, green: 64, blue: 128)
let newPart = factory.makeWidget(gears: 42, spindles: 14)
let ref = Link(target: destination)
	```
	
	在以下示例中，API作者尝试使用第一个参数创建语法连续性：
	
	```
	code: ❎
	let foreground = Color(havingRGBValuesRed: 32, green: 64, andBlue: 128)
let newPart = factory.makeWidget(havingGearCount: 42, andSpindleCount: 14)
let ref = Link(to: destination)
	```
	
	实际上，此准则以及[参数标签](https://swift.org/documentation/api-design-guidelines/#argument-labels)的准则意味着第一个参数将具有标签，除非调用正在执行[值保留类型转换](https://swift.org/documentation/api-design-guidelines/#type-conversion)。
	
	```
	let rgbForeground = RGBColor(cmykForeground)
	```
	
* 根据副作用命名函数和方法。

	* 那些没有副作用的函数和方法应该读作是一个名词词组。如`x.distance(to: y)`, `i.successor().`
	* 那些有副作用的函数和方法应该读作是一个命令式的动词短语。如` print(x)`, `x.sort()`, `x.append(y)`。
	* **命名名称一致的Mutating/nonmutating方法对。**变异方法通常具有一个类似语义的非突变变体，但返回新值而不是就地更新实例。

		* 当操作方法由动词自然描述时，使用动词对变异方法进行命名，而应用“ed”或“ing”后缀来命名对应的其非变异方法。

		| Mutating | Nonmutating |
		|:--:|:--:|
		|x.sort()|z = x.sorted()|
		|x.append(y)|z = x.appending(y)|
		
		
	   * 更倾向于使用[动词的过去分词](https://en.wikipedia.org/wiki/Participle)命名非变异变体（通常附加`ed`）

		```
		/// 即刻逆向 `self`。
mutating func reverse()
/// 返回self的逆向拷贝。
func reversed() -> Self
...
x.reverse()
let y = x.reversed()
		```
		
		* 当添加`ed`不具有语法性，因为动词具有直接对象时，使用动词的当前分词命名非变异变体，通过附加“ing”。(应为语法问题)

		```
		/// 过滤掉self中空行
mutating func stripNewlines()
/// 返回self的拷贝，该拷贝过滤掉了所有的空行。
func strippingNewlines() -> String
...
s.stripNewlines()
let oneLine = t.strippingNewlines()
		```
		
	* 当操作方法由名词描述时，使用名词作为非突变方法。并使用`form`前缀来命名其对应的变异方法。

	| Nonmutating | Mutating |
	|:--:|:--:|
	|x = y.union(z)| y.formUnion(z)|
	|j = c.successor(i)|c.formSuccessor(&i)|
	
* 当使用非突变方法时，布尔方法和属性的使用在接收者看来，应为断言的形式。如：`x.isEmpty`, `line1.intersects(line2)`.
* 描述类的协议应该以名词命名。如`Collection `。
* 功能类的协议应以后缀为`able`，`ible`或`ing`的单词命名。如`Equatable`, `ProgressReporting`。
* 其它类型，诸如属性、变量、常量应以名词来命名。


###### 更好的使用术语

名词 - 在特定领域或专业中具有精确、专门意义的词或短语。

* 如果一个更常见的词语同样传达了相同意义，**则避免使用模糊术语** 。如果`皮肤`能够阐述您的目的，请不要说`表皮`。艺术品是一种必不可少的沟通工具，但只应用于捕捉原本会丢失的重要意义。
* 如果您使用艺术术语，请**坚持使用它既定的意义**。

	使用技术术语而不是更常见的单词，其唯一原因是它可以更精确地表达一些本来会模棱两可或不清楚的东西。因此，API应严格使用术语。
	
	* **勿使专家惊讶。**如果我们为众所周知的术语发明了新的含义，任何已经熟悉它的人都会感到惊讶或愤怒。
	* 不要迷惑初学者：任何试图学习该术语的人都可能会进行网络搜索并找到其传统的原始意义。

* **避免使用缩写**。缩写，尤其是非标准的缩写，实际上是术语，因为理解依赖于正确地将它们翻译成非缩写形式。

	> 您使用的任何缩写的含义,都可在网络找到。即众所周知的含义。
	
* **拥抱先例**。不要以牺牲与现有文化的一致性为代价来为初学者优化术语。

	命名连续数据结构为`Array`比使用简单术语（如List）更好，即使初学者可能更容易理解`List`的含义。 `Array`是现代计算的基础，因此每个程序员都应该知道 - 或者很快就会学到 - `Array`的概念。 使用大多数程序员都熟悉的术语，他们的问题搜索将很快得到解决。
	
	在特定的编程域中，例如数学，诸如sin（x）之类的广泛使用的术语，要优于诸如`verticalPositionOnUnitCircleAtOriginOfEndOfRadiusWithAngle（x）`的解释性短语。 请注意，在这种情况下，先例超过了指南中避免缩写的规定：虽然完整的单词是`sine`，但是`sin（x）`在程序员中已经普遍使用了几十年，并且在几个世纪的数学家中也是如此。
	

## 代码规范

###### 通用规范

* **任何复杂度不是O(1)的计算属性，均要注释。**人们通常认为属性访问不涉及重要的计算，因为他们在心理上将属性作为存储类型了。当一反常态时，需要备注提醒。
* **首选方法和属性实现而非函数。**自由函数仅在以下特例中使用：

	1. 无显式self：

		> min(x,y,z)
	
	2. 函数是无约束的泛型时：

		> print(x)
		
	3. 函数语法是已建立的域表示法的一部分时:

		> sin(x)
		
* **命名规范：**类型和协议的命名遵循大驼峰命名法，其他一切都遵循小驼峰命名法。

	[缩略语和首字母缩略词](https://en.wikipedia.org/wiki/Acronym):通常在美式英语中显示为大写.应根据拼写规范统一大写或小写。
	
	```
	var utf8Bytes: [UTF8.CodeUnit]
var isRepresentableAsASCII = true
var userSMTPServer: SecureSMTPServer
	```
	
	其他首字母缩略词应视为普通词:
	
	```
	var radarDetector: RadarScanner
var enjoysScubaDiving = true
	```
	
* 当方法具有相同的基本含义或在不同的域中操作时，**方法可以共用基本名称。**

	例如，以下方案值得推荐，因为这些方法的功能基本上是相同的：
	
	```
	code: ✅
	extension Shape {
  /// 返回 `true` ，假如 `other` 点在`self`面积之内.
  func contains(_ other: Point) -> Bool { ... }

  /// 返回 `true` 假如 `other` 图形完全在 `self`之内.
  func contains(_ other: Shape) -> Bool { ... }

  /// 返回 `true` 假如 `other`线条在 `self`之内.
  func contains(_ other: LineSegment) -> Bool { ... }
}
	```
	
	由于几何类型和集合是不同的域，因此在同一程序中也可以：
	
	```
	code: ✅
	extension Collection where Element : Equatable {
  /// 返回 `true` 假如 `self` 包含一个同 `sought`相同的元素.
  func contains(_ sought: Element) -> Bool { ... }
}
	```
	
	当然，这些索引方法具有不同的语义，并且应该以不同的方式命名：
	
	```
	code: ❎
	extension Database {
  /// 重建数据库的搜索索引
  func index() { ... }

  /// 返回给定表中的第n行
  func index(_ n: Int, inTable: TableID) -> TableRow { ... }
}
	```
	
	最后，避免“在返回类型上重载”，因为它会在存在类型推断时引起歧义：
	
	```
	code: ❎
	extension Box {
  /// 返回存储在`self`中的`Int`值，否则，返回`nil`
  func value() -> Int? { ... }

  /// 返回存储在`self`中的`String `值，否则，返回`nil` 
  func value() -> String? { ... }
}
	```
	
	
	
###### 参数

> func move(from start: Point, to end: Point)


* **选择参数名称以供文档注释。**即使参数名称没有出现在函数或方法的使用点，它们也起着重要的解释作用。

	选择这些名称可以使文档易于阅读。例如，以下这些名称使文档阅读理解更加自然：
	
	```
	code: ✅
	/// 返回满足`predicate`断言的，并包含`self`的元素集合 
func filter(_ predicate: (Element) -> Bool) -> [Generator.Element]
/// 以`newElements`替换给定 `subRange`范围的集合。
mutating func replaceRange(_ subRange: Range, with newElements: [E])
	```
	
	当然，以下例子使文档变得笨拙和不合语法：
	
	```
	code: ❎
	/// 返回满足`includedInResult `断言的，并包含`self`的元素集合 .
func filter(_ includedInResult: (Element) -> Bool) -> [Generator.Element]
/// 以`with `替换给定 `r `范围的集合。
mutating func replaceRange(_ r: Range, with: [E])
	```
	
* 一般场景时，**合理利用默认参数。**某一参数在大多数场景下都是某个固定值，比较适合设置默认参数。

	默认参数通过隐藏不相关的信息来提高可读性。例如：
	
	```
	code: ❎
	let order = lastName.compare(
  royalFamilyName, options: [], range: nil, locale: nil)
	```
	
	可以更为简洁：
	
	```
	let order = lastName.compare(royalFamilyName)
	```

	默认参数通常比使用方法集更可取，因为它们会降低理解API的认知负担。
	
	```
	code: ✅
	extension String {
  /// ...description...
  public func compare(
     _ other: String, options: CompareOptions = [],
     range: Range? = nil, locale: Locale? = nil
  ) -> Ordering
}
	```
	
	上述方案可能并不简单，但相比方法集，足够简洁：
	
	```
	code: ❎
	extension String {
  /// ...description 1...
  public func compare(_ other: String) -> Ordering
  /// ...description 2...
  public func compare(_ other: String, options: CompareOptions) -> Ordering
  /// ...description 3...
  public func compare(
     _ other: String, options: CompareOptions, range: Range) -> Ordering
  /// ...description 4...
  public func compare(
     _ other: String, options: StringCompareOptions,
     range: Range, locale: Locale) -> Ordering
}
	```
	
	方法集合的每个成员都需要单独的文档注释，并由用户理解。用户需要完全理解它们，才能选择最优方法。 偶尔也会出现令人惊讶的问题 - 例如，`foo（bar：nil）`和`foo（）`并不总是同等的 - 文档繁琐，差异却微小。 使用含默认值单一方法可提供极其优越的编程体验。
	
* **默认参数应放置在参数列表的末尾。**没有默认值的参数通常对于方法的语义更为重要，并且在调用方法时提供稳定的初始使用模式。


###### 参数标签

> func move(from start: Point, to end: Point)
> 
> x.move(from: x, to: y) 


* **在无法有效区分参数时省略所有标签**

	如：`min(number1, number2)`,`zip(sequence1, sequence2).`
	
* 在执行`值保留类型转换`的构造器中，省略第一个参数标签。

	第一个参数应该始终是转换的来源：
	
	```
	extension String {
  // 将`x`转换为给定基数中的文本表示
  init(_ x: BigInt, radix: Int = 10)   ← Note the initial underscore
}
text = "The value is: "
text += String(veryLargeNumber)
text += " and in hexadecimal, it's"
text += String(veryLargeNumber, radix: 16)
	```
	
	但是，在“缩小”类型转换中，添加描述缩小的标签是有必要的。
	
	```
	extension UInt32 {
  /// Creates an instance having the specified `value`.
  init(_ value: Int16)            ← Widening, so no label
  /// 创建一个具有最低32位“source”的实例 `source`.
  init(truncating source: UInt64)
  /// 创建近似于`valueToApproximate`的实例 
  init(saturating valueToApproximate: UInt64)
}
	```
	
	`值保持类型转换`是[单态的](https://en.wikipedia.org/wiki/Monomorphism)，即原始值的每个差异均会导致结果值的差异。 例如，从Int8到Int64的转换是值保留的，因为每个不同的Int8值都转换为不同的Int64值；但是，在相反方向上的转换不能保留值：Int64具有比Int8中表示的值更多的可能值。
	
	注意：检索原始值的能力与转换是否有保留值无关。
	
* **当第一个参数构成[介词短语](https://en.wikipedia.org/wiki/Adpositional_phrase#Prepositional_phrases)的一部分时，给它设置一个参数标签。**参数标签通常应该从介词开始,如`x.removeBoxes(havingLength: 12)`。

	当前两个参数表示单个抽象的一部分时会出现异常：
	
	```
	code: ❎
	a.move(toX: b, y: c)
a.fade(fromRed: b, green: c, blue: d)
	```
	
	这种情况，在介词后添加参数标签，以保持抽象概念清晰。
	
	```
	code: ✅
	a.moveTo(x: b, y: c)
a.fadeFrom(red: b, green: c, blue: d)
	```
	
	
* 否则，**如果第一个参数构成语法短语的一部分，则省略其标签.**将前置的单词附加到基本名称上，例如， `x.addSubview（y)`


	本指南认为如果第一个参数不构成语法短语的一部分，它应该有一个标签。
	
	```
	✅
	view.dismiss(animated: false)
let text = words.split(maxSplits: 12)
let studentsByName = students.sorted(isOrderedBefore: Student.namePrecedes)
	```
	
	请注意，短语传达正确的含义非常重要。以下可能表达会错误的观点。
	
	```
	❎
	view.dismiss(false)   Don't dismiss? Dismiss a Bool?
words.split(12)       Split the number 12?
	```
	
	另请注意，可以省略含默认值的参数。在这种情况下，不要形成语法短语的一部分，因此它们应始终具有标签。
	
* **为其它所有参数添加参数标签。**


## 特别说明

* **在API中为tuple元组成员添加参数标签，命名闭包参数。**

	这些名称具有很好的解释能力，可以从文档注释中引用，并提供对元组成员的访问。
	
	```
	/// 确保我们有requestedCapacity最后一个元素的唯一引用的存储单元。 
///
/// 如果需要更多存储空间，则调用`allocate` 。且分配的字节数`bygerCount`等于最大数。
///
/// - Returns:
///   - reallocated: `true` iff a new block of memory
///     was allocated.
///   - capacityChanged: `true` iff `capacity` was updated.
mutating func ensureUniqueStorage(
  minimumCapacity requestedCapacity: Int, 
  allocate: (_ byteCount: Int) -> UnsafePointer<Void>
) -> (reallocated: Bool, capacityChanged: Bool)
	```
	
	用于闭包参数的名称，应如顶级函数的[参数名称](https://swift.org/documentation/api-design-guidelines/#parameter-names)一样。在闭包参数调用处不应出现参数标签。
	
	
* 使用不受约束的多态性（例如`Any`，`AnyObject`和`无约束的通用参数`）时要格外小心，以避免重载集中出现歧义。

	如考虑重载集：
	
	```
	❎
	struct Array {
  ///  在 `self.endIndex`处插入`newElement`.
  public mutating func append(_ newElement: Element)

  /// 在`self.endIndex`顺序插入 `newElements`内容。
  public mutating func append(_ newElements: S)
    where S.Generator.Element == Element
}
	```
	
	
	这些方法形成一个语义簇，并且参数类型明显不同。但是，当Element为Any时，单个元素可以与元素序列具有相同的类型。
	
	
	```
	❎
	var values: [Any] = [1, "a"]
values.append([2, 3, 4]) // [1, "a", [2, 3, 4]] or [1, "a", 2, 3, 4]?
	```
	
	为消除歧义，可以更明确地命名第二个重载方法。
	
	```
	✅
	struct Array {
  /// 在 `self.endIndex`处插入`newElement`.
  public mutating func append(_ newElement: Element)

  /// 在`self.endIndex`顺序插入 `newElements`内容
  public mutating func append(contentsOf newElements: S)
    where S.Generator.Element == Element
}
	```
	
	
	注：如何命名以更好地匹配文档注释。实际上是在编写文档注释时，得到了API作者的注意。