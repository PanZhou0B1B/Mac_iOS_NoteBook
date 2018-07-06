## TNContext
### 具有全局window、Navi、serviceMgr等的引用，页面路由功能具体实现。便于处理全局性的操作
#### 1. 属性：
1. window：全局window引用
2. UINavigationController：
3. TNServiceManager：管理并操作全局service，如LBS
4. TNBusinessContext：
5. UIStatusBarStyle

#### 2. 方法
1. findServiceByName：通过serviceManager获取服务
2. registerService：forName：通过serviceManager注册服务
3. unregisterServiceForName：通过serviceManager析构服务
4. openPage:params:animate:页面

	> 1. 获取本地plist文件对应的路由页面白名单(PageID<->Ctrl Name)
	> 2. params:runtime获取属性集，并赋值
	> 3. 全局Navi push 具体的page
	
## TNBusinessContext
1. 未涉及


## Service

#### 1.TNService协议
1. start：开启服务
2. 可选协议

### 2. TNServiceInfo
1. model：含有name、cls、isLazyLoading等标识字段

### 3. TNServiceManager
#### 服务管理器：

1. 注册服务、析构服务
2. 查找注册的服务--findServiceByName：
3. 启动服务
4. 注册plist中默认的服务

### 4. TNRunServiceOnce
1. 本地启动一次的服务（未使用）


## OnceService

### 目前只包含app更新检测服务

### 1. Mtop
1. TNAppConfigModel：app更新检测Model
2. TNAppVersionCheckService

	> 1. 属于service
	> 2. 服务器请求最新版本信息(start方法中执行，实现app启动时执行一次检测)
	

## Scheme

### 路由：
主要针对[UIApplicationDelegate
application:openURL:sourceApplication:annotation] 的调用机制

### 1. TNSchemeService
1. 协议，处理URL调用的服务协议
2. registerHandlerClass：在处理类链表中注册一个处理类（SchemeHandler的子类）
3. 析构处理类以及获取
4. handleURL：userInfo：URL处理类处理URL调用
5. handleOpenURL：URL处理类处理URL调用

### 2. TNSchemeServiceImpl
1. 代理TNSchemeService实现
2. 数组充当处理链表实现
3. 注册默认的TNDefaultSchemeHandler URL处理类

### 3. TNSchemeHandler
1. URL处理类基类
2. canHandleOpenURL：判断
3. handleOpenURL：处理

### 4. TNDefaultSchemeHandler
1. TNSchemeHandler子类
2. 具体APP，该类处理方式会有不同

	> 1. 解析URL：scheme以及其它参数分解,可以确定URL路由细节
	> 2. 具体跳转调用（此处是TNLauncherManager类来处理）