//
//  NSString+URL.m
//  Messenger
//
//  Created by duanran on 15/12/30.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
@end
