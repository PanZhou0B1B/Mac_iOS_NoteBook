//
//  IMXLanguageHelper.m
//  IMXLocalizedModule
//
//  Created by zhoupanpan on 2017/8/8.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXLanguageHelper.h"

static NSString *const kUserLanguage = @"kUserLanguage";

@interface IMXLanguageHelper ()

@property (nonatomic,strong)NSBundle *bundle;

@end
@implementation IMXLanguageHelper

+ (instancetype)sharedInstance
{
    static id instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (instancetype)init {
    
    if (self = [super init]) {
        if (!_bundle) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userLanguage = [defaults valueForKey:kUserLanguage];
            //用户未手动设置过语言
            if (userLanguage.length == 0) {
                NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
                NSString *systemLanguage = languages.firstObject;
                userLanguage = systemLanguage;
            }
            NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
            self.bundle = [NSBundle bundleWithPath:path];
        }
        
    }
    return self;
}
#pragma mark ======  public  ======
- (NSBundle *)lanBundle{
    return self.bundle;
}
- (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [defaults valueForKey:kUserLanguage];
    if (userLanguage.length == 0) {
        NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
        NSString *systemLanguage = languages.firstObject;
        return systemLanguage;
    }
    return userLanguage;
}
- (void)setUserLanguage:(NSString *)language {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    [defaults setValue:language forKey:kUserLanguage];
    [defaults synchronize];
}
- (NSString *)stringWithKey:(NSString *)key {
    
    if (self.bundle) {
        return [_bundle localizedStringForKey:key value:nil table:@"Default"];
    }else {
        return NSLocalizedString(key, nil);
    }
}
@end
