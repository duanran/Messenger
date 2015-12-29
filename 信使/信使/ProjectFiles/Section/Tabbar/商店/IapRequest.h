//
//  IapRequest.h
//  Messenger
//
//  Created by duanran on 15/12/29.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface IapRequest : BaseRequest
@property(nonatomic,strong)NSString *uKey;
@property(nonatomic,strong)NSString *order_no;
@property(nonatomic,strong)NSString *iap_sign;
@end
