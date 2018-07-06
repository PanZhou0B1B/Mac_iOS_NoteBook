# iOS事件分发机制介绍与应用

打开某App点击登录按钮后弹出登录页面。这是一个事件分发与响应的示例。我们来探究下该过程。

介绍事件分发机制自然绕不开事件。

iOS包含以下几种类型事件：
* 触摸事件
* 按压时间
* 摇动事件
* 远程控制事件
* 编辑菜单时间

本文选择以触摸事件进行介绍。因为相对而言它包含的事件分发机制最全面。

## iOS事件分发流程

iOS应用启动后`UIApplicationMain`函数会创建一个UIApplication的单例。该单例会维护一个`FIFO`的队列进行事件分发。系统检测到触摸事件后就会发给当前Application单例，由该单例进行派发。派发分为下面三个过程：

### 一、hitTest

UIWindow一旦接收到事件后就进行hit-test以查找哪个对象接收该事件。`hitTest:withEvent`方法用于发现在触摸位置的视图。`pointInside:withEvent:`用于检测该点击是否在视图的边界内。`hitTest:withEvent`调用`pointInside:withEvent:`。

hitTest以递归的形式调用直至找到能处理触摸事件的最顶部叶子视图（一般就是手指点中区域所属的视图），那么该视图就会被选中。称为第一响应者。

做个类比就是：老板说我这有个事谁干给干了？经过经理等层层指派，大家都觉得小王合适。

该过程可以通过复写下面方法断点了解。
```
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
```

具体情况如图所示：

![hit_test.png](https://upload-images.jianshu.io/upload_images/1605802-9f42ec78cffb1ebb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 二、sendEvent

一旦确定第一响应者后，UIApplication单例就会发送相关触摸事件到第一响应者。

就好比老本拍板说那就让小王干了。

该过程可以断点button的处理方法进行了解。如图所示：
![sent_enent](https://upload-images.jianshu.io/upload_images/1605802-05dced82deddba54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 三、事件处理

针对触摸事件的处理是重载如下方法：
```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
```
第一响应者接到事件后有以下三种选择：
1. 什么都不不处理（选择不重载上述方法）
2. 处理一部分，剩下的交由其它对象处理（重载处理后调用super）
3. 独自进行处理（重载处理并且不调用super）

如果第一响应者什么都不处理或者处理部分然后调用super，则事件将被发送到一个链式响应路径中，即响应链。该事件遵循以下路径进行转发：

1. 第一响应者
2. 第一响应者的父视图
3. 父视图的父视图，直至关联的视图控制器
4. 视图控制器的父视图控制器，直至根视图
5. 根视图下一响应者是window
6. window的下一响应者是application
7. 最后的响应者是App delegate

若转发至App delegate，且App delegate未进行处理则该事件将被丢弃。

## iOS处理方式

那么事件处理的方式有哪些?我们大致可以划分为下面三类。

1. UIControl的子类
2. TouchEvent
3. 触摸相关手势。

有可能一个对象同时实现了两个或者更多处理方式。那么谁的优先级高些呢？

这个我们可以做个类比，让你实现判断鼠标单机还是双击，那么检测单击的时间会比双击要长。因为双击失效后才会进行单击判定。
同理手势识别不了了，其它才有机会处理，UIControl子类也类似，那么优先级如下所示：

    触摸相关手势 > UIControl的子类 > TouchEvent

一般情况下，我们遇到的是手势触发了就不会继续转发事件了。
这就是为什么有人在UIButton中添加个tap手势看起来正常（别笑）。

## 事件分发机制应用

### 事件分发不同场景方法选择

1. 更改事件分发流程，实现相关类的`hitTest:withEvent:`方法为佳。
2. 扩大点击范围，覆写`pointInside:withEvent:`是个不错的选择。
3. 解决一写如收起键盘等问题，可尝试直接发送事件。如：
    ```
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    ```

4. 选择让父视图或者关联视图控制器处理事件可以这么写（虽然很少见有这么玩的）：
    ```
    [button addTarget:nil action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    ```

### 具体应用场景

#### 实现自定义悬浮窗

根据响应链规则，我们能更好的设计一个自定义悬浮窗。

1. 悬浮窗作为UIWindow的rootController存在
2. 覆写`pointInside:withEvent:`判断事件所属UIWindow
3. 完善自己的事件命中测试，实现视图层级管理

详情参加Flex写法。


#### 模拟点击

通过了解分析事件分发过程，我们能很清楚的知道要实现模拟点击我们只需把点击事件发送给UIApplication单例的队列就可以了。

1. 创建UIEvent对象。
2. 发送UIEvent对象`[[UIApplication sharedApplication] sendEvent:event]`。

#### 统计与修改UITouch

1. hook UIApplication类的`- (void)sendEvent:(UIEvent *)event;`方法
2. 进行统计或修改

注：创建UITouch对象和对UITouch对象进行修改，可以参考[kif-framework](https://github.com/kif-framework/KIF)。

### 参考资料
1. [flex](https://github.com/Flipboard/FLEX)
2. [kif-framework](https://github.com/kif-framework/KIF)
3. [using responders and the responder chain to handle events](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events)



