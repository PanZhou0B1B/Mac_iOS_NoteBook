1. 路由策略：使用三方库``pod 'CTMediator', '12'``
2. 整体架构：子工程化开发
3. 功能UI：采取MVP之MVIP方案

---


# 子工程：

##  IMXBaseModules

1. 基础子工程:放置公共的组件：或基于三方库，或原生功能组件
	> 1. 若放置三方库，需在文件中表明地址和版本信息
	
2. content：

	> 1. JS-OC库：`pod 'WebViewJavascriptBridge', '6.0.2'`
	> 2. 路由策略：`pod 'CTMediator', '12'`
	> 3. AOP方案：`pod 'Aspects', '1.4.1'`
	> 4. MVIP:二方库，基于MVP的开发模式
	
	


## IMXDebugModules

1. 一些Debug相关的设置
2. 总工程需要引入pod三方库如下：

	```
	pod 'FLEX', '2.4.0', :configurations => ['Debug']
	pod 'pop', '1.0.10', :configurations => ['Debug']
	```
	
	
TODO：svn、Git环境、项目中警告wainning消灭、完善Debug宏定义问题