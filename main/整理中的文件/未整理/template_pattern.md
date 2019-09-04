## 模板模式

> 定义一个操作算法中骨架，而将一些步骤延迟到子类。
> 模板方法使子类可以重定义算法的特殊步骤而不改变该算法的结构

### 理解

我擦这不就是虚基类么。哦，比虚基类多了个父类控制行为。因此我理解模板模式意思是这些固定的通用的方法我都实现了，有几个细节需要你们自己实现，你们如果想要额外的操作，就重载我提供的那个额外方法啊！嗯，就这样！

### 代码示例

	@interface Tea: NSObject
	- (void)drink;
	- (void)washTea;
	- (void)waitTime;
	- (void)extraStep;
	- (BOOL)shouldWashTea;
	@end
	
	#define MethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]
	
	@implementation
	//父类控制行为
	- (void)drink {
		if([self shouldWashTea];
			[self washTea];
		[self waitTime];
		[self extraStep];
	}
	
	- (void)washTea {
		MethodNotImplemented();
	}
	
	- (void)waitTime {
		MethodNotImplemented();
	}
	
	//子类可以重载，比如喝绿茶就不需要洗茶
	- (BOOL)shouldWashTea {
		return YES;
	}
	
	//子类扩展行为
	- (void)extraStep {
	}
	@end
	
### 使用场景
1. 多个子类有多个共同方法，且逻辑基本相同
2. 重要、复杂的算法，把核心算法设计为模板方法，相关子细节让子类填充
3. 重构时常把相同代码抽取到父类中

### 优点
1. 不可变的部分自己实现了，可变的交给子类实现
2. 共同行为放到公共类中啊，避免代码重复
3. 扩展方式：定义一个什么都不做的方法放入基类，子类可以扩展该方法，使得扩展可控
4. 行为由父类控制。

### 疑问
1. 因为流程是父类调用子类的，所以流程顺序是固定的，比如：起床->刷牙->洗脸
但是我非要不洗脸怎么办？
解决方法是提供额外的信息，比如提供shouldWashFace,子类决定是否需要洗脸。
2. 如果需要控制的太多了，或者是逻辑很不同，那样控制的代码太多了。
关于这点感觉还是使用场景限制吧，因为有一个先决条件就是：**逻辑基本相同**。
3. 需要子类实现的方法放入协议实现可以吗？感觉放入协议的话可以明确控制哪些需要子类实现，哪些是可选的，那样还是模板模式吗？
4. 刚开始设计没啥问题，后来需求变更啥的发现对于某个子类，通过父类控制该子类的行为变得不如子类控制方便（比如流程完全不相同），那样对于该特殊子类，可以自己控制行为吗？如果自己控制流程的话，那还是模板模式吗？

### 用例
Masonary中`MASConstraint`类。
	