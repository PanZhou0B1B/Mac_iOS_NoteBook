//
//  IMXTransferCentreProtocol.h
//  IMXBaseModules
//
//  Created by zhoupanpan on 2017/8/10.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMXTransferCentreProtocol <NSObject>

@optional
- (NSString *)formattedEventNameFromOriginal:(NSString *)eventName;

@end
