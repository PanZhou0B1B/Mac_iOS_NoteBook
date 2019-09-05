# + (void)load和 + (void)initialize

`+ initialize` 和 `+ load` 是 NSObject 类的两个类方法，它们会在运行时自动调用，我们可以利用其特性做一些初始化操作。

initialize和load的区别在于：load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用。所以如果类没有被引用进项目，就不会有load调用；但即使类文件被引用进来，但是没有使用，那么initialize也不会被调用。

## initialize初探

> \+ (void)initialize 消息是在该类接收到其第一个消息之前调用。
> 
> > 关于这里的第一个消息需要特别说明一下，对于 NSObject 的 runtime 机制而言，其在调用 NSObject 的 + (void)load 消息不被视为第一个消息，但是，如果像普通函数调用一样直接调用 NSObject 的 + (void)load 消息，则会引起 + (void)initialize 的调用。反之，如果没有向 NSObject 发送第一个消息，+ (void)initialize 则不会被自动调用。
> 
> 在应用程序的生命周期中，runtime 只会向每个类发送一次 + (void)initialize 消息.
> 
> >如果该类是子类，且该子类中没有实现 + (void)initialize 消息，或者子类显示调用父类实现 [super initialize], 那么则会调用其父类的实现。也就是说，父类的 + (void)initialize 可能会被调用多次。
> 
> 如果类包含分类（扩展 catagory），且分类重写了initialize方法，那么则会调用分类的 initialize 实现，而原类的该方法实现不会被调用。
> >这个机制同 NSObject 的其他方法(除 + (void)load 方法) 一样，即如果原类同该类的分类包含有相同的方法实现，那么原类的该方法被隐藏而无法被调用。
>
>父类的 initialize 方法先于子类的 initialize 方法调用。

实例：

```
@interface People : NSObject

@end

@implementation People

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface Student : People

@end

@implementation Student

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    Student *student = [[Student alloc] init];
}
@end

```

输出：

```
+[People initialize]
+[Student initialize]

```
**若再次调用初始化实例，initialize 不再调用。**

扩展情况下：

```
@interface Student (Score)

@end

@implementation Student (Score)

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}
@end

```

输出：

```
+[People initialize]
+[Student(Score) initialize]

```


## load初探


\+ (void)load 会在类或者类的分类添加到 Objective-c runtime 时调用，该调用发生在 application:willFinishLaunchingWithOptions: 调用之前调用。

父类的 +load 方法先于子类的 +load 方法调用，分类的 +load 方法先于类本身的 +load 方法调用。


Runtime调用+(void)load时没有autorelease pool:

> 原因是runtime调用+(void)load的时候，程序还没有建立其autorelease pool，所以那些会需要使用到autorelease pool的代码，都会出现异常。这一点是非常需要注意的，也就是说放在+(void)load中的对象都应该是alloc出来并且不能使用autorelease来释放。

不需要显示使用super调用父类中的方法

> super的方法会成功调用，但是这是多余的，因为runtime对自动对父类的+(void)load方法进行调用，而+(void)initialize则会随子类自动激发父类的方法（如Apple文档中所言）不需要显示调用。另一方面，如果父类中的


实例：

```
//父类
@interface People : NSObject
@end
@implementation People

+ (void)initialize {
    NSLog(@"%@ , %s", [self class], __FUNCTION__);
}
+ (void)load {
    NSLog(@"%@, %s", [self class], __FUNCTION__);
}
@end
//子类
@interface Student : People
@end
@implementation Student
+ (void)initialize {
    NSLog(@"%@, %s", [self class], __FUNCTION__);
}
+ (void)load {
    NSLog(@"%@, %s", [self class], __FUNCTION__);
}
@end

//子类分类
@interface Student (Score)
@end
@implementation Student (Score)
+ (void)initialize {
    NSLog(@"%@, %s", [self class], __FUNCTION__);
}
+ (void)load {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}
@end

```

输出：

```
People , +[People initialize]
People, +[People load]
Student, +[Student(Score) initialize]
Student, +[Student load]
Student +[Student(Score) load]
```


实例二：

```
//父类
@interface People : NSObject
@end
@implementation People
+ (void)initialize {
    NSLog(@"%@ , %s", [self class], __FUNCTION__);
}
@end
//子类
@interface Student : People
@end
@implementation Student
+ (void)load {
    NSLog(@"%@, %s", [self class], __FUNCTION__);
}
@end

```

输出：

```
People , +[People initialize]
Student , +[People initialize]
Student, +[Student load]

```

**当子类没有实现 +initialize 而父类有其实现时，父类的实现调用了两次，且 +initialize 的调用在 +load 调用之前，这是因为我们在 +load 实现中包含 [self class] 的调用。**



总结：

+(void)load

	执行时机	在程序运行后立即执行
	若自身未定义，是否沿用父类的方法？	否
	类别中的定义	全都执行，但后于类中的方法

+(void)initialize

	执行时机	在类的方法第一次被调时执行
	若自身未定义，是否沿用父类的方法？	是
	类别中的定义	覆盖类中的方法，只执行一个