1. [网易严选App感受Weex开发](https://juejin.im/post/59c4d696f265da065d2b7843)
2. https://alibaba.github.io/weex-ui/#/docs/weex-ui-report
3. 
适合交互要求不高

语言基础（初级中级即可）：Nodejs、js（ES6，Vue）、html、css、android、iOS初级。

IDE：VSCode、Xcode、Android studio

其它：node、npm、weex-toolkit



在 Weex 中能够调用移动设备原生 API，使用方法是通过注册、调用模块来实现。其中有一些模块是 Weex 内置的，如 clipboard 、 navigator 、storage 等。可以扩展原生模块

weex工程中常用的标签有``<div/>，<text/>，<image/>，<video/>``（组件另算），由此四种标签基本可以满足绝大多数场景的需求，虽说此标签同web工程下的标签用法一致，但此处的标签已不再是我们前端口中常提的html标签，而且名存实亡的weex标签，确切讲是weex组件

通过weex-loader、vue-loader、weex-vue-render的解析最终转换输出的便是实际的组件，有此设计只是为了完成**web开发体验**的目标。但是我们身为上层的开发人员要清楚自己每天“把玩”的到底是个什么“鬼

使用了增强版的webpak打包工具weexpack