保护 iOS App

原文链接：[Protecting iOS Applications](https://www.polidea.com/blog/Protecting_iOS_Applications/)

> 重要提示：我们刚刚发布了一个全新的 iOS 应用程序模糊工具，支持最新的苹果产品和Swift语言。有关详细信息和 Github 链接，请单击此处获取[Obfuscation Tool ](https://www.polidea.com/blog/open-source-code-obfuscation-tool-for-protecting-ios-apps)。下面描述的存储库不再维护。


在移动世界中，应用程序的安全性尤为重要。我们需要使用不同的工具来隐藏我们的 IP，以防攻击者或其他公司试图复制我们的产品。在使用 web 技术时，实现这类操作相当简单。所有代码都位于您完全控制下的服务器上，除了您可以访问源代码和实现细节之外，没有其他人可以访问。对于移动设备来说，这尤其困难，因为在移动设备中，必须以操作系统（如 Android 或 iOS）可以理解的格式发送编译的应用程序。**隐藏 App 秘密的一个特别有用的技巧是混淆。混淆使程序（即源代码或机器代码）难以让人理解。**这不是不可逆转的，但大多数人会很快放弃。

有不同的方法用来混淆应用程序。举几个例子：

* 重命名类和方法
* 加密字符串和常量
* method inlining方法嵌入
* 代理方法
* 代码虚拟化
* 篡改检测机制
* 反调试机制
* 控制流混淆
* 垃圾 类和方法


我需要吗？

在iOS中，使用何种类型的混淆方案尤为重要。由于 Obj-C 的体系结构，对iOS 应用程序的任何剖析都相当简单。您可能听说过 [class-dump](http://stevenygard.com/projects/class-dump/)、[cycript](http://www.cycript.org/)或[clutch](https://github.com/KJCracks/Clutch)。这些工具使 dump 和分析您构建的任意 App 变得非常容易。这也使 App 很容易受到任意想要查看其代码的人的攻击。他甚至可以修改行为、修改 UI 并将其作为自己的内容发布。


其他人呢？

在 Android 世界中，我们有一款由 2014 年 MCE 的演讲者埃里克·拉富特（Eric Lafuture）制作的令人惊叹的程序。[Proguard](http://proguard.sourceforge.net/)实际上是行业标准，它有很好的文档记录，并且每个人都可使用它。Proguard 不仅使应用程序更安全，而且通过缩短类和方法的命名以及删除死代码来创建紧凑的代码。

这是 Android 的，iOS 的呢？更糟的是。有一些工具，但几乎所有这些工具都是商业工具：

* Morpher
* [Metaforic](http://metaforic.com/products/Metaforic-Obfuscator)
* [Arxan](http://www.arxan.com/products/mobile/ensureit-for-apple-ios/)
* [LLVM Obfuscator](https://github.com/obfuscator-llvm/obfuscator)

一年多以来，我们一直在致力于一个以安全为目标的项目。我们想到了一个简单得多但却很有用的东西。找不到适合我们的工具，所以我们只有自己开发它。


它的工作机制？

1. 我们解析 Mach-O 对象文件的 obj-c 部分。分析该文件中定义的所有类、属性、方法和 I-var。

2. 我们以同样的方式（解析 obj-c 代码结构），读取所有的系统级框架。

3. 对于来自可执行文件中（但不存在与系统框架中）的每个符号，我们对应生成一个由字母和数字组成的随机标识符。

4. 生成的符号列表被格式化为带有 C-Preprocessor 的头文件。该文件随后被包含在 .pch 文件中。下次编译应用程序时，头文件中的每个类或方法都将得到一个新名称。


功能

我们在 BASH 中构建了第一个版本。有趣的是，它只有 274 行代码。`iOS-Class-Guard`是第二个版本，作为 [class-dump](http://stevenygard.com/projects/class-dump/)的扩展完全重写。我们的目标是涵盖 iOS 应用程序开发的所有方面。We’ve tried to leave as little as possible not obfuscated。

**主功能点：**

* **Storyboards**和**XIBs**：如果您正在使用 Interface Builder为您的应用程序创建 UI，我们的工具将自动找到它们并使它们混淆。
* **CoreData**：这个有点难。我们工具的最大优势（随机生成混淆的符号名）成为了完全支持 `CoreData `的最大障碍。即使`model `在运行混淆时保持不变，符号也会得到不同的标识符。这可能会导致，例如清除整个持久存储或应用程序崩溃（取决于具体实现）。我们决定排除 `CoreData `模型中的符号。
* **CocoaPods **:我们还考虑了项目中的外部依赖性。如果你在项目中包含了三方库，它们会像你的代码一样混淆。如果使用 CocoaPods 呢？我们也考虑过。添加到工作区的所有依赖项都将被混淆，只要是包含它们的源代码。
* **Crash Dumps**：有时我们都会遇到它们。这绝不是一个好事情，但它们帮助我们解决应用程序的问题。因此，当您收到的崩溃 dump 中包含混淆的符号时，您可能想知道如何跟踪这个bug。我们还准备了一个工具来处理这个问题。我们的工具生成一个符号映射文件，稍后可以使用该文件来反转进程并替换崩溃 dump 文件中混淆的符号。
* **Symbol names deduction**：这个也有点棘手。Obj-C 提供了多种方法来编写同一部分代码，如可以定义 getter 和 setter，但在代码中却使用点语法。就好像它是一个属性，反之亦然。更糟糕的是，您可以定义自定义getter 和 setter。我们已经尽力使我们的工具尽可能强大。因此，我们将方法符号与属性进行匹配，还处理 Obj-C 的标准属性约定，即使用 is 前缀作为布尔属性。目前，我们不处理不符合约定的自定义 getter/setter。


无缝集成

创建`iOS-Class-Guard`时，我们的目标之一是创建一个工具，它将与您的正常开发工作流无缝集成。我们试图将所需的代码库更改保持在最低级别。有关详细信息，请查看[iOS-Class-Guard-HitHub page](https://github.com/Polidea/ios-class-guard)页面，请记住，正如前面所述，repository不在维护支持。















