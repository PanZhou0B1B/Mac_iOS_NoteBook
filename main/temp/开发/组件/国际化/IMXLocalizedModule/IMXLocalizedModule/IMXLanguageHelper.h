//
//  IMXLanguageHelper.h
//  IMXLocalizedModule
//
//  Created by zhoupanpan on 2017/8/8.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __(KEY) ([[IMXLanguageHelper sharedInstance] stringWithKey:(KEY)])
@interface IMXLanguageHelper : NSObject

+ (instancetype)sharedInstance;

- (NSString *)stringWithKey:(NSString *)key;
@end
