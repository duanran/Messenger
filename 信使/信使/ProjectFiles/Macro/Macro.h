//
//  Macro.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#ifndef JoeRhymeLive_Macro_h
#define JoeRhymeLive_Macro_h

#import <LCLAppKit/LCLAppKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WXApi.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKAddressBook.h>

#import "LCLURL.h"
#import "LCLUtils.h"
#import "LCLMacroModel.h"
#import "LCLBlock.h"

#import "UIScrollView+Refresh.h"
#import "UIView+ResponseData.h"
#import "UIView+EmptyData.h"
#import "UIViewController+Util.h"

#import "LCLWaitView.h"
#import "LCLARCPicManager.h"
#import "LCLGetToken.h"
#import "LCLAppLoader.h"
#import "LCLAvatarBrowser.h"
#import "Alipay.h"
#import "WechatPay.h"
#import "LCLSelectPickerView.h"
#import "LCLAddressPickerView.h"
#import "LCLPickerView.h"

#import "BaseViewController.h"


static NSString * const PushMesseageNotifacation = @"com.MesseageNotifacation";

NS_INLINE void setExtraCellLineHidden(UITableView * tableview)
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableview setTableFooterView:view];
    [tableview setTableHeaderView:view];
}
/*
 获取tableView中的cell
 */

NS_INLINE id EIGetViewBySubView(UIView *t,Class c)
{
    UIView *view = t;
    do
    {
        if(nil == view || [view isKindOfClass:[UIWindow class]])
        {
            return nil;
        }
        view = [view superview];
    } while (![view isKindOfClass:c]);
    return view;
}

NS_INLINE void SavePushChannel_id(NSString *channel_id)
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:channel_id forKey:@"channel_id"];
}
NS_INLINE void removePushChanel_id()
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"channel_id"];

}
NS_INLINE id GetPushChanel_id()
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *chanel_id=[userDefault objectForKey:@"channel_id"];
    return chanel_id;
}
#endif




