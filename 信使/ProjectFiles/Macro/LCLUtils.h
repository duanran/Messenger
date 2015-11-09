//
//  LCLUtils.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#ifndef JoeRhymeLive_LCLUtils_h
#define JoeRhymeLive_LCLUtils_h

// 获取屏幕高度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
// 获取屏幕宽度
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

//后台线程G－C－D
#define LCLBackQueue(block)                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//主线程G－C－D
#define LCLMainQueue(block)                  dispatch_async(dispatch_get_main_queue(),block)

//获取系统版本
#define isIphone                               [[UIScreen mainScreen] bounds].size.width==320
//获取系统版本
#define isIphone6                               [[UIScreen mainScreen] bounds].size.width==375
//获取系统版本
#define isIphone6p                              [[UIScreen mainScreen] bounds].size.width==414

#define APPPurpleColor  [UIColor colorWithRed:121.0/255.0 green:29.0/255.0 blue:146.0/255.0 alpha:1.0]
#define APPGreenColor   [UIColor colorWithHex:0x71c051]
#define TapSelectColor  [UIColor colorWithRed:121.0/255.0 green:29.0/255.0 blue:146.0/255.0 alpha:1.0]
#define TapDefaultColor [UIColor colorWithHex:0x999999]

#define UserInfoKey      @"XSUserInfoKey"
#define DeviceTokenKey         @"FDeviceTokenKey"
#define DefaultUserID          @"-1"
#define FirstStartKey          @"FirstStartKey"

#define TestContact  YES

#define ReceiveNotificationKey @"ReceiveNotificationKey" //收到推送消息 铃铛加红点
#define ClearNotificationKey   @"ClearNotificationKey"     //清空红点
#define SearchNotificationKey  @"SearchNotificationKey"     //搜索


#define DefaultEmptyDataText  @"暂无数据"
#define DefaultEmptyDataFrame  CGRectMake(0, 0, kDeviceWidth, 50)


#define ChangePasswordViewTag   19900
#define SelectMeetTypeViewTag   19901
#define VerifyPasswordViewTag   19902
#define AlertDateTag            111
#define AlertMoneyTypeViewTag   112
#define AlertTypePickerViewTag  113
#define AlertAddressPickerViewTag  114
#define AlertPickerViewTag  115


#endif










