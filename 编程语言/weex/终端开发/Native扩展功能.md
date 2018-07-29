
# 一、扩展Html5的功能

1. 参考：[扩展Html5的功能](https://weex.incubator.apache.org/cn/guide/extend-web-render.html)

# 二、扩展Android的功能

1. 参考：[扩展Android的功能](https://weex.incubator.apache.org/cn/guide/extend-android.html)

# 三、扩展iOS的功能(swift)

1. 参考：[使用 swift 扩展 iOS 的功能](https://weex.incubator.apache.org/cn/guide/extend-module-using-swift.html)

# 四、扩展iOS的功能（obj-c）

## JS 使用原生组件

1. Weex SDK 只提供渲染，提供了一些默认的组件和能力，如果你需要一些特性但 Weex 并未提供，可以通过扩展自定义的一些插件来实现，通过 WeexSDK 加载。这些插件包括 component, module 和 handler。

2. 不依赖 UI 交互的原生功能，Weex 将其封装成模块，这是一种通过 javascript 调用原生能力的方法。除了内置模块以外，将已有的原生模块移植到 Weex 平台也很方便。你可以使用 weex.requireModule 接口引用自定义的或者内置的模块
3. 使用原生模块


---
  
## 内置组件：

1. 使用内置module(功能模块)
2. 内置component（UI组件）
3. 内置handler:(每个 protocol(interface) 对应的 handler 在 app 生命周期期间只有一个实例。)
4. 概念：

	> 1. [Module](https://weex.incubator.apache.org/cn/wiki/module-introduction.html)
	> 2. [Handler](https://weex.incubator.apache.org/cn/wiki/handler-introduction.html)
	> 3. [Component](https://weex.incubator.apache.org/cn/wiki/component-introduction.html)

## 1. 扩展自定义module

###### 1. 自定义class

1. 如继承自NSObject。
2. 名称建议定义为`prefix+name+Module`

###### 2. 遵循`WXModuleProtocol `协议

1. ``@synthesize weexInstance``：可以对 持有它本身的 WXSDKInstance Object 做一个 弱引用,通过 weexInstance 可以拿到调用该 module 的页面的一些信息。
2. `` - (NSThread *)targetExecuteThread``协议方法：Module 方法默认会在UI线程中被调用，建议不要在这做太多耗时的任务。如果要在其他线程执行整个module 方法，需要实现该协议方法，这样，分发到这个module的任务会在指定的线程中运行。
3. ``WXModuleKeepAliveCallback``回调：Module 支持返回值给 JavaScript中的回调，回调的参数可以是String或者Map, 该 block 第一个参数为回调给 JavaScript 的数据，第二参数是一个 BOOL 值，表示该回调执行完成之后是否要被清除，JavaScript 每次调用都会产生一个回调，但是对于单独一次调用，是否要在完成该调用之后清除掉回调函数 id 就由这个选项控制，如非特殊场景，建议传 NO。



###### 3. 暴露需透传提供给JS调用的方法

1. m文件中使用`WX_EXPORT_METHOD`:宏定义暴露(异步方法,获得结果需要通过回调函数获得)。
2. ``WX_EXPORT_METHOD_SYNC()``:宏定义暴露(同步方法)。

###### 4. 注册class

1. 注册语句：
	``[WXSDKEngine registerModule:moduleName withClass:clz];``

###### 5. JS端使用封装的自定义Module：

1. 类似内置Module：

	``weex.requireModule("event").showParams("hello Weex)``
	
## 2. 扩展自定义component


###### 1. 创建基类为`WXComponent `的类，即为自定义的组件。
###### 2. 重写并覆盖`WXComponent `的生命周期方法：

1. `- (UIView *)loadView`：一个 component 默认对应于一个 view。
2. viewDidLoad：对组件 view 需要做一些配置。
3. initWithRef:组件初始化方法。添加到当前组件上的所有属性都会在初始化方法中 attributes 中传过来。
###### 3. 其它功能

1. 支持自定义事件：（见[支持自定义事件](https://weex.incubator.apache.org/cn/guide/extend-ios.html)）
2. 支持自定义属性等

3. 暴露需透传提供给JS调用的方法：如Module中一致。

###### 3. 注册组件：

1. ``[WXSDKEngine registerComponent:cptName withClass:clz];``

###### 4. weex前端使用：

1. 使用：

	```
	<template>
    <div>
        <mapcpt style="width:200px;height:200px"></map>
    </div>
</template>

	```
	
	
## 3. 自定义Handler：

###### 1. 示例如图片下载功能实现。

1. handler 更多的是针对 native 开发同学来开发和使用，在其他的 component 和 module 中被调用.

###### 2. 定义自己的 `protocol` 和`对应的实现`来使用 handler 机制：

1. 新建基类为NSObject的class，并实现某协议。
2. 实现协议规定的方法。
3. 注册Handler：

	``[WXSDKEngine registerHandler:[clz new] withProtocol:proto];``
	
###### 3. 适应Handler：

1. 可以在 native 的 module 或者 component 实现中使用：

```
id<WXImgLoaderProtocol> imageLoader = [WXSDKEngine handlerForProtocol:@protocol(WXImgLoaderProtocol)];
[iamgeLoader downloadImageWithURL:imageURl imageFrame:frame userInfo:customParam completed:^(UIImage *image, NSError *error, BOOL finished){
}];
```

######