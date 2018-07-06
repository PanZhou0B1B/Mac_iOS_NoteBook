* Mac含有一个成熟版本的Unix作为其OS。
	> 意味着预安装了许多命令行工具和脚本语言，如Swift、Python、Bash、Ruby、Perl。
	
# NSTask(Process)

* 提供前端GUI执行命令行程序。


## 命令
1. 创建shell脚本文件：macOS->Other->Shell Script

2. 命名为**.command，并选中target
3. 内容

	```
	echo "*********************************"
	echo "Build Started"
	echo "*********************************"

	echo "*********************************"
	echo "Beginning Build Process"
	echo "*********************************"

	xcodebuild -project "${1}" -target "${2}" -sdk iphoneos -verbose CONFIGURATION_BUILD_DIR="${3}"

	echo "*********************************"
	echo "Creating IPA"
	echo "*********************************"

	/usr/bin/xcrun -verbose -sdk iphoneos PackageApplication -v "${3}/${4}.app" -o "${5}/app.ipa"
	```
4. chmod：改变脚本权限，以使NSTask可以执行之。

	> chmod +x BuildScript.command
	>
	> 注意clean项目
	>
	> 此方式在开发自己的app或不在mac appstore发布时有用。在Mac Store发布需要更复杂的解决方案。


5. NSTask执行：

	```
	self.buildTask = Process()
    self.buildTask.launchPath = path
    self.buildTask.arguments = arguments
    self.buildTask.terminationHandler = {
      task in
      DispatchQueue.main.async(execute: {
        ...
      })
    }
    self.buildTask.launch()
    self.buildTask.waitUntilExit()
	```
	
## Pipe输出

* stdin：
* stdout：
* stderr：