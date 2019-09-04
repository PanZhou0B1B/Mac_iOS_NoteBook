//
//  IMXLanguageManager.h
//  IMXLocalizedCpt
//
//  Created by zhoupanpan on 2017/8/9.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMXLanguageManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)currentLanguage;
- (void)setCurrentLanguage:(NSString *)lan;

- (NSString *)localizedStringWithKey:(NSString *)key comment:(NSString *)comment tbl:(NSString *)tbl fmwk:(NSString *)fkName;
@end
