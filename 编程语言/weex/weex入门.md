## 资源：

1. 官方站点：[https://weex.incubator.apache.org/cn/](https://weex.incubator.apache.org/cn/)
2. 在线编写代码平台：[http://dotwe.org/vue/](http://dotwe.org/vue/)


## 开发

###### 1. 集成WeexSDK至终端（此处以iOS为例）
> 具体步骤参见：[集成Weex到已有应用](https://weex.incubator.apache.org/cn/guide/integrate-to-your-app.html)

1. 创建原生工程（Xcode创建）或者开启已有原生项目。
2. 添加WeexSDK：使用pods方法添加`pod 'WeexSDK', '0.18.0'`

	> * 如使用carthage，请移步上述网站，有详细集成步骤。
	> * WeexSDK pods地址：[https://cocoapods.org/pods/WeexSDK](https://cocoapods.org/pods/WeexSDK)

3. 项目中初始化weex环境：代码略


###### 2. 搭建开发环境

1. brew、nodejs(及npm)安装，以及脚手架工具[weex-toolkit](https://weex.incubator.apache.org/cn/tools/toolkit.html)安装。

	> * `npm install -g weex-toolkit`：全局安装执行一次即可。命令行工具创建vuejs支持的脚手架空项目。
	> * weex -v //查看当前weex版本
	
2. 初始化空项目(Weex Vue模板)：

	> * weex create `awesome-project`
	> * 添加iOS平台支持：`weex platform add ios`
	> * 添加Android平台支持：`weex platform add android`
	
	> 创建支持Rax的项目移步[Rax官网](https://alibaba.github.io/rax/)

3. [文件目录详解]()&开发

	

4. 调试：

	> 1. 安装项目依赖：npm install
	> 2. `npm start`:即可在chrome上实时查看效果。（终端调试：扫描二维码，查看手机呈现效果）
	> 3. 单页面调试：`weex preview src/index.vue`
	

## 编译&打包

###### 1. vue编译方案：
1. Web平台：使用 Webpack](https://webpack.js.org/) + [vue-loader](https://vue-loader.vuejs.org/en/)
2. iOS和Android平台：[ weex-loader](https://github.com/weexteam/weex-loader)

###### 2. 打包

```
# 仅打包
$ npm run build
# 打包+构建
$ weex build ios
# 打包+构建+安装执行
$ weex run ios
```

1. 通过build命令打包的js文件可以直接用于生产。
2. 若需优化，即执行：`npm run build -p`
3. 打包之后，在项目dis目录中，存在`**.js`和`**.web.js`。及对应的components文件夹。

	> * `**.js`:iOS和Android通用版。
	> * `**.web.js`:h5版，应用于web。


附录：

1. 直接运行（推荐直接在对应IDE中运行）：

```
weex run ios
weex run android
weex run web
```


#### 文件目录详解

###### 1. package.json：启动文件
###### 2. src文件夹：

1. index.vue:


组件支持：内置组件；模块；各平台内置原生组件；定制的原生组件
WeexSDK内置了Vue和RAX，不必再显式引入。
