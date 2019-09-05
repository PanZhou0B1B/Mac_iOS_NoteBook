# 64bit 适配

参考链接：[http://blog.sunnyxx.com/2014/12/20/64-bit-tips/](http://blog.sunnyxx.com/2014/12/20/64-bit-tips/)

## 注意点列举：

官方文档中的注意点：

* 不要将指针强转成整数
* 程序各处使用统一的数据类型
* 对不同类型的整数做运算时一定要注意
* 需要定长变量时，使用如`int32_t`, `int64_t`这种定长类型
* 使用malloc时，不要写死size
* 使用能同时适配两个架构的格式化字符串
* 注意函数和函数指针（类型转换和可变参数）
* 不要直接访问Objective-C的指针（isa）
* 使用内建的同步原语（Primitives）
*n不要硬编码虚存页大小
* Go Position Independent


## 拒绝基本数据类型和隐式转换

### 基本类型

> int、long、float、double 在32bit 下的长度：4、4、4、8

> int、long、float、double 在64bit 下的长度：4、8、4、8

**此时使用诸如`sizeof(int)`之类的代码要注意**

#### 方案：

使用以下方式代替基本类型：

* int ------------> NSInteger
* unsigned ---> NSUInteger
* float ----------> CGFloat
* 动画时间 ---> NSTimeInterval

实例：

```
for(int i = -1;i<array.count;i++)
```

**此时 i 被`隐式转换`成 NSUInetger 了，变成一个很大的数字**

建议使用:

```
for(NSUIneteger index = 0; index <array.count; index ++)
```

## 枚举写法

```
typedef NS_ENUM(NSUInteger, Sex){
	SexMan,
	SexWoman
}

```
**写法优势：不仅指定了枚举值的类型，还可做赋值检查。**


## 替代 Format 字符串

**`@(var)`可将诸如 number类型转为 string 类型。**

将类似适配语法

```
NSLog(@"数组元素个数：%lu", (unsigned long)items.count);

```
更改为：

```
NSLog(@"数组元素个数：%@", @(items.count));

```


## 64-bit 下的 BOOL

32-bit下，BOOL被定义为signed char，@encode(BOOL)的结果是'c'

64-bit下，BOOL被定义为bool，@encode(BOOL)结果是'B'

32-bit版本的BOOL包括了256个值的可能性，还会引起一些坑，像[这篇文章](https://www.bignerdranch.com/blog/bools-sharp-corners/)所说的。而64-bit下只有0（NO），1（YES）两种可能，终于给BOOL正了名。

## 不直接取 isa 指针

编译器已经默认禁用了这种使用，isa指针在32位下是Class的地址，但在64位下利用bits mask才能取出来真正的地址，若真需要，使用runtime的object_getClass 和object_setClass方法。

## 解决第三方lib依赖和lipo命令

* 以源码形式出现在工程中的第三方lib，只要把target加上arm64编译就好了。
* 恶心的就是直接拖进工程的那些静态库(.a)或者framework，就需要重新找支持64-bit的包了。这时候就能看出哪些是已无人维护的lib了，是时候找个替代品了。

### 打印Mach-O文件支持的架构

* 如何看一个可执行文件是否支持64-bit？

	答案：使用`lipo -info`命令 (更详细命令：`lipo -detailed_info`)，或者`file`命令。展示：

	```
// 当前在Xcode Frameworks目录
sunnyxx$ lipo -info UIKit.framework/UIKit
Architectures in the fat file: UIKit.framework/UIKit are: arm64 armv7s

	```
	**tip：上述命令对 Mach-o 文件、静态库.a 文件、framework 的.a文件适用。**
	
* 合并多个架构的包

	答案：使用`lipo -create`命令:
	
		```	
		$lipo -create lib-32.a lib-64.a -output lib.a
		//多用于静态包生成
		```

* 支持64-bit后程序包会变大么？

	答案：会，支持64-bit后，多了一个arm64架构，理论上每个架构一套指令。
	
* 一个lib包含了很多的架构，会打到最后的包里么？

	答案：不会。
	
	> 如果lib中有armv7, armv7s, arm64, i386架构，而target architecture选择了armv7s, arm64，那么只会从lib中link指定的这两个架构的二进制代码，其他架构下的代码不会link到最终可执行文件中；
	
	> 反过来，一个lib需要在模拟器环境中正常link，也得包含i386架构的指令。


