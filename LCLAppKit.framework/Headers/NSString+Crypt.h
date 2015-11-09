//
//  NSString+Crypt.h
//  LCLNetManager
//
//  Created by 李程龙 on 15/5/7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Crypt)

#pragma mark - 字符串转data
/******************************************************************************
 函数名称 : - (NSData *)stringToData
 函数描述 : 将文本转换为data
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSData *)    nsdata
 备注信息 :
 ******************************************************************************/
- (NSData *)stringToData;

    
    
#pragma mark - 字符串UTF8Encode
/******************************************************************************
 函数名称 : - (NSString *)encodeWithUTF8
 函数描述 : 将文本转换为UTF8格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    UTF8格式字符串
 备注信息 :
 ******************************************************************************/
- (NSString *)encodeWithUTF8;
- (NSString *)decodeWithUTF8;



#pragma mark - 字符串unicode
/******************************************************************************
 函数名称 : - (NSString *)utf8ToUnicode
 函数描述 : 将文本转换为unicode格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    unicode格式字符串
 备注信息 :
 ******************************************************************************/
- (NSString *)utf8ToUnicode;



#pragma mark - base64
#pragma mark - 加密
/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFromTextData:(NSData *)data;

#pragma mark - 解密
/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;


#pragma mark - md5 加密
/******************************************************************************
 函数名称 : - (NSString *)encodeWith16MD5
 函数描述 : 将文本进行16位md5加密
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    16位md5加密后文本
 备注信息 :
 ******************************************************************************/
- (NSString *)encodeWith16MD5;

/******************************************************************************
 函数名称 : - (NSString *)encodeWith16MD5
 函数描述 : 将文本进行32位md5加密
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    32位md5加密后文本
 备注信息 :
 ******************************************************************************/
- (NSString *)encodeWith32MD5;






@end














