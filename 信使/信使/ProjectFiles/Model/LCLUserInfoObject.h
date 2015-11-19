//
//  LCLUserInfoObject.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLUserInfoObject : NSObject

//key
@property (nonatomic, strong) NSString *ukey;

//密码
@property (nonatomic, strong) NSString *password;

//密码
@property (nonatomic, strong) NSString *pwd;

@property (nonatomic, strong) NSString *is_follow;

//用户id
@property (nonatomic, strong) NSString *nickname;

//邮件
@property (nonatomic, strong) NSString *email;

//头像
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *pic;

//头像
@property (nonatomic, strong) NSString *nowcity;

//手机
@property (nonatomic, strong) NSString *mobile;

//性别
@property (nonatomic, strong) NSString *sex;

//性别
@property (nonatomic, strong) NSString *age;

//性别
@property (nonatomic, strong) NSString *coin;

//性别
@property (nonatomic, strong) NSString *height;

//qq
@property (nonatomic, strong) NSString *qq;

//qq
@property (nonatomic, strong) NSString *online;

//qq
@property (nonatomic, strong) NSString *phoneout;
@property (strong, nonatomic) NSString *phone;

//qq
@property (nonatomic, strong) NSString *video;

//qq
@property (nonatomic, strong) NSDictionary *vipinfo;

//qq
@property (nonatomic, strong) NSString *weight;

//qq
@property (nonatomic, strong) NSString *vip;

//省
@property (nonatomic, strong) NSString *province_name;

//省
@property (nonatomic, strong) NSString *place;

//市
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *cityname;

//区
@property (nonatomic, strong) NSString *area_name;

//区
@property (nonatomic, strong) NSString *last_login_time;

//区
@property (nonatomic, strong) NSString *lat;

//区
@property (nonatomic, strong) NSString *lng;



//用户id
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *ID;

//上次登录时间
@property (nonatomic, strong) NSString *last_login;

//经验
@property (nonatomic, strong) NSString *exp;
@property (nonatomic, strong) NSString *maxexp;
@property (nonatomic, strong) NSString *minexp;

//等级
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *group_msg;
@property (nonatomic, strong) NSString *group_name;

//积分
@property (nonatomic, strong) NSString *discount;

//是否上传通讯录
@property (nonatomic, strong) NSString *up_address;

@property (strong, nonatomic) NSString *len;
@property (strong, nonatomic) NSString *times;



//需要冻结的信用豆
@property(nonatomic,strong)NSString *freezing_coin;
//报名约会时需要消费的信用豆
@property(nonatomic,strong)NSString *sxf;

//针对审核的开关
@property(nonatomic,strong)NSString *shop_onoff;

@end





