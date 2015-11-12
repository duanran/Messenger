//
//  NSObject+Util.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-10-30.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Util)

#pragma mark - 创建单例模式
+ (id)getSingletonInstance;

#pragma mark - 返回实例
+ (id)allocModel;
+ (id)allocModelWithDictionary:(NSDictionary *)dic;

#pragma mark - 解析json
+ (id)jsonObjWithData:(NSData *)data;
+ (NSData *)jsonDataWithObj:(id)obj;

#pragma mark - 获取udid
+ (NSString *)getUDIDString;

#pragma mark - 应用间跳转
- (void)openAPPURLString:(NSString *)url;

#pragma mark - /* 获取对象的所有属性 不包括属性值 */
- (NSArray *)getAllProperty;

#pragma mark - /* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)getAllPropertyAndValue;

#pragma mark - 获取对象所有方法
- (NSArray *)getMethodList;

#pragma mark - 设置数据模型属性值
- (void)setupModelWithDictionary:(NSDictionary *)dic;

#pragma mark - 打电话
- (void)tellPeopleWithPhoneNumer:(NSString *)phone;

#pragma mark - 发信息
- (void)messagePeopleWithPhoneNumer:(NSString *)phone;

#pragma mark - 发送通知
- (void)postNotificationWithName:(NSString *)name object:(id)object;

#pragma mark - 结束编辑
- (void)endKeyboardEditting;

#pragma mark - 获取字符串宽度高度
- (CGSize)getStringSizeWithString:(NSString *)string fontSize:(CGFloat)fontSize bounce:(CGSize)bounce;

@end





