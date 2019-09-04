本笔记为书籍：`Advanced.Apple.Debugging.&.Reverse.Engineering.v2.0.pdf`学习笔记，内容上做了精简。

## 准备

开始本书教程之前，需要准备：

1. Mac：运行High Sierra(10.13)或以上版本。
2. Xcode 9.1及后续版本：随Xcode打包的LLDB即为最新版本。书写本书时，LLDB版本为：`lldb-900.0.57`。
3. python 2.7：LLDB需利用其运行python脚本。终端查询python版本命令：`python --version`。
4. iOS设备：64位且运行iOS10.0及以上。本书大部分iOS程序是在真机调试的，但也可以在模拟器中运行。

## 目的

常规来讲，每个开发者都需掌握代码调试技艺。本书目的主要涵盖：

* 更好的使用 LLDB 调试代码
* 使用 LLDB 构建复杂的调试命令
* 深耕调研 Swift 和 Object-C
* 使用逆向工程优化自己的项目
* 掌握最新、前沿的逆向工程策略
* 找寻计算机、软件相关的精深问题的答案的能力。


## 资源：

* 本书伴有源码、python脚本、每章初始和完整的项目。
* 订阅更新：[www.raywenderlich.com/newsletter](www.raywenderlich.com/newsletter)
* LLDB 脚本repo：[https://github.com/DerekSelander/LLDB](https://github.com/DerekSelander/LLDB)

