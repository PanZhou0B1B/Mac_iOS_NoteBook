## DataModel使用Struct还是Class的选择

Swift具有丰富的类型，对于开发者来讲，大部分都是全新的体验。这为功能主义者打开了一扇门。


#### Swift值类型

1. 协议定义：

	```
protocol CanSend {
    typealias Message
    func send(messgage: Message) throws
}
```

2. 泛型定义Struct

	```
struct MockSender<T> {
    var sentMessages: [T] = []
   }
   ```
    
3. 实现协议：

	```
extension MockSender : CanSend {
    typealias Message = T
    mutating func send(message: T) throws { 
    	  //若协议方法是"non-mutating"的，我们可以将功能放置在一个"mutating"
        // 对象方法体中，然后调用之。 
        kernel.sendmsg(message) 
    }
}
```





## Struct作为DataModel

#### 使用场景

* Struct主要目的是封装简单的数据类型。
* 值类型数据（如Int）而非引用类型（如String）
* 无需继承其它数据Model


#### 举例：

1. size等类型：如Rect，其封装属性均是值类型Double
2. Range类型：封装属性是Int
3. 3D坐标：封装属性为Double

**在众多例子中，定义一个Class，创建实例并定义变量引用它。即众多实际操作中，用户定制数据Model，更多的是使用Class，而非Struct**
#### 优势

1. Struct是值类型的，故：

	> 1. 安全：无引用计数
	> 2. 内存：无引用计数，故不会导致循环引用内存泄露
	> 3. 快速：值类型是以栈分配，而非堆，因此比Class速度要快。
2. 值类型拷贝无需区分深拷贝浅拷贝。
3. 线程安全：访问不区分线程。


#### 弊端

1. Struct不能实现继承。
2. OC和Swift混编时，无法桥接Struct类型，因为桥接的前提：Swift对象需继承NSObject。
3. Struct不支持被序列化，因此存储会有问题。
4. 需要单例模式时，不能使用Struct


## 参考：

1. http://faq.sealedabstract.com/structs_or_classes/#this-is-a-job-for-monads
