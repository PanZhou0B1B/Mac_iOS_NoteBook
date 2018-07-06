## **（APP项目名）：
### 功能：APP入口
1. TNAppDelegate:自main方法入口Delegate：初始化配置

	> 1. TNAppConfiguration:server time 同步
	> 2.  APN配置：注册、接受信息、token生成等
	> 3. TNBootLoader:加载器。TNRunServiceOnce：从配置文件加载全局服务；TNContext：服务注册，page路由等功能；windows初始化，并传入TNontext，设定TNLauncherRootController为rootView；FLEX debug工具设定
	> 4. Navi统一设定样式等
	> 5. Handler Open Url设定：分享、路由策略（IDFSchemeService）
	
2. splash图片，其它子模块资源bundle（icon、plist、其它）
3. pch文件：通用型库文件导入

## MobileFoundation
#### 主要涵盖网络库和运行时的部分文件。

1. MobileFoundation.h:头文件集合
2. NetWork网络封装包：基于AFNetworking的封装
3. 扩展集合：NSString、NSArray、NSDic等
4. DeviceInfo：设备通用宏定义、系统版本比较等
5. ExtObjc：runtime方法替换，以及宏定义等
6. Utils：网络类型检测、reachability检测


## BusinessCommon

#### 服务类管理中心：如app检测、路由、定位等。

1. BusinessCommon.h：头文件集合+路由page宏定义+Log宏定义
2. TNCommonNotifications：全局监听Key定义
3. LBS：定位服务
4. Context：全局功能集合：服务管理、Win、Navi控制、页面路由等
5. Service：服务管理、启动等操作
6. OnceService：目前只包含APP更新策略服务
7. Scheme：URL scheme级别路由策略服务 
8. time sync与服务器时间同步
9. Marketing：轮播banner请求和控件实现（置于此处略有不妥）
10. UserTrack：汇总Alicloud和google埋点工具
11. Utils：倒计时和NSDate处理类
12. Configuration：全局变量集结地（目前仅有时间同步功能）

	> TNBusinessCommonService:服务：环境设置、app状态检测、Push消息处理

## Performance

### Debug工具：性能检测库


## Launcher

### app加载器，涵盖初始app的一系列初始化操作

### 1. TNBootLoader：初始化APP的基本加载器

1. 开启TNRunServiceOnce所有服务
2. TNContext初始化服务管理器，开启所有通用服务（非延迟等）
3. 系统级别window、Navi初始化
4. TNLauncherRootController作为root view初始化
5. 开启Debug工具（Debug环境下）


### 2. UIs
1. TNImageGuideView：引导页面
2. TNLauncherRootController：root view

	> 本项目为一基于UITabBarController的子类
	> 本地plist存储item信息
	> 引导页和splash策略
	
3. TNLauncher协议
4. TNLauncherManager：管理launchers
5. TNSplashScreenView：Splash页面

## CommonUI

### 总结：

### 1. CommonUI.h；CommonUIDefines.h
1. 头文件集合
2. 宏定义：bundle数据获取路径

### 2. category集合
1. UIColor
2. UIImage：高斯模糊、QR、水印、渲染优化、resize等
3. UINavigationBar：底部line处理
4. UIVIew和MASViewConstraint：实现某个约束条件隐藏效果

	> 
	```
	cell.tipsLB.collapseWhenHidden = YES;
   cell.fd_collapsibleConstraints = @[cell.infoLB_TopCons.layoutConstraint];
   ```
   
5. UILabel (Menu)：长按复制menu
6. UIButton：点击热区扩展

### 3. CollectionLayout
1. TNFloatingCollectionLayout：流线Layout定义

### 4. Controls：自定义控件集合
1. 待细节解析......

### 5. ImageView
1. ImageView+Net功能

### 6. ImageBlur
1. UIImage+Blur效果

### 7. UILabel
1. 针对UILabel优化

### 8. StyleKit
1. 颜色值集合（基于APP）
2. Font和IconFont处理工具

### 9. TableView
1. 针对列表展示的优化、封装

### 10. ViewControllers
1. 通用Ctrl集合：H5容器、城市定位选择Ctrl
2. TNBaseViewController：Ctrl基类

	> 1. 针对子类控件UIScrollView优化
	> 2. Navi展示控制
	> 3. page手势返回控制
	> 4. 路径埋点
	> 5. status bar控制
	> 6. 设备翻转管理
	
3. TNBaseViewController (TNCustomTop)：自定义顶部导航控件
4. TNTableViewController：列表基类
5. TNNavigationController：导航基类

### 11. Views
1. 基于UIView的控件定制
2. 略

### 12. TNResourceManager
1. bundle资源获取

### 13. Utils
1. TNIconFontHelper：IconFont资源的使用文件
2. TNKeyboardStateListener：keyboard的监听事件（不够完善）

## Account（账户体系）
### 业务

## Movies
### 业务

## Cinemas
### 业务

## Order
### 业务

## Events
### 业务

## Profile
### 业务

## Pods
### 库资源文件