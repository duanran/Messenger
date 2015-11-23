//
//  LCLAppKit.h
//  LCLAppKit
//
//  Created by 李程龙 on 15/5/10.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

// 获取屏幕高度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
// 获取屏幕宽度
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

//后台线程G－C－D
#define LCLBackQueue(block)                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

//主线程G－C－D
#define LCLMainQueue(block)                  dispatch_async(dispatch_get_main_queue(),block)

//随机包括x-y的数字
#define LCLRandomNum(x, y) [NSNumber numberWithInt:(x + (arc4random() % (y - x + 1)))]

//带有RGBA的颜色设置
#define LCLRGBColor(R, G, B, A)              [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]



#import "LCLFilePathHelper.h"
#import "LCLImageHelper.h"
#import "LCLTimeHelper.h"
#import "JPEngine.h"

#import "NSData+Crypt.h"
#import "NSString+Crypt.h"
#import "NSObject+Util.h"
#import "UIColor+additions.h"
#import "UIView+Animation.h"
#import "UIView+Badge.h"
#import "UIView+Util.h"
#import "UIImageView+ImageCache.h"
#import "UIButton+ImageCache.h"
#import "UITabBar+Badge.h"
#import "NSTimer+Utils.h"
#import "NSURL+Utils.h"

#import "LCLVerifyCodeLabel.h"
#import "LCLNetworkManager.h"
#import "LCLCacheDefaults.h"
#import "LCLAlertController.h"
#import "LCLTipsView.h"
#import "LCLPageScrollView.h"







