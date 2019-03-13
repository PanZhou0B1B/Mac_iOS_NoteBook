
# 填坑笔记

## 目录

* [在主线程更新UI的若干原因](#在主线程更新UI的若干原因)
* [沙盒路径](#沙盒路径)
* [iOS版本兼容](#iOS版本兼容)

## <span id = "在主线程更新UI的若干原因"> 在主线程更新UI的若干原因 </span>

1. 官方支持。

	> 1. 在Cocoa Touch中，App在主线程中启动初始化了UIApplication，即App入口。

	> 2. 所有UI元素皆是从此开始。
	
2. UIKit库不是线程安全的

	> 1. 在非主线程更新UI，有线程安全问题
	> 2. 在非主线程更新UI，会有屏闪效果
	
3. 物理渲染是同步机制

	> 如UILabel文字渲染：光栅化（矢量Font->像素渲染），在屏幕渲染需要同时进行(同步)，并实时（60次/s），异步渲染将会不及时。
	
	
4. 其它:UI大量计算放入非主线程，但更新渲染仍在主线程

	> 部分情景可以在非主线程执行，比如 AsyncDisplayKit所做，将耗时操作放在非主线程，避免主线程UI更新卡顿。
	
	
	
## <span id = "沙盒路径"> 沙盒路径 </span>

|沙盒目录|内容|
|:--:|:--:|
|Documents|存放应用运行时生成的并且需要保留的数据，iCloud同步时会同步该目录|
|Library/Caches|存放应用运行时生成的数据，iCloud同步时不会同步该目录|
|Library/Preferences/|存放所有的偏好设置|
|tmp/|存放应用运行时的临时数据|


* 代码：

```
    //两种获取应用沙盒路径的不同方法
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSString *preferencesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
    NSString *tmpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    
    //NSSearchPathForDirectoriesInDomains()返回的是一个数组，这是因为对于Mac OS可能会有多个目录匹配某组指定的查询条件，但是在iOS上只有一个匹配的目录
    NSString *documentPath1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *cachePath1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *tmpPath1 = NSTemporaryDirectory();
```

```
//获取数据
NSArray *array = @[@1, @2, @3];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:array,@"1",@"dongdong", @"name", nil];
    
    //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:1 error:nil];
        [jsonData writeToFile:jsonPath atomically:YES];
    }
      
    //在读取的时候首先去文件中读取为NSData类对象，然后通过NSJSONSerialization类将其转化为foundation对象
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
    NSArray *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
```


## <span id = "iOS版本兼容"> iOS版本兼容 </span>

###### 1. 直接获取系统版本

```
NSString *version = [UIDevice currentDevice].systemVersion;
if (version.doubleValue >= 9.0) {
    // 针对 9.0 以上的iOS系统进行处理
} else {
    // 针对 9.0 以下的iOS系统进行处理
}
```


###### 2. 通过Foundation框架版本号:`NSFoundationVersionNumber `判断API 的兼容性

```
#define NSFoundationVersionNumber10_2_5	462.00
#define NSFoundationVersionNumber10_2_6	462.00
#define NSFoundationVersionNumber10_2_7	462.70
#define NSFoundationVersionNumber10_2_8	462.70
......
```

###### 3. 系统宏: 

* `__IPHONE_OS_VERSION_MIN_REQUIRED`:即当前支持的最小系统版本。值等于`Deployment Target`。


```
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    //minimum deployment target is 8.0, so it’s safe to use iOS 8-only code
    当前SDK最小支持的设备系统，即8.0，所以在iOS 8.0设备上是安全的

#else
    //you can use iOS8 APIs, but the code will need to be backwards
    //compatible or it will crash when run on an iOS 7 device
    你仍然可以使用iOS 8的API，但是在iOS 7的设备上可能会crash.
#endif
```


* `__IPHONE_OS_VERSION_MAX_ALLOWED`:即系统版本宏可以判断当前系统版本是否是大于等于某个版本。

```
#ifdef __IPHONE_8_0
// 系统版本大于 iOS8.0 执行
#endif

#ifdef __IPHONE_10_0
// 系统版本大于 iOS10.0 执行
#endif
```


###### 4. `@available` 运行时检查


```
 if (@available(iOS 11, *)) { // >= 11
        NSLog(@"iOS 11");
    } else if (@available(iOS 11, *)) { //>= 10
        NSLog(@"iOS 11");
    } else { // < 10
        NSLog(@" < iOS 10");
    } 
```
	

