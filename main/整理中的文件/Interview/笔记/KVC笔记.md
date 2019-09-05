# iOS开发之KVC

## 基本概念

Key-value coding,它是一种使用字符串标识符，间接访问对象属性的机制。

不是直接调用getter 和 setter方法。通常我们使用valueForKey 来替代getter 方法，setValue:forKey来代替setter方法。

## 实例

使用KVC 和不使用 KVC 的对比：

```
Persion *persion =  [ [Persion alloc] init ];

//不使用KVC
persion.name = @"hufeng" ;

//使用KVC的写法
[persion  setValue:@"hufeng" forKey:@"name"];
```

复杂些，多个类之间的调用：
不用 KVC：

```
Persion *persion =  [ [Persion alloc] init ];

Phone *phone = persion.phone;

Battery *battery = phone.battery;
```

使用 KVC：

```
Battery *battery = [persion valueForKeyPath: @"phone.battery" ];
```

**注意- valueForKeyPath 里面的值是区分大小写的，你如果写出Phone.Battery 是不行的**

## 序列化

KVC最常用的还是在`序列化`、`反序列化`对象。

把 json 子串反序列化为 obect：

```
- (id)initWithDictionary:(NSDictionary *)dictionary {

    self = [self init];

    if (self){

        [self setValuesForKeysWithDictionary:dictionary];

    }

    return self;

}
```

**注意 这里有一个坑 当我们setValue 给一个没有定义的字典值（forUndefinedKey）时 会抛出NSUndefinedKeyException异常的 记的处理此种情况**

## KVC验证

如果让key 支持 不区分大小写

下面我们提到一个方法initialize

initialize是在类或者其子类的第一个方法被调用前调用。所以如果类没有被引用进项目或者类文件被引用进来，但是没有使用，那么initialize也不会被调用 ，到这里 知道我们接下来要干嘛了吧

```
+ (void)initialize {
    [super initialize];

    dispatch_once(&onceToken, ^{
        modelProperties = [NSMutableDictionary dictionary];
        propertyTypesArray = @[/* removed for brevity */];
    });
    NSMutableDictionary *translateNameDict = [NSMutableDictionary dictionary];
    [self hydrateModelProperties:[self class] translateDictionary:translateNameDict];
    [modelProperties setObject:translateNameDict forKey:[self calculateClassName]];
}

+ (void)hydrateModelProperties:(Class)class translateDictionary:(NSMutableDictionary *)translateDictionary {
    if (!class || class == [NSObject class]){
        return;
    }

    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++){
        objc_property_t p = properties[i];
        const char *name = property_getName(p);
        NSString *nsName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        NSString *lowerCaseName = [nsName lowercaseString];
        [translateDictionary setObject:nsName forKey:lowerCaseName];
        //注意此处哦
        NSString *propertyType = [self getPropertyType:p];
        [self addValidatorForProperty:nsName type:propertyType];
    }
    free(properties);

    [self hydrateModelProperties:class_getSuperclass(class) translateDictionary:translateDictionary];
}
```