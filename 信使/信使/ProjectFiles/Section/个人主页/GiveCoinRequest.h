//
//  GiveCoinRequest.h
//  Messenger
//
//  Created by duanran on 15/11/16.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface GiveCoinRequest : BaseRequest
@property(nonatomic,strong)NSString *uKey;
@property(nonatomic,strong)NSString *coin;
@property(nonatomic,strong)NSString *uid;
@end
