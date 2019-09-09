
	
##Swift Import 声明

* 原文链接：[Swift Import Declarations](https://nshipster.com/import/)
* 组织单元：**types&methods&property--->Class--->Module--->Libs&Frameworks**。依靠import声明聚合。

* 该文介绍的方式并不能使编译变得更快。 

**问题**：多个Module中含有同名的方法:调用处引用多个module，执行同名方法，会引发歧义，错误。

###### 1. 方案一：使用完整引用，即方法前添加module名字，消除歧义。
###### 2. 方案二：改变import方式。（多种方案）
	
1. import单独声明：可以单独指定struct、class、enum、pros、aliases，以及在顶级也可引入funcs、constants、vars。

	```
//kind:可选值为`struct`、`class`、`enum`、`protocol`、`typealias`、`func`、`let`、`var`
//
import <#kind#> <#module.symbol#>
```
	
2. 解决Symbol同名：本地化声明优先。单独声明的与某一Module中同名，则执行前者。调用处有同名，则执行调用处方法。（编译器查找顺序：``本地-->单独声明-->引入的module``）

3. 阐明与最小化范围：

	```
	//举例1：只用巨型framework中的一func。
	import func AppKit.NSUserName
	
	NSUserName() // "jappleseed"
	```
	```
	//举例2：只用framework中顶级变量。
	mport func Darwin.fputs
	import var Darwin.stderr

	struct StderrOutputStream: TextOutputStream 	{
    	mutating func write(_ string: String) {
      		fputs(string, stderr)
    	}
	}
	```
	
4. 引入子module方式:并不是最优方案，但apple目前大量存在此场景

	``
	import <#module.submodule#>
	``