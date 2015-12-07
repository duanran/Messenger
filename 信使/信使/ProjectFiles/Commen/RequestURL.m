//
//  RequestURL.m
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "RequestURL.h"
#define Number(n) [NSNumber numberWithInteger:n]

@implementation RequestURL
+ (NSString *)urlWithTpye:(URLType)urltype{
    
    static NSDictionary *urlDictionary = nil;
    if (!urlDictionary) {
        urlDictionary = @{
                          Number(URLTypeWatchVideo)                 :     @"/index.php/Api/User/getVideo",
                          Number(URLTypeLookPhoneUpDate)                 :     @"/index.php/Api/Date/lists",
                          Number(URLTypeGiveCoin)                 :     @"/index.php/Api/Pay/giveCoin",
                          Number(URLTypePushBindUser)              :    @"/index.php/Api/Addons/execute/_addons/Baidupush/_controller/Api/_action/bindUser",
                          Number(URLTypeComplain)               :@"/index.php/Api/Date/tousuPic",
                          Number(URLTypeSaveVideo)             :@"/index.php/Api/User/saveVideo",
                          Number(URLTypeComplainDate)           :@"/index.php/Api/Date/tousu",
                          Number(URLTypeCancelComplain)         :@"/index.php/Api/Date/deltousu",
                          Number(URLTypeSearchNearPeople)       :@"/index.php/Api/Date/lists",
                          Number(URLTypeRechargeRecord):@"/index.php/Api/User/pay_coin_list",
                          Number(URLTypeConsumeRecord):@"/index.php/Api/User/countList"
                          };
    }
    NSString *urlString = [urlDictionary objectForKey:Number(urltype)];
    NSAssert(urlString, @"URL 为空");
    return [BaseUrl stringByAppendingString:urlString];
}

@end
