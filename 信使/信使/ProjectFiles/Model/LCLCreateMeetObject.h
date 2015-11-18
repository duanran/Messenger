//
//  LCLCreateMeetObject.h
//  信使
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLCreateMeetObject : NSObject

@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *create_time;
@property (strong, nonatomic) NSString *date_time;
@property (strong, nonatomic) NSString *iD;
@property (strong, nonatomic) NSString *onDateCount;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *redbag;
@property (strong, nonatomic) NSString *redbag_type;
@property (strong, nonatomic) NSString *signCount;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) NSString *title;
@property(strong,nonatomic) NSString *lat;
@property(strong,nonatomic) NSString *lng;

//private
@property (strong, nonatomic) NSString *inviteuid;
@property (strong, nonatomic) NSString *ondate;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *pwd;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDictionary *user;


@end







