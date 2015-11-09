//
//  Alipay.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/21.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "Alipay.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

NSString *AlipayNotification = @"AlipayNotification";

@implementation Product

//返回实例
+ (Product *)getProduct{

    return [[Product alloc] init];
}

@end

@implementation Alipay

//生成付款订单
+ (Product *)getProduceWithTradeNo:(NSString *)tradeNo price:(NSString *)price subject:(NSString *)subject body:(NSString *)body invokeIP:(NSString *)invokeIP notifyURL:(NSString *)notifyUrl sellerID:(NSString *)sellerID parnerID:(NSString *)parnerID{

    if (!notifyUrl || !tradeNo || !price || !subject || !body || !invokeIP || !sellerID || !parnerID) {
        return nil;
    }
    
    Product *product = [Product getProduct];
    product.anti_phishing_key = @"";
    product.body = body;
    product.exter_invoke_ip = invokeIP;
    product.key = @"";
    product.notify_url = notifyUrl;
    product.out_trade_no = tradeNo;
    product.parner_id = parnerID;
    product.payment_type = @"1";
    product.return_url = @"";
    product.seller_email = sellerID;
    product.show_url = @"";
    product.subject = subject;
    product.total_fee = price;

    return product;
}

//付款
+ (void)payWithProductDic:(Product *)product{

    if (!product) {
        return;
    }
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = product.parner_id;   //合作身份者ID(PID),以 2088 开头由 16 位纯数字组成的字符串。
    NSString *seller = product.seller_email; //支付宝收款账号,手机号码或邮箱格式。
    NSString *privateKey = product.key; //商户方的私钥,pkcs8 格式。
    NSString *notifyURL = product.notify_url; //网站回调URL
    NSString *orderID = product.out_trade_no; //商品订单id
    NSString *price = product.total_fee; //商品价格
    NSString *subject = product.subject; //商品标题
    NSString *body = product.body; //商品描述
    NSString *paymentType = product.payment_type; //付款类型
    NSString *showUrl = product.show_url; //付款类型
    if (!showUrl || [showUrl isEqualToString:@""]) {
        showUrl = @"m.alipay.com";
    }
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    //订单信息
    if ([notifyURL length] == 0 ||
        [orderID length] == 0 ||
        [price length] == 0 ||
        [subject length] == 0 ||
        [body length] == 0 ||
        [paymentType length] == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少订单信息"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderID; //订单ID（由商家自行制定）
    order.productName = subject; //商品标题
    order.productDescription = body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", [price floatValue]]; //商品价格
    order.notifyURL =  notifyURL; //回调URL
    order.paymentType = paymentType;
    order.showUrl = showUrl;
    order.service = @"mobile.securitypay.pay";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipayfruit1c73a6b1cd4940b6";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AlipayNotification object:resultDic];
        }];
    }
}

//生成订单id
+ (NSString *)generateTradeNO{
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++){
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end









