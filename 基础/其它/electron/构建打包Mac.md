

## APP打包

1. 自动打包工具推荐：[electron-packager](https://github.com/electron-userland/electron-packager)、[electron-builder](https://github.com/electron-userland/electron-builder)

	> * 推荐使用electron-builder。
	> * 另外一种方式：手动打包。
	
2. 自动打包优势：

	> * 自动打包多个平台安装包（windows/macos/linux）
	> * 集成自动更新功能。
	
## 自动打包步骤（以electron-builder为例）

1. 安装工具：`npm i (--save-dev) electron-builder`

	> * 确保package.json中含有：`name`、`description`、`version`、`author`字段。
	> * [npm地址详解](https://www.npmjs.com/package/electron-builder)
	
2. package.json中添加build属性：

	```
	"build": {
  		"appId": "your.id",
 		 "mac": {
    			"category": "your.app.category.type"
  				},
  		"win": {
    			"iconUrl": "(windows-only) https link to icon"
 				 }
		}
	```
	
3. 在项目根目录下建立`build`目录文件夹，存放3张图片：

	> 1. background.png (macOS DMG background)
	> 2. icon.icns (macOS app icon)
	> 3. icon.ico (Windows app icon)
	
4. 在`package.json`中追加scripts中命令：

	```
	"scripts": {
 	"pack": "build --dir",
  	"dist": "build"
	}
	```
	
5. 运行：`npm run dist`，在项目目录中的dist目录下生成可执行程序、安装包等。

	> * 默认输出目录在dist中，修改输出目录方式即在build属性中添加如下配置：
	
	> * ```
	"directories": {
    "output": "package"
	}
	```