
## 资源

1. 参考链接：[https://simulatedgreg.gitbooks.io/electron-vue/content/cn/](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/)

## 配置总结：

1. (一次性全局)安装`vue-cli`：

	``npm install -g vue-cli``
	
2. (一次性全局安装)包管理工具推荐`yarn`，(类似npm)

	``brew install yarn``
	
3. 脚手架搭建新项目：

	``vue init simulatedgreg/electron-vue my-project``
	
4. 运行之

	```
	cd my-project
	yarn # 或者 npm install
	yarn run dev # 或者 npm run dev
	yarn clean #帮助减少最后构建文件的大小
	```
	
	
## 项目结构分析

###### 1. package.json设置：

1. dependencies：依赖库。将会被包含在最终产品的应用程序中。应用程序需要某个模块才能运行，那么在此安装！
2. devDependencies：不会被包含在最终产品的应用程序中。安装专门用于开发的模块，如构建脚本、webpack 加载器等等。

###### 2. 文件目录：

1. 开发目录：即项目目录
2. 产品构建目录：dist文件目录、node_modules、package.json

###### 3. 组件目录：src/renderer/components

1. 创建子组件时，一个常用的组织化实践是将它们放置在一个使用其父组件名称的新文件夹中。在协调不同的路由时，这一点特别有用。

```
src/renderer/components
├─ ParentComponentA
│  ├─ ChildComponentA.vue
│  └─ ChildComponentB.vue
└─ ParentComponentA.vue
```

###### 4. 路由文件：src/renderer/router/index.js

1. 路由使用 src/renderer/App.vue 的 <router-view> 指令附加到组件树上。

###### 5. 数据模块目录：src/renderer/store/modules

1. electron-vue 利用 vuex 的模块结构创建多个数据存储，并保存其中。

###### 6. 主进程：

1. src/main/index.js：程序的主文件，启动文件。也即webpack产品构建的入口文件。

	> 所有的 main 进程工作都应该从这里开始
	
2. app/src/main/index.dev.js:专门用于开发阶段，因为它会安装 electron-debug 和 vue-devtools。一般不需要修改此文件，但它可以用于扩展你开发的需求。

3. __dirname 与 __filename

	```
	app.asar
├─ dist
│  └─ electron
│     ├─ static/
│     ├─ index.html
│     ├─ main.js
│     └─ renderer.js
├─ node_modules/
└─ package.json
	```
	
	
###### 7. webpack配置：三个单独的、位于 .electron-vue/ 目录中的 webpack 配置文件

1. .electron-vue/webpack.main.config.js：针对 electron 的 main 进程。这种配置是相当简单的，但确实包括一些常见的 webpack 做法。
2. .electron-vue/webpack.renderer.config.js：针对 electron 的 renderer 进程。此配置用来处理你的 Vue 应用程序，因此它包含 vue-loader 和许多其他可在官方 vuejs-templates/webpack 样板中找到的配置。
3. .electron-vue/webpack.web.config.js：针对为浏览器构建你的 renderer 进程的源代码。