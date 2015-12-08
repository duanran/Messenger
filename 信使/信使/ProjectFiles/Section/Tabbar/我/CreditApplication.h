//
//  CreditApplication.h
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface CreditApplication : BaseRequest
@property(nonatomic,strong)NSString *ukey;
@property(nonatomic,strong)NSString *coin;
@property(nonatomic,strong)NSString *account;

@end
