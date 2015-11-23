//
//  NSData+Crypt.h
//  LCLNetManager
//
//  Created by 李程龙 on 15/5/7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Crypt)

#pragma mark - AES加密
/******************************************************************************
 函数名称 : - (NSData *)AES256EncryptWithKey:(NSString *)key;
 函数描述 : 将文本进行AES加密
 输入参数 : (NSString *)key 钥匙   NSData 要加密的二进制
 输出参数 : N/A
 返回参数 : (NSData *)    NSData
 备注信息 :
 ******************************************************************************/
- (NSData *)AES256EncryptWithKey:(NSString *)key; //加密

#pragma mark - AES解密
/******************************************************************************
 函数名称 : - (NSData *)AES256DecryptWithKey:(NSString *)key;
 函数描述 : 将AES加密的data解密
 输入参数 : (NSString *)key 钥匙   NSData 加密后的二进制
 输出参数 : N/A
 返回参数 : (NSData *)    NSData
 备注信息 :
 ******************************************************************************/
- (NSData *)AES256DecryptWithKey:(NSString *)key; //解密

#pragma mark - data转string
/******************************************************************************
 函数名称 : - (NSData *)dataToString
 函数描述 : 将data转换为string
 输入参数 : (NSData *)data    文本data
 输出参数 : N/A
 返回参数 : (NSString *)    string
 备注信息 :
 ******************************************************************************/
- (NSString*)dataToString;


#pragma mark - 转 base64 string
- (NSString *)imageDataToBase64Encoding;

@end








