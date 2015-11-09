//
//  Alipay.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/21.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *AlipayNotification;

#define AliPayNotifyURL [NSString stringWithFormat:@"%@/index.php/Api/Pay/server_callback", XSURL]
#define AliPayInvokeIP @"127.0.0.1"
#define AliPaySellerID @"13457211954@163.com"
#define AliPayParnerId @"2088002858720572"

@interface Product : NSObject

@property (strong, nonatomic) NSString *anti_phishing_key;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *exter_invoke_ip;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *notify_url;
@property (strong, nonatomic) NSString *out_trade_no;
@property (strong, nonatomic) NSString *parner_id;
@property (strong, nonatomic) NSString *payment_type;
@property (strong, nonatomic) NSString *return_url;
@property (strong, nonatomic) NSString *seller_email;
@property (strong, nonatomic) NSString *show_url;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *total_fee;

//返回实例
+ (Product *)getProduct;

@end

@interface Alipay : NSObject

//生成付款订单
+ (Product *)getProduceWithTradeNo:(NSString *)tradeNo price:(NSString *)price subject:(NSString *)subject body:(NSString *)body invokeIP:(NSString *)invokeIP notifyURL:(NSString *)notifyUrl sellerID:(NSString *)sellerID parnerID:(NSString *)parnerID;

//付款
+ (void)payWithProductDic:(Product *)product;

@end






