示例：以pod管理的含有多个三方库的项目


###### 1. 构建各三方库

1. 内存中创建Headers和framework目录
2. 辅助文件写入：WriteAuxiliaryFile
3. 编译代码文件：CompileC
4. 头文件拷贝至Header中：CpHeader
5. 各资源文件处理:如Bundle
6. 内存中Touch生成，并copy至目标Pods/处
7. Link:LD命令构建可执行文件。


###### 2. 构建UNNotificationServiceExtension扩展

基本和1相同，但多了Entitlement包处理和codesign
以及生成后，copy主工程的位置不同。

###### 3. 构建主工程

1. 创建各文件夹：如Frameworks、Plugins、pro.app(主工程)
2. 辅助文件写入内存：如Entitlements.plist，并进行包装处理
3. 包处理：embedded.mobileprovision 将配置文件写入
4. 一系列辅助文件写入: WriteAuxiliaryFile
5. 脚本文件解析并执行
6. Swift编译
7. 预编译pch文件
8. 编译各oc文件：代码中的警告等问题会详细列出
9. 编译各xib文件CompileXIB：
10. 编译Assert资源文件CompileAssetCatalog：
9. 资源文件拷贝CopyPNGFile：压缩处理等细节
10. 资源文件拷贝CopyPlistFile：
11. 资源文件拷贝CopyStringsFile
12. 资源文件拷贝：CpResource（bundle、html、ttf等）
13. 配置plist文件处理：ProcessInfoPlistFile
14. 拷贝UNNotificationServiceExtension（PBXCp），并验证插件可行性（ValidateEmbeddedBinary）
15. 拷贝主工程中的framework（PBXCp）并签名codesign
16. 执行pods提供的Embed脚本：
	1. 主工程下创建frameworks目录
	1. 删除旧frameworks
	2. 依次添加pods中的framework，并签名
16. DSYM文件生成GenerateDSYMFile
17. 拷贝Swift文件：CopySwiftLibs
18. 签名主工程XX.app：codesign
19. 生成主工程XX.app：Touch
20. 验证：Validate
21. 编译成功