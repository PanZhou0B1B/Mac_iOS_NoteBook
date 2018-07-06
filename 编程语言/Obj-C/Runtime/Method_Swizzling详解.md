Method Swizzling

## 提要
1. 本文译自：[http://nshipster.com/method-swizzling/](http://nshipster.com/method-swizzling/)
2. 和另一篇文章[associated objects](http://nshipster.com/associated-objects/)一起，让我们来共同认识下Object-c runtime的黑科技。

## 释义
1. 表现：可以更改现存方法（selector）具体的实现（Imp）
2. 功能：在runtime运行时，更改方法实现
3. 原理：在类的分发列表中，更改selectors与Imp的映射

## 举例
#### 如我们想在一个APP中，记录每个ViewController被push的次数：
##### 方案一：在每个ViewCtrl中，我们需要在`viewDidAppear`中添加track代码
>  缺点：产生大量的重复track代码

##### 方案二：子类化ViewController
> 需要子类化UIViewController、UITableViewController、UINavigationController以及其它基类等。
> 
> 此方案也会产生大量重复的track代码

##### 方案三：使用类别（category）+ method swizzling

## 方案三：category + method swizzling

### 示例

```
#import <objc/runtime.h>
@implementation UIViewController (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end
```

> 注：在计算机技术中，引用转换pointer swizzling是基于名称和位置来指向指针引用的。尽管Object-C的原始细节不可考，但道理是相通的。因为method swizzling通过selector来更改函数指针的引用。（这段翻译的不好）

现在，任何基于UIVViewController的实例或其子类实例，在调用`viewDidAppear`时，均会执行track代码。

### 详解

#### 一、使用场景：
在ViewController中：事务注入、响应事件、视图渲染、网络接口分发等。

#### 二、使用地点
**Swizzling 应该一直在`+(void)load`方法中执行。**

> 在Obj-C类的 runtime中，有2个方法会被自动调用：
> 
> 1. +(void)load:类初始加载完成之后被调用。
> 
> 2. +(void)initialize:对于类或者类实例的所有方法，在被APP调用其中任一之前，调用该方法。
> 
> 3. 因为method swizzling影响全局，所以尽量最少化的执行此种方案。
> 
> 4. +load：可以保证类的初始化过程成功，并且在此之后执行。所以适合扩展系统行为。相对的，+initialize在执行时并不能保证类成功初始化。如果app从不直接发消息给该类，它将不会被调用。


#### 三、dispatch_one

**swizzling替换细节应一直在`dispatch_once`中实现。**

再次重申，因为swizzling属于全局性的变更，所以我们要考虑到runtime的各种安全问题。原子性是其之一，也是保证代码只执行一次的方案。

即使在不同线程之间，GCD的dispatch_once也能保证代码只执行一次。也被认为是单例实现的标准化方案。

#### 四、Selectors、Methods、Implementations

在Obj-C中，`Selectors`、`Methods`、`Implementations`是运行时的主要组成部分。（在一般情况下，我们只是简单的将它们理解为同一概念：函数）

下面我们来看下Apple给出的概念解释：

1. Selector(typedef struct objc_selector *SEL):在runtime期间，代表方法的名称，作为一个C字串注册（映射）在runtime中。

	> 当相关类加载完成之后，编译器生成所属Selectors，并在runtime期间自动完成映射。
	
2. Method(typedef struct objc_method *Method):不透明类型，在类的定义中，表示一个方法。
3. Implementation(typedef id (*IMP)(id, SEL, ...))：该指针类型指向method方法实体（具体实现）的初始位置。

	> 1. id:指向自己的指针。实例方法：指向类的实例；类方法：则指向metaClass。
	> 2. 方法的Selector
	> 3. 后续参数：method
	
关系总结：

1. 一个类含有一个分发列表（dispatch table）：在运行时处理消息发送机制。
2. dispatch table中每个条目为一个Method，含有Key-Value：Sel-IMP。
3. IMP：指针，指向一个具体的方法实现

**swizzling实质：改变一个类的dispatch table，即更改一个存在的selector，去映射新的IMP。也即一个方法实现IMP映射为一个新的Selector。**


#### 五、_cmd调用

```
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", NSStringFromClass([self class]));
}
```
一个疑惑：正常情况下，上述代码将导致一个循环引用错误。

但在swizzling中，并没有这个错误。

因为swizzling在runtime中，`xxx_viewWillAppear:`已被重新指定到原始实现Imp（UIViewController的`-viewWillAppear:`）.

故系统级别调用viewWillAppear，实际执行的是xxx_viewWillAppear的IMP；
而此时`[self xxx_viewWillAppear:]`则是执行viewWillAppear的IMP了。

> 注：在swizzling方法中，记得添加前缀。避免与其它category中造成冲突。


### 注意事项
Swizzling被认为是黑科技，容易引发不可预知的后果。尽管如此，注意以下几项，Method Swizzling还是安全的。

1. 除非必要，应始终调用方法的原始IMP（即不使用swizzling）

	> APIs提供了输入输出的约定，并且IMPs属于黑盒范畴。Swizzling更改了原生IMPs，破坏了这种私有状态，进而影响到全局APP。
	
2. 避免冲突：针对category中的方法添加前缀
3. 知其然知其所以然：不理解swizzling的工作原理，只是简单的复制其实现代码，不仅危险，而且也浪费了深度学习runtime的机会。
	> 通过阅读官方文档[Objective-C Runtime Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html#//apple_ref/c/func/method_getImplementation)并阅读\<objc/runtime.h>文件，对swizzling的工作原理有较深的理解。学习替代想象。

4. 谨慎运用：无论多么熟悉swizzling技术，在下一版本任何问题都有可能发生。

### 资源库
1. [JRSwizzle](https://github.com/rentzsch/jrswizzle):三方库，并针对上述问题，做了相关的安全措施。

### 结语
同[associated objects](http://nshipster.com/associated-objects/)一样,Method Swizzling功能强大，利弊皆有，需要谨慎的使用之。
