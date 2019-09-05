# Runloop 详解

参考链接：

[深入理解RunLoop](http://blog.ibireme.com/2015/05/18/runloop/#base)

[CFRunLoop](https://github.com/ming1016/study/wiki/CFRunLoop)
## 概念

runloop ：是管理和处理事件和消息的`对象`。

* 并提供了一个入口函数来执行 event loop 的逻辑。

	> 线程执行该函数后，就会一直处于该函数内部的`接受消息->等待->处理`的循环中，知道循环结束（传入 quit 消息），函数返回。
	
* iOS 中，提供了2个 runloop 对象：

	* NSRunLoop：基于`CFRunLoopRef `的封装，提供了面向对象的 API，但是这些 api 不是线程安全的。
	
	* CFRunLoopRef：是在 CoreFoundation 框架内的，提供了纯 c 函数的 API，这些 api 都是线程安全的。

## RunLoop 和线程

* 线程：pthread_t 和 NSThread 是一一对应的。
* CFRunLoop 是基于 pthread 来管理的。


### apple 不允许直接创建 RunLoop，只提供了2个自动获取的函数：CFRunLoopGetMain（）、CFRunLoopGetCurrent().

内部实现：

```
//全局的 Dictionary，key 是 pthread_t,value 是 CFRunLoopRef
static CFMutableDictionaryRef loopsDic;

//访问 loosDic 时的锁
static CFSpinLock_t loopsLock;

//获取一个 pthread 对应的 RunLoop
CFRunLoopRef _CFRunLoopGet(pthread_t thread){
	OSSpinLockLock(&loopsLock);

	if(!loopsDic)
		{
		//第一次进入，初始化全局 Dic，并先为主线程创建一个 runloop
		loosDic = CFDictionaryCreateMutable();
		CFRunLoopRef mainLoop = _CFRunLoopCreate();
			CFDictionarySetValue(loopsDic,pthread_main_thread_np(),mainLoop);
	}

	//直接从 dic 里获取
	CFRunLoopRef loop = CFDictionaryGetValue(loopsDic,thread);

	if(!loop)
	{
		//取不到时，new 一个
		loop = _CFRunLoopCreate();
		CFDictionarySetValue(loopsDic,thread,loop);
	
		//注册一个回调，当线程销毁时，顺便也销毁对应的 runloop
		_CFSetTSD(...,thread,loop,__CFFinalizeRunLoop);
	}
	OSSpinLockUnLock(&oopsLock);
	return loop;
}

CFRunLoopRef CFRunLoopGetMain(){
	return _CFRunLoopGet(pthread_main_thread_np());
}

CFRunLoopRef CFRunLoopGetCurrent(){
	return _CFRunLoopGet(pthread_self());
}
```

**结论：从上面的代码可以看出，线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）。**

## RunLoop 对外的接口

* 在 CF 中关于 RunLoop 的有5个类：

	1. CFRunLoopRef:
	2. CFRunLoopModeRef
	3. CFRunLoopSourceRef:事件产生的地方

		> Source有两个版本：Source0 和 Source1。
		>
		> * Source0 只包含了一个回调（函数指针），它并不能主动触发事件。
		>
		> 	处理如 UIEvent，CFSoket 等事件。
		>
		> 	使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
		> 
		> * Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程.
		>
		> 	Mach port驱动，CFMachport，CFMessagePort

	4. CFRunLoopTimerRef:基于时间的触发器.<mark>NSTimer是对RunLoopTimer的封装.

		> 它和 NSTimer 是toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调.
		
	5. CFRunLoopObserverRef:观察者

		> Cocoa框架中很多机制比如CAAnimation等都是由RunLoopObserver触发的 .
		>
		> 每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个:
		
		```
		typedef CF_OPTIONS(CFOptionFlags,CFRunLoopActivity){
			KCFRunLoopEntry,//即将进入 loop
			KCFRunLoopBeforeTimers,//即将处理 timer
			KCFRunLoopBeforeSources，//即将处理 source
			KCFRunLoopBeforeWaiting，//即将进入休眠
			KCFRunLoopAfterWaiting，//刚从休眠中唤醒
			KCFRunLoopExit//即将退出loop
		}
		```
		
		

* 一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 `Source/Timer/Observer`（统称 mode item。同时一个 mode item 也可被加入不同的 mode 中）。

	> 每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。
	> 
	> 如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 `Source/Timer/Observer`，让其互不影响。
	>
	> 如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环。
	
	
## RunLoop 的 mode

* NSDefaultRunLoopMode：默认，空闲状态
* UITrackingRunLoopMode：ScrollView滑动时
* UIInitializationRunLoopMode：启动时
* NSRunLoopCommonModes：Mode集合.

	>  <mark>Timer计时会被scrollView的滑动影响的问题可以通过将timer添加到NSRunLoopCommonModes来解决.
	
	```
	
	```
## 涉及到 RunLoop 的技术：

* 系统级：GCD、mach kernel、block、pthread
* 应用层：NSTimer、UIEvent、Autorelease、NSObject（NSDelayPerform、NSThreadPerformAddition）、CADisplayLink、CATranstion、CAAinimation、NSPort、NSURLConnection、AFNetworking（在开启新线程中添加自己的 runloop 监听事件）

##  RunLoop 在 Main Thread 堆栈中所处的位置

堆栈最底层是start(dyld)，往上依次是main，UIApplication(main.m) -> GSEventRunModal(Graphic Services) -> RunLoop(包含CFRunLoopRunSpecific，CFRunLoopRun，__CFRunLoopDoSouces0，__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION) -> Handle Touch Event


## 使用 RunLoop 案例

* AFNetworking

使用NSOperation+NSURLConnection并发模型都会面临NSURLConnection下载完成前线程退出导致NSOperation对象接收不到回调的问题。AFNetWorking解决这个问题的方法是按照官方的guid:
[https://developer.apple.com...](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLConnection_Class/Reference/Reference.html#//apple_ref/occ/instm/NSURLConnection/initWithRequest:delegate:startImmediately:)
上写的NSURLConnection的delegate方法需要在connection发起的线程runloop中调用，于是AFNetWorking直接借鉴了Apple自己的一个Demo[https://developer.apple.com...](https://developer.apple.com/LIBRARY/IOS/samplecode/MVCNetworking/Introduction/Intro.html)的实现方法单独起一个global thread，内置一个runloop，所有的connection都由这个runloop发起，回调也是它接收，不占用主线程，也不耗CPU资源。

```
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
     @autoreleasepool {
          [[NSThread currentThread] setName:@"AFNetworking"];

          NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
          [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
          [runLoop run];
     }
}

+ (NSThread *)networkRequestThread {
     static NSThread *_networkRequestThread = nil;
     static dispatch_once_t oncePredicate;
     dispatch_once(&oncePredicate, ^{
          _networkRequestThread =
          [[NSThread alloc] initWithTarget:self
               selector:@selector(networkRequestThreadEntryPoint:)
               object:nil];
          [_networkRequestThread start];
     });

     return _networkRequestThread;
}
```


* TableView中实现平滑滚动延迟加载图片

	利用CFRunLoopMode的特性，可以将图片的加载放到NSDefaultRunLoopMode的mode里，这样在滚动UITrackingRunLoopMode这个mode时不会被加载而影响到。(意思就是滚动时，不进行图片的下载操作，额，，这个设计不是太合理)

```
UIImage *downloadedImage = ...;
[self.avatarImageView performSelector:@selector(setImage:)
     withObject:downloadedImage
     afterDelay:0
     inModes:@[NSDefaultRunLoopMode]];
     
```


## 接到程序崩溃时的信号进行自主处理例如弹出提示等

```
CFRunLoopRef runLoop = CFRunLoopGetCurrent();
NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runLoop));
while (1) {
     for (NSString *mode in allModes) {
          CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
     }
}

```


## 异步测试

```
- (BOOL)runUntilBlock:(BOOL(^)())block timeout:(NSTimeInterval)timeout
{
     __block Boolean fulfilled = NO;
     void (^beforeWaiting) (CFRunLoopObserverRef observer, CFRunLoopActivity activity) =
     ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
          fulfilled = block();
          if (fulfilled) {
               CFRunLoopStop(CFRunLoopGetCurrent());
          }
     };

     CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, true, 0, beforeWaiting);
     CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

     // Run!
     CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeout, false);

     CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
     CFRelease(observer);
     return fulfilled;
}
```







