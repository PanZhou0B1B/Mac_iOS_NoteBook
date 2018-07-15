## Vue插件

* 自带插件，均可通过vue-cli脚手架安装。
* [参考链接](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/vue_accessories.html)

###### 1. [axios网络请求](https://github.com/mzabriskie/axios)

1. 基于 Promise，用于浏览器和 node.js 的 HTTP 客户端。
2. 可以在 main 进程脚本中轻松导入 axios，或者在 renderer 进程中使用 this.$http 或 Vue.http。


###### 2. [vue-electron](https://github.com/SimulatedGREG/vue-electron):用于将 electron API 附加到 Vue 对象。

1. 将 electron API 附加到 Vue 对象的 vue 插件，使所有组件可以访问它们。
2. 可以轻松通过 this.$electron 访问 electron API 的简单的 vue 插件，不再需要将 electron 导入到每一个组件中。


###### 3. [vue-router](https://github.com/vuejs/vue-router):单页应用路由

1. vue-router 是 Vue.js 的官方路由。它与 Vue.js 的核心深度整合，使 Vue.js 单页应用程序的构建变得轻而易举。


###### 4. [vuex](https://github.com/vuejs/vuex):flux 启发的应用程序架构

1. Vuex 是 Vue.js 应用程序的 状态管理模式 + 库。它作为程序中所有组件的集中存储，其规则确保了状态量只能以可预测的方式被改变。


## npm 脚本

###### 1. npm脚本命令需运行在项目根目录下。等同于`yarn run  <cmd>`。

1. npm run build：打包并构建
2. npm run dev：开发环境下运行
3. npm run lint：静态分析所有在`src/`和`test/`下的JS和Vue组件文件。
4. npm run lint:fix:3功能+并且尝试修复问题。
5. [其它](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/npm_scripts.html)

## CSS框架

## 预处理

## 静态资源使用

###### 1. electron-vue 提供了一个 __static 变量，它可以在开发和产品阶段生成 static/ 目录的路径。

1. static/ 目录：放置可供 main 和 renderer 进程使用的静态资源。

###### 2. Vue 组件里 src 标签

###### 3. JS 搭配 fs、path 和 __static 的使用案例

1. 静态资源，需要使用 fs 将它读入到应用程序中。
2. electron-vue 提供了一个名为 __static 的全局变量，它将产生一个指向 static/ 目录的正确路径。可在开发和产品阶段使用它读取一信息。


## 本地文件读写

###### 1. electron 的一大好处是可以访问用户的文件系统。即可以读取和写入本地系统上的文件。

1. app.getPath(name) 函数:帮助函数可以获得指向系统目录的文件路径，如用户的桌面、系统临时文件 等等。
2. 
