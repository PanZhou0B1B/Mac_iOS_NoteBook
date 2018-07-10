## Native -> JS

###### 1. 自定义通知事件

1. 多用于component -> JS 通知。位于component基类中。
2. 方法：

	``- (void)fireEvent: params: domChanges:``
	
	
###### 2. 事件回调：

1. 多用于module回调结果 -> JS。

	> * 类型一：WXModuleCallback回调通知js一次，便释放。用于一次结果场景。
	> * 类型二：WXModuleKeepAliveCallback回调js n次。可以设置是否多次回调。
	
	

## 跨页面通信	（JS -> JS）

###### 1. BroadcastChannel

## 其它

1. JS Service
2. 