//
//  SaveVideoRequest.h
//  Messenger
//
//  Created by duanran on 15/11/25.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface SaveVideoRequest : BaseRequest

@property(nonatomic,strong)NSString *ukey;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *firstUrl;
@property(nonatomic,strong)NSString *picPath;
@end
