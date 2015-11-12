//
//  WechatPay.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/21.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "WechatPay.h"

#import "payRequsestHandler.h"
#import "WXApi.h"
#import "WXApiObject.h"

@implementation WeChatProduct

//返回实例
+ (WeChatProduct *)getWeChatProduct{
    
    return [[WeChatProduct alloc] init];
}

@end

@implementation WechatPay


//生成付款订单
+ (WeChatProduct *)getProduceWithTradeNo:(NSString *)tradeNo price:(NSString *)price orderName:(NSString *)orderName pay_id:(NSString *)pay_id pay_secret:(NSString *)pay_secret mch_id:(NSString *)mch_id parnerID:(NSString *)parnerID sp_url:(NSString *)sp_url notifyURL:(NSString *)notifyUrl{
    
    if (!tradeNo || !price || !orderName || !pay_id || !pay_secret || !mch_id || !parnerID || !sp_url || !notifyUrl) {
        return nil;
    }
    
    WeChatProduct *product = [WeChatProduct getWeChatProduct];
    product.ordername  = orderName;
    product.orderno = tradeNo;
    product.orderprice = price;
    product.appid = pay_id;
    product.pay_secret = pay_secret;
    product.mch_id = mch_id;
    product.partnerid = parnerID;
    product.notify_url = notifyUrl;
    product.sp_url = sp_url;
    
    return product;
}

//付款
+ (void)payWithProductDic:(WeChatProduct *)product{
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:product.appid mch_id:product.mch_id];
    //设置密钥
    [req setKey:product.partnerid];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithProductDic:[product getAllPropertyAndValue]];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }else{
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }

    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           product.sp_url,
                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                           [product.ordername stringByAddingPercentEscapesUsingEncoding:enc],
                           product.orderprice];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            }
        }
    }
}

@end










