//
//  ViewController.m
//  IMXLocalizedModule
//
//  Created by zhoupanpan on 2017/8/8.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "ViewController.h"
#import "IMXLanguageHelper.h"
@interface ViewController ()
@property (nonatomic,strong)NSBundle *bundle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *localizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 100, 20)];
    localizationLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:localizationLabel];
    
    //利用NSLocalizedString宏对字符串进行国际化适配
    localizationLabel.text = __(@"Hello");
    
    CFAbsoluteTime IMXDebugStartTime = CFAbsoluteTimeGetCurrent();
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    for(int i = 0;i<10000;i++){
        NSString *string = [_bundle localizedStringForKey:@"Hello" value:nil table:@"Default"];
        NSLog(@"==%@",string);
    }
    CFTimeInterval sec2 = CFAbsoluteTimeGetCurrent() - IMXDebugStartTime;
    NSLog(@"2. =====%f s",sec2);
    
   
    
    IMXDebugStartTime = CFAbsoluteTimeGetCurrent();
    for(int i = 0;i<10000;i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle * bundle = [NSBundle bundleWithPath:path];
        NSString *string = [bundle localizedStringForKey:@"Hello" value:nil table:@"Default"];
        NSLog(@"%@==",string);
    }
    CFTimeInterval sec = CFAbsoluteTimeGetCurrent() - IMXDebugStartTime;
    NSLog(@"1. =====%f s",sec);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
