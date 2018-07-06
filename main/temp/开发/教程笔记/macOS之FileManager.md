* 链接：https://www.raywenderlich.com/157986/filemanager-class-tutorial-macos-getting-started-file-system

#### 管理目录路径

1. 特定file、folder定位倚靠URL
2. let completePath = "/Users/zhoupanpan/Desktop/Files.playground"

	> 基于启动磁盘的绝对路径。
	
#### URLs路径

* URL：指向远端资源(https://)，亦可指向本地资源（file://）
* 针对URL的多种操作
* 关于路径的操作，在Swift中，URL取代了String的做法。但fileExists检测还是需要使用String的属性。

#### 

#### 等等

## FileManager

* 灵活操作文件、文件夹等

	> * let myOwnHome = FileManager.default.homeDirectoryForCurrentUser
	
* NSOpenPanel:file、folder对话框
	> * 获取文件夹下所有file、folder数据
	```
		let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
		```
		```
		let urls = contents.map { return folder.appendingPathComponent($0) }
	```
	
* NSWorkspace：file、folder信息

	> 详细信息：fileManager.attributesOfItem(atPath: url.path)
	
* 过滤隐藏的文件、文件夹（以`.`开头）

	```
	let urls = contents
            .filter { return showInvisibles ? true : $0.characters.first != "." }
            .map { return folder.appendingPathComponent($0) }
	```
* 进入子folder，需做判断

	```
	if selectedItem.hasDirectoryPath {
        selectedFolder = selectedItem
    }
    //返回上一级
    if selectedFolder?.path == "/" { return }
    selectedFolder = selectedFolder?.deletingLastPathComponent()
    ```
    
 ## 信息保存
 
 1. 用户启动的保存：NSSavePanel

 	```
 	do {
                let infoAsText = self.infoAbout(url: selectedItem)
                try infoAsText.write(to: url, atomically: true, encoding: .utf8)
            } catch {
            }
 	```
 	
 2. 自动保存

 	> * applicationSupportDirectory
 	> * 在didAppear和Disappear中执行restore和save数据。