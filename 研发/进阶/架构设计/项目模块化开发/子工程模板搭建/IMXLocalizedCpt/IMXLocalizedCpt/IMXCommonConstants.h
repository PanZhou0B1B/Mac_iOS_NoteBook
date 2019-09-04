//
//  IMXCommonConstants.h
//  IMXLocalizedCpt
//
//  Created by guyouwen on 2017/7/28.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#ifndef IMXCommonConstants_h
#define IMXCommonConstants_h


//设备宽高
#define SCREEN_HEIGHT                               [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width

//国际化
#define __(key) NSLocalizedString(key, key)

/// 通过RGB设置颜色，使用0x格式，如：RGBAAllColor(0xAABBCC);
#define RGBAWith16(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

/// 通过RGB设置颜色，使用0x格式，如：RGBAAllColor(0xAABBCC);
#define RGBWith16(rgb) RGBAWith16(rgb, 1.0)

/// 通过RGB设置颜色，使用 十进制 格式，如：RGBColor(25,23,34);
#define RGBColor(r,g,b) RGBAColor(r,g,b,1)

/// 用于色值r = g = b 的颜色色值 十进制
#define RGBColorSameRGB(sameRGB) [UIColor colorWithRed:sameRGB/255.0 green:sameRGB/255.0 blue:sameRGB/255.0 alpha:1]

/// 产生随机色用于区分不同的空间位置大小
#define RGBColorRandom [UIColor colorWithRed:(random() % 256) / 255.0  \
green:(random() % 256) / 255.0  \
blue:(random() % 256) / 255.0  \
alpha:1.0]

/// 通过RGBA设置颜色，使用 十进制 格式，如：RGBColor(25,23,34);
#define RGBAColor(r,g,b,alphaValue) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alphaValue]

//字体大小
#define UIFontWithName(name,fontSize) [UIFont fontWithName:name size:fontSize]

//购物车相关宏定义 暂时先放这里 以后一定要挪出去
#define CARTANDMESSAGE @"CartAndMessage"
#define CARTSIZE @"cartSize"
#define MSGUNREAD @"msgUnreadNum"
/// 第一次在hamburgerMenu点击为我评分
#define IS_FIRST_Menu_AppStoreReview     @"isFirst_Menu_AppStoreReview"
/// 存储是否显示发送邮件的key
#define DHK_KEY_SEND_EMAIL      @"DHK_KEY_SEND_EMAIL"

#endif /* IMXCommonConstants_h */
