## 利用DSYM符号化解析

###### 1. 符号集DSYM文件

###### 2. crash文件

###### 3. symbolicatecrash：命令行解析工具

xCode自带的崩溃分析工具，使用这个工具可以更精确的定位崩溃所在的位置，将0x开头的地址替换为响应的代码和具体行数。

位置：/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash


## 命令行解析

1. 新建Crash文件夹
2. 将`symbolicatecrash `、`.dSYM `、`. Crash `文件copy至Crash文件夹中
3. 执行命令：

	> `$ cd Crash`
	> 
	> `$ 》 ./*.crash ./*.app.dSYM > symbol.crash`