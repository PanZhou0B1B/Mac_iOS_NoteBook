## 一、AFNetworking
#### 主要包含必要的AF库文件

#### 1. AFURLConnectionOperation
1. 基于NSOperation的子类
2. 实现协议：（NSSecureCoding）
3. 属性runloopModes、NSURLRequest、NSURLResponse、NSError等
4. 安全策略、inputstream、outputStream
5. dispatch_queue_t completionQueue分发队列（CONCURRENT并行策略）、dispatch_group_t completionGroup
6. userInfo：存储信息
7. 实例初始化
8. pause、resuming（restart）
9. 后台运行设置、progress/download/authenticate/CacheResponse/RedirectResponse callback
10. 批处理请求：batchOfRequestOperations

#### 2. AFHTTPRequestOperation

1. 基于AFURLConnectionOperation的子类
2. NSHTTPURLResponse属性添加
3. CompletionBlock设置
4. 返回数据json处理
5. pause：记录出传输offset；resume时可以实现断点续传等效果。


## 二、JSON
#### 1. DTNumber
1. 入参多种类型，输出多种类型
2. 子类DTBoolean、DTByte、DTCharacter、DTDouble、DTFloat、DTInteger等实现输入/输出的格式转换。

#### 2. TNJsonDecoder：将json解析成对象序列
1. NNSObject扩展：获取属性所属的Class
2. decodeWithClass: elementClass: fromJSONObject:解析json为对应的类型（Dic，Array、基本类型等）

#### 3. TNJsonEncoder
1. 将Dic、array、Obj对象逆向解析为json string

#### 4. TNJsonHelper
1. NSObject、NSDate、NSString、NSData的扩展：实现对象的序列化


## 三、MtopClient

#### 1. TNMtopCacheManager：本次缓存cache信息存取
1. 获取缓存路径
2. 缓存/获取NSString和Data
3. 是否缓存Key对应的数据判断
4. 缓存信息是否已过期
5. 删除key或者所有缓存信息

#### 2. TNMtopClient：单例，同步、异步请求的接口封装（请求+解析），暴露给用户的接口。
1. 宏定义：error、request API Keys、response通用字段、通用参数
2. common error enum、全局变量、block定义等。
3. executeMethodAsync：params：completionBlock：异步请求

	> 1. TNMtopServiceQueue+TNMtopService实现队列化请求
	> 2. 注意需要登录的请求，会使用runloop做等待处理
	> 3. TNMtopInterceptorManager拦截处理
	
4. executeMethod:params:同步请求
    > 1. TNMtopServiceQueue+TNMtopService实现队列化请求
	> 2. 直接请求等待返回结果
	> 3. TNMtopInterceptorManager拦截处理

5. 获取缓存的response--getCachedResponseIfPossbile：

#### 3. TNMtopConnection：在AF上实现同步、异步请求的第一道具体实现

1. 参数传入request，请求的具体实现（在AF库之上）
2. 创建NSOperationQueue，管理AF库中具体的operation请求，并控制同步、异步请求处理
 
#### 4. TNMtopMethod：
1. 登录强制性enum、cache返回与否
2. 参数、methodName接口名称、返回model类型
3. 缓存策略属性

#### 5. TNMtopService：基于TNMtopConnection的封装，实现请求的各项细节配置（如http头、retry次数记录）

1. 各种回调block属性
2. 属性：请求头、https开关、TNMtopConnection属性
3. 组织请求头、编辑url、request，记录失败次数等，并发出请求

#### 6. TNMtopServiceConfiguration：
1. 注意组织开关级别的配置：日常线上切换、appkey&appSecret、host等

#### 7. TNMtopServiceQueue
1. login之后需要重新请求的operation，暂存于此`队列`中.(数组实现）

## 四、Interceptor拦截器
在网络请求前判断是否需要login之后再进行重新请求与否的功能

## 五、Base
#### 1. TNMtopBaseModel
1. 网络解析model需要继承该model

#### 2. TNMtopBaseRequest
1. 网络请求request需要继承该request

#### 3. TNMtopBaseResponse
1. 网络reponse返回需要继承之

----

1. static inline NSString *AFKeyPathFromOperationState(AFOperationState state) {}
2. \#pragma clang diagnostic push
\#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
\#pragma clang diagnostic pop
3. NSRecursiveLock锁的使用
4. [[operations indexesOfObjectsPassingTest:^BOOL(id op, NSUInteger __unused idx, BOOL __unused *stop) {
                    return [op isFinished];
                }] count];
                
5. 类簇，模板模式区别


本文为一张大图：Swift学习路线图谱。
优点：个人感觉将知识点层次化，不仅有利于追加修改，也有利于快速查找。
缺点：与文本信息比较，只能以图片形式发布。所以后续会将xmind原件放置与github上，用来分享和共同完善。