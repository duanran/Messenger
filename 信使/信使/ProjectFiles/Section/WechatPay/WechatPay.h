//
//  WechatPay.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/21.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WXPayID         @"wx17929d35ae8879d2"
#define WXPaySecret     @"6188caa81767fcad327e25df0e9b139b"
#define WXMCH_ID        @"1239485902"
#define WXParnerID      @"foshanyunshangzuo440606088159111"


#define WXNotifyURL     @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
#define WXSP_URL        @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

@interface WeChatProduct : NSObject

@property (strong, nonatomic) NSString *ordername;
@property (strong, nonatomic) NSString *orderno;
@property (strong, nonatomic) NSString *orderprice;
@property (strong, nonatomic) NSString *appid;
@property (strong, nonatomic) NSString *pay_secret;
@property (strong, nonatomic) NSString *mch_id;
@property (strong, nonatomic) NSString *partnerid;
@property (strong, nonatomic) NSString *notify_url;
@property (strong, nonatomic) NSString *sp_url; //服务器端支付地址商户自定义）

//返回实例
+ (WeChatProduct *)getWeChatProduct;

@end

@interface WechatPay : NSObject

//生成付款订单
+ (WeChatProduct *)getProduceWithTradeNo:(NSString *)tradeNo price:(NSString *)price orderName:(NSString *)orderName pay_id:(NSString *)pay_id pay_secret:(NSString *)pay_secret mch_id:(NSString *)mch_id parnerID:(NSString *)parnerID sp_url:(NSString *)sp_url notifyURL:(NSString *)notifyUrl;

//付款
+ (void)payWithProductDic:(WeChatProduct *)product;

@end







