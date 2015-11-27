//
//  RequestURL.h
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>
//临时域名
#define BaseUrl @"http://fille.wbteam.cn"

@interface RequestURL : NSObject
typedef NS_ENUM(NSInteger, URLType){
    URLTypeWatchVideo,                   /* 查看视频 */
    URLTypeLookPhoneUpDate,              /* 更新查看手机号码 */
    URLTypeGiveCoin,                    /*  赠送金币 */
    URLTypePushBindUser,                /* 推送绑定用户 */
    URLTypeComplain,                   /* 投诉 */
    URLTypeCancelComplain,             /* 取消投诉 */
    URLTypeSaveVideo,                  /* 存储视频 */
    URLTypeComplainDate,               /* 投诉约会 */
    URLTypeSearchNearPeople,           /* 搜索附近的人 */
};
/*
 * 根据URL类型获取url
 */
+ (NSString *)urlWithTpye:(URLType)urltype;

@end
