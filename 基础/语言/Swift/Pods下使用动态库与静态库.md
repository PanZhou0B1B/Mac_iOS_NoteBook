
原文链接：[How-to: Decreasing iOS App size by moving from dynamic frameworks to static libraries with Cocoapods](https://recoursive.com/2018/06/06/static_libraries_cocoapods/)


随着Cocoapods 1.5的发布，你现在可以将Pods资源编译为静态库了，即使它们（全部或部分）用Swift写就。这意味着它们（静态库）可以在编译时将代码与app二进制文件结合使用，而非将它们构建为在app启动时加载的动态框架了。如果依赖很多pods资源的话，这可以**改善应用启动时间**和**应用的下载大小**。

该转换相对简单直接：

1. 移除`use_frameworks!`:podfile中，移除该语句。若pods资源均由Swift写就，更应如此。
2. 否则，您可能需要添加`use_modular_headers！`至Podfile或单个目标的顶部。或者，您可以向每个在构建期间抛出错误的pod资源添加：`modular_headers => true`。


以上便是Podfile所关注的所有事务。下面是转换时，出现的问题，现列出问题及解决方案：

###### 1. COULD NOT BUILD OBJECTIVE-C MODULE X” AND/OR “‘X.H’ FILE NOT FOUND

当创建一个Swift lib/framework时，它会创建一个`.h`文件，以引用该库，即`#import <[Project or Module]/X.h>`。但在静态库编译时，则需要`#import "X.h"`。

###### 2. MODULE ‘FABRIC’ HAS NO MEMBER NAMED ‘WITH’

使用Fabric特有的问题

###### 3. SMALLER BINARIES

使用静态库减少app的大小。

* 针对特定设备的exe文件瘦身，每个库将近减少100KB大小
* 针对通用设备的exe文件瘦身，每个库将近减少300KB大小

