//
//  LCLShopInfoObject.h
//  信使
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLShopInfoObject : NSObject

//coin
@property (strong, nonatomic) NSString *coin;
@property (strong, nonatomic) NSString *des;
@property (strong, nonatomic) NSString *iD;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *more;
@property (strong, nonatomic) NSString *pic;

//vip
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *vip;

@property(strong,nonatomic)NSString *is_click;
@end
