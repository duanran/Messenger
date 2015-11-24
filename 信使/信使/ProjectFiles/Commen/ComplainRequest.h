//
//  ComplainRequest.h
//  Messenger
//
//  Created by duanran on 15/11/24.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface ComplainRequest : BaseRequest

@property(nonatomic,strong)NSString *uKey;
@property(nonatomic,strong)NSString *pic_id;
@property(nonatomic,strong)NSString *reason;




@end
