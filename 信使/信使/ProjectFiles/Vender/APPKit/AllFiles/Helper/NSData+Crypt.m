//
//  NSData+Crypt.m
//  LCLNetManager
//
//  Created by 李程龙 on 15/5/7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "NSData+Crypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+CommonCrypto.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (Crypt)

#pragma mark - AES加密
/******************************************************************************
 函数名称 : - (NSData *)AES256EncryptWithKey:(NSString *)key;
 函数描述 : 将文本进行AES加密
 输入参数 : (NSString *)key 钥匙   NSData 要加密的二进制
 输出参数 : N/A
 返回参数 : (NSData *)    NSData
 备注信息 :
 ******************************************************************************/
- (NSData *)AES256EncryptWithKey:(NSString *)key {
    
    return [self AES256EncryptedDataUsingKey:[[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
}

#pragma mark - AES解密
/******************************************************************************
 函数名称 : - (NSData *)AES256DecryptWithKey:(NSString *)key;
 函数描述 : 将AES加密的data解密
 输入参数 : (NSString *)key 钥匙   NSData 加密后的二进制
 输出参数 : N/A
 返回参数 : (NSData *)    NSData
 备注信息 :
 ******************************************************************************/
- (NSData *)AES256DecryptWithKey:(NSString *)key {
    
    return [self decryptedAES256DataUsingKey:[[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
}

#pragma mark - data转string
/******************************************************************************
 函数名称 : - (NSData *)dataToString
 函数描述 : 将data转换为string
 输入参数 : (NSData *)data    文本data
 输出参数 : N/A
 返回参数 : (NSString *)    string
 备注信息 :
 ******************************************************************************/
- (NSString*)dataToString{
    
    Byte *plainTextByte = (Byte *)[self bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[self length];i++){
        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark - 转 base64 string
- (NSString *)imageDataToBase64Encoding {
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (i < [self length]) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] ;
}

@end






