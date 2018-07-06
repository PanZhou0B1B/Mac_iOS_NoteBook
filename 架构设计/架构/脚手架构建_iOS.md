1. 新项目创建：

	> 如以`Single View App`为模板创建一个新项目，则需要删除`ViewController`和`Main.storyboard`文件，并`General`中清空`Main Interface`值。
	
2. PCH文件添加：创建`pname-Prefix.pch`命名的文件。

	> * 设置：进入`Target->Build Settings:Precompile Prefix Header=YES；Prefix Header=$(SRCROOT)/$(PROJECT)/$(PROJECT)-Prefix.pch`即可。
	> * 功能：工程内部需要引入的文件、公用宏定义等。
	
3. 创建相关启动文件，如UIViewController子类，UITabBarContrller子类，UINavigationController子类，或者他们的基类文件等。
4. 启动文件设置(简单模式)：

	```
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    
    self.rootCtrl = [[DHRootViewController alloc] init];
    self.rootNavi = [[UINavigationController alloc] initWithRootViewController:self.ctrl];
    
    self.window.rootViewController = self.rootNavi;
    [self.window makeKeyAndVisible];

    return YES;
}
	```
	
	
5. Podfile文件示例（若使用pods的话）：

	```
platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'DHMessageKit' do
inhibit_all_warnings!
use_frameworks!
pod 'SocketRocket', '~> 0.5.1'
#...
end
	```