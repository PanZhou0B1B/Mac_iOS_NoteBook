## 目标

本文是文章`CocoaPods管理子工程`的续篇，主要目的是将Pods私有库打造成framework静态库来使用。


## 实现方案

#### 1. 步骤回顾：

###### 1. 创建私有pods repos版本库。
###### 2. 存放framework源码的项目。

1. 源码项目。（不强制要求是模板项目）
2. podpec文件定义：

	> * 版本定义：注意一定要与tag保持一致。
	> * source code位置
	> * public header file 公开文件。见附录1。
	> * 调用的依赖的 framework 等。
3. 关联之。

	> * pod repo push IMXRepo IMXFuncCpt.podspec
	
	
#### 2. 资源转换为framework：

1. 安装[CocoaPods Packager](https://github.com/CocoaPods/cocoapods-packager)，并按照提示安装。
2. 使用:在资源文件目录下执行：pod package **.podspec
3. 可以看到在当前目录下生成了framework文件夹：

	> * 更改主podspec文件：将生成的podsepc部分信息替换，见附录2
	> * commit 文件夹,注意tag更新。
	> * pod update即可完成使用framework的更新。


## 附录

1. 附录1：

```  
s.source_files  = 'IMXFuncCpt/Libs/2nd/Launcher/*.{h,m}'
  # s.exclude_files = "Classes/Exclude"

  s.public_header_files = [
    'IMXFuncCpt/Libs/2nd/Launcher/*.{h}'
  ]

```

2. 附录2：

	```
	//注释或删除掉附录1中的内容
	 s.preserve_paths = 'IMXFuncCpt-1.0.0/ios/IMXFuncCpt.framework'
   s.ios.deployment_target    = '8.0'
   s.ios.vendored_framework   = 'IMXFuncCpt-1.0.0/ios/IMXFuncCpt.framework'
   
	```
	
## 参考链接：

1. [CocoaPods Framework创建](http://eric.swiftzer.net/2016/09/cocoapods-framework-pod/)
2. [Pods官网](https://cocoapods.org/)