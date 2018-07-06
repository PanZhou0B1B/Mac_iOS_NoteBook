//
//  IMXLanguageManager.m
//  IMXLocalizedCpt
//
//  Created by zhoupanpan on 2017/8/9.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXLanguageManager.h"

static NSString *const kCurrentLanguage = @"kCurrentLanguage";

@interface IMXLanguageManager ()
@property (nonatomic,strong)NSMutableDictionary *map;
@property (nonatomic,copy)NSString *language;
@end
@implementation IMXLanguageManager

- (void)dealloc{
    
}
+ (instancetype)sharedInstance
{
    static IMXLanguageManager *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (instancetype)init {
    
    if (self = [super init]) {
        if (!_language) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *currentLanguage = [defaults valueForKey:kCurrentLanguage];
            //用户未手动设置过语言
            if (currentLanguage.length == 0) {
                NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
                NSString *systemLanguage = languages.firstObject;
                self.language = systemLanguage;
            }
            else{
                self.language = currentLanguage;
            }
//            NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
//            self.bundle = [NSBundle bundleWithPath:path];
        }
        
    }
    return self;
}
#pragma mark ======  public  ======
- (NSString *)currentLanguage{
    return _language;
}
- (void)setCurrentLanguage:(NSString *)lan{
    if(!lan || lan.length ==0){
        return;
    }
    if([lan isEqualToString:_language]){
        return;
    }
    self.language = lan;
    
    [self.map removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:lan forKey:kCurrentLanguage];
    [defaults synchronize];
}
- (NSString *)localizedStringWithKey:(NSString *)key comment:(NSString *)comment tbl:(NSString *)tbl fmwk:(NSString *)fkName{
    NSBundle *bundle = self.map[fkName];
    if (bundle) {
        return [bundle localizedStringForKey:key value:comment table:tbl];
    }else {
        
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:fkName];
        NSBundle * frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:_language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];
        
        [self.map setObject:bundle forKey:fkName];
        
        return [bundle localizedStringForKey:key value:comment table:tbl];
    }
}
#pragma mark ======  lazy  ======
- (NSMutableDictionary *)map{
    if(!_map){
        _map = [[NSMutableDictionary alloc] init];
    }
    return _map;
}
@end
