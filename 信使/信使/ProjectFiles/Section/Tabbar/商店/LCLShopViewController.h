//
//  LCLShopViewController.h
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface LCLShopViewController : BaseViewController<PayPalPaymentDelegate>
@property(nonatomic, strong, readwrite) NSString *environment;//使用环境.
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;// 接收信用卡
@end
