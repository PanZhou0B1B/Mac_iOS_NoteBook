## Electron + VS Code

##### 1. 安装VS Code。
##### 2. 打开VS Code，并文件->打开基础项目。

1. 初始基础项目文件：main.js，index.html，package.json。

	> * package.json:由VS code配置生成或者`npm init`命令生成。
	
2. 子文件夹app：存放代码文件
3. 资源文件、三方包等其它文件夹

##### 3. 配置electron依赖环境（项目级别首次安装即可）
1. 命令行（项目级别，非全局）：npm install –save-dev electron

	> * 安装完成后在项目中会多一个`node_modules`文件夹。
	> * 可在用户设置（全局）或工作区设置（本项目）中，添加命令隐藏之：
	`"files.exclude": {
    "node_modules/": true
	}`
		
##### 4. 运行：

1. 发布运行，直接在命令行执行'npm start'即可。

	> * VSCode命令行：electron .
2. 测试执行：执行调试步骤即可。（需在项目目录下安装electron）

	> * 配置VSCode的Node启动：点击测试标签->选择配置Node.js。（则VSCode文件管理器中会自动添加.vscode文件夹，并launch.json文件。
）