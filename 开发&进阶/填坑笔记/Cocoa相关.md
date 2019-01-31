
# 填坑笔记

## 目录

* [在主线程更新UI的若干原因](#在主线程更新UI的若干原因)
* [沙盒路径](#沙盒路径)

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