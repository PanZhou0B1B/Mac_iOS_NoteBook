[Notification与多线程] (http://southpeak.github.io/blog/2015/03/14/nsnotificationyu-duo-xian-cheng/)


我们用 clang 分析下，clang 提供一个命令，可以将Objective-C的源码改写成C++语言，借此可以研究下[obj foo]和objc_msgSend()函数之间有什么关系。
clang -rewrite-objc main.m


http://draveness.me/guan-yu-xie-ios-wen-ti-de-jie-da/
https://github.com/lzyy/iOS-Developer-Interview-Questions

运行时详尽解释：http://tech.glowing.com/cn/objective-c-runtime/

masonry 动画 http://www.starming.com/index.php?v=index&view=81




1、autorelease是什么？

      autorelease是一种支持引用计数的内存管理方式。

      它可以暂时的保存某个对象（object），然后在内存池自己的排干（drain）的时候对其中的每个对象发送release消息
      注意，这里只是发送release消息，如果当时的引用计数（reference-counted）依然不为0，则该对象依然不会被释放。可以用该方法来保存某个对象，也要注意保存之后要释放该对象。

      autorelease可以通过NSAutoreleasePool创建实例。 

2、为什么会有autorelease？

      OC的内存管理机制中比较重要的一条规律是：谁申请，谁释放。

      考虑这种情况，如果一个方法需要返回一个新建的对象，该对象何时释放？


       方法内部是不会写release来释放对象的，因为这样做会将对象立即释放而返回一个空对象；调用者也不会主动释放该对象的，因为调用者遵循“谁申请，谁释放”的原则。那么这个时候，就发生了内存泄露。

      针对这种情况，Objective-C的设计了autorelease，既能确保对象能正确释放，又能返回有效的对象。

      在autorelease的模式下，下述方法是合理的，即可以正确返回结果，也不会造成内存泄露。
ClassA *Func1()
{
ClassA *obj = [[[ClassA alloc]init]autorelease];
return obj;
}
复制代码

3、autorelease是什么原理？

       Autorelease实际上只是把对release的调用延迟了，对于每一个Autorelease，系统只是把该Object放入了当 前的Autorelease pool中，当该pool被释放时，该pool中的所有Object会被调用Release。

4、autorelease何时释放？

       对于autorelease pool本身，会在如下两个条件发生时候被释放（详细信息请参见第5条）

1）、手动释放Autorelease pool

2）、Runloop结束后自动释放

       对于autorelease pool内部的对象在引用计数的retain == 0的时候释放。release和autorelease pool 的 drain都会触发retain--事件。 

5、autorelease释放的具体原理是什么？

       要搞懂具体原理，则要先要搞清楚autorelease何时会创建。

       我们的程序在main()调用的时候会自动调用一个autorelease，然后在每一个Runloop， 系统会隐式创建一个Autorelease pool，这样所有的release pool会构成一个象CallStack一样的一个栈式结构，在每一个Runloop结束时，当前栈顶的 Autorelease pool（main()里的autorelease）会被销毁，这样这个pool里的每个Object会被release。

       可以把autorelease pool理解成一个类似父类与子类的关系，main()创建了父类，每个Runloop自动生成的或者开发者自定义的autorelease pool都会成为该父类的子类。当父类被释放的时候，没有被释放的子类也会被释放，这样所有子类中的对象也会收到release消息。

       那什么是一个Runloop呢？ 一个UI事件，Timer call， delegate call， 一个鼠标事件,键盘按下(MAC OSX),或者iphone上的触摸事件，异步http连接下后当接收完数据时，都会是一个新的Runloop。

       一般来说，消息循环运行一次是毫秒级甚至微秒级的，因此autorelease的效率仍然是非常高的，确实是一个巧妙的设计。 

6、使用有什么要注意的？

1）、NSAutoreleasePool可以创建一个autorelease pool，但该对象本身也需要被释放，如：
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init;
// Code benefitting from a local autorelease pool.
[pool release];
复制代码

       在引用计数环境下，使用[pool release]或[pool drain]效果是相同的，drain仅适用于max os高版本，低版本不适用，而release通用，其它并无太大差别。

2）、在ARC下，不能使用上述方式调用autorelease，而应当使用@autoreleasepool，如：
@autoreleasepool {
   // Code benefitting from a local autorelease pool.
}
复制代码

3）、尽量避免对大内存使用该方法，如图片。对于这种延迟释放机制，还是尽量少用，最好只用在方法内返回小块内存申请地址值的情况下，且参考和领会OC的一些系统方法，如：[NSString stringWithFormat:]。

4）、不要把大量循环操作放到同一个NSAutoreleasePool之间，这样会造成内存峰值的上升。

7、关于多线程，有什么要注意的？

        我还未实际使用到，在官方API翻译出类似如下语句：

1）、对于不同线程，应当创建自己的autorelease pool。如果应用长期存在，应该定期drain和创建新的autorelease pool

       下面这句话摘自官方API，大概是说多线程中如果没有使用到cocoa的相关调用，则不需要创建autorelease pool，我一直没有理解透彻

If, however, your detached thread does not make Cocoa calls, you do not need to create an autorelease pool.

2）、如果不是使用的NSThread，就不要用aoturelease pool，除非你是多线程模式（multithreading mode） ，可以使用NSThread的isMultiThreaded方法测试你的应用是否是多线程模式。



If you are making Cocoa calls outside of the Application Kit’s main thread—for example if you create a Foundation-only application or if you detach a thread—you need to create your own autorelease pool.

If your application or thread is long-lived and potentially generates a lot of autoreleased objects, you should periodically drain and create autorelease pools (like the Application Kit does on the main thread); otherwise, autoreleased objects accumulate and your memory footprint grows. If, however, your detached thread does not make Cocoa calls, you do not need to create an autorelease pool.
