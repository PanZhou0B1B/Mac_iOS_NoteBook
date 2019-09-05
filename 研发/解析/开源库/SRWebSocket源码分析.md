# h文件

###### 枚举

1. SRReadyState socket连接状态类型
2. SRStatusCode：状态码

###### 主类SRWebSocket

1. CFHTTPMessageRef：http请求包或响应包结构体
2. 初始化方法列表
3. 设置代理队列和runloop定制
4. socket打开、关闭
5. 发送信息、发送ping信息

###### 协议SRWebSocketDelegate

1. 打开、关闭、连接失败、转换，接收到ping信息

2. 接收到消息


###### 其它

NSURLRequest、NSRunLoop等一些扩展辅助。


# m文件

1. SROpCode：信息类型
2. frame_header：信息结构


3. 实现NSStreamDelegate协议


4. 初始化：初始数据以及初始化方法。

	> * wss和https 安全标志
	> * 全局串行队列定制，在队列中设置标识
	> * 其它容器类初始化
	> * stream 初始化
	
	
###### 5. open:打开socket连接

1. 超时检测
2. 更新stream信息，runloop——stream
3. 开启stream流
4. delegate接收信息



	