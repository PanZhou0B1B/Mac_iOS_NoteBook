## Navigator

#### 1. TNNavigatorController
1. 入参初始、目标经纬度
2. 弹出不同Map选择框供用户选择

## Mtop
#### 1. 定位相关的网络请求：Facade+request+model

## TNLBService

1. 全局LB服务协议，继承TNService协议，全局服务特性。
2. 默认实现文件TNLBServiceImpl：实现LB通用接口
3. TNLBServiceImpl

	> 1. 属性：citycode、name等位置相关属性
	> 2. TNService方法实现：start开启定位、blocks执行反馈
	> 3. 本地缓存属性

## APLBService
1. 具体定位请求、火星位置转换、蓝牙定位等技术细节