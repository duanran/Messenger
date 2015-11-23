//
//  NSObject+Util.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-10-30.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "NSObject+Util.h"
#import <objc/runtime.h>

@implementation NSObject (Util)

#pragma mark - /* 获取对象的所有属性 不包括属性值 */
- (NSMutableArray *)getAllProperty{
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    
    return propertiesArray;
}

#pragma mark - /* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)getAllPropertyAndValue{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++){
        
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (!propertyValue) {
            propertyValue = @"";
        }
        if ([propertyValue isKindOfClass:[NSNull class]]) {
            propertyValue = @"";
        }
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    
    return props;
}

#pragma mark - /* 获取对象的所有方法 */
-(NSArray *)getMethodList{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++){
        
        Method temp_f = mothList_f[i];
//        IMP imp_f = method_getImplementation(temp_f);
//        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithUTF8String:name_s] forKey:@"FunctionName"];
        [dic setObject:[NSString stringWithFormat:@"%d", arguments] forKey:@"ParameterNum"];
        [dic setObject:[NSString stringWithUTF8String:encoding] forKey:@"Coder"];
        
        [array addObject:dic];
    }
    free(mothList_f);
    
    return array;
}

#pragma mark - 设置数据模型属性值
- (void)setupModelWithDictionary:(NSDictionary *)dic{

//    // KVC (key value coding)键值编码
//    // cocoa 的大招，允许间接修改对象的属性值
//    // 第一个参数是字典的数值
//    // 第二个参数是类的属性
//    [self setValue:dict[@"answer"] forKeyPath:@"answer"];
    
//    // 使用setValuesForKeys要求类的属性必须在字典中存在，可以比字典中的键值多，但是不能少。首字母部分大小写，其他的都要一样
//    [self setValuesForKeysWithDictionary:dict];

    if ([dic isKindOfClass:[NSNull class]] || !dic) {
        return;
    }
    
    NSArray *propertiesArray = [self getAllProperty];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *objKey = key;
        objKey = [objKey lowercaseString];
        for (NSString *str in propertiesArray) {
            NSString *propertyKey = [str lowercaseString];
            if ([objKey isEqualToString:propertyKey]) {
                [self setValue:obj forKeyPath:str];
                break;
            }
        }
    }];
}
- (id)setupModelWithDic:(NSDictionary *)dic{
    
    [self setupModelWithDictionary:dic];
    
    return self;
}

#pragma mark - 返回实例
+ (id)allocModel{

    return [[[self class] alloc] init];
}

+ (id)allocModelWithDictionary:(NSDictionary *)dic{
    
    return [[self allocModel] setupModelWithDic:dic];
}

#pragma mark - 解析json
+ (id)jsonObjWithData:(NSData *)data{
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
+ (NSData *)jsonDataWithObj:(id)obj{
    NSData *encryptedData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return encryptedData;
}

#pragma mark - 获取udid
+ (NSString *)getUDIDString{
    
    NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];
    return udid.UUIDString;
}

#pragma mark - 应用间跳转
- (void)openAPPURLString:(NSString *)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - 创建单例模式
+ (id)getSingletonInstance{
    
    static dispatch_once_t token;
    static id singletonObj = nil;
    
    dispatch_once(&token, ^{
        
        singletonObj = [[[self class] alloc] init];
    });
    
    return singletonObj;
}

#pragma mark - 打电话
- (void)tellPeopleWithPhoneNumer:(NSString *)phone{
    
    if (phone) {
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 发信息
- (void)messagePeopleWithPhoneNumer:(NSString *)phone{

    if (phone) {
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"sms://%@", phone];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 发送通知
- (void)postNotificationWithName:(NSString *)name object:(id)object{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

#pragma mark - 结束编辑
- (void)endKeyboardEditting{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark - 获取字符串宽度高度
- (CGSize)getStringSizeWithString:(NSString *)string fontSize:(CGFloat)fontSize bounce:(CGSize)bounce{

    if (string && ![string isKindOfClass:[NSNull class]]) {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        CGSize tipsSize = [string boundingRectWithSize:bounce options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        return tipsSize;
    }
    return CGSizeZero;
}

//- (void)asynchronouslySetFontName:(NSString *)fontName{
//    
//    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
//    // If the font is already downloaded
//    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
//        // Go ahead and display the sample text.
//        NSUInteger sampleIndex = [_fontNames indexOfObject:fontName];
//        _fTextView.text = [_fontSamples objectAtIndex:sampleIndex];
//        _fTextView.font = [UIFont fontWithName:fontName size:24.];
//        return;
//    }
//    
//    // Create a dictionary with the font's PostScript name.
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
//    
//    // Create a new font descriptor reference from the attributes dictionary.
//    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
//    
//    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
//    [descs addObject:(__bridge id)desc];
//    CFRelease(desc);
//    
//    __block BOOL errorDuringDownload = NO;
//    
//    // Start processing the font descriptor..
//    // This function returns immediately, but can potentially take long time to process.
//    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
//    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
//    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
//        
//        //NSLog( @"state %d - %@", state, progressParameter);
//        
//        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
//        
//        if (state == kCTFontDescriptorMatchingDidBegin) {
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // Show an activity indicator
//                [_fActivityIndicatorView startAnimating];
//                _fActivityIndicatorView.hidden = NO;
//                
//                // Show something in the text view to indicate that we are downloading
//                _fTextView.text= [NSString stringWithFormat:@"Downloading %@", fontName];
//                _fTextView.font = [UIFont systemFontOfSize:14.];
//                
//                NSLog(@"Begin Matching");
//            });
//        } else if (state == kCTFontDescriptorMatchingDidFinish) {
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // Remove the activity indicator
//                [_fActivityIndicatorView stopAnimating];
//                _fActivityIndicatorView.hidden = YES;
//                
//                // Display the sample text for the newly downloaded font
//                NSUInteger sampleIndex = [_fontNames indexOfObject:fontName];
//                _fTextView.text = [_fontSamples objectAtIndex:sampleIndex];
//                _fTextView.font = [UIFont fontWithName:fontName size:24.];
//                
//                // Log the font URL in the console
//                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
//                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
//                NSLog(@"%@", (__bridge NSURL*)(fontURL));
//                CFRelease(fontURL);
//                CFRelease(fontRef);
//                
//                if (!errorDuringDownload) {
//                    NSLog(@"%@ downloaded", fontName);
//                }
//            });
//        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // Show a progress bar
//                _fProgressView.progress = 0.0;
//                _fProgressView.hidden = NO;
//                NSLog(@"Begin Downloading");
//            });
//        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // Remove the progress bar
//                _fProgressView.hidden = YES;
//                NSLog(@"Finish downloading");
//            });
//        } else if (state == kCTFontDescriptorMatchingDownloading) {
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // Use the progress bar to indicate the progress of the downloading
//                [_fProgressView setProgress:progressValue / 100.0 animated:YES];
//                NSLog(@"Downloading %.0f%% complete", progressValue);
//            });
//        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
//            // An error has occurred.
//            // Get the error message
//            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
//            if (error != nil) {
//                _errorMessage = [error description];
//            } else {
//                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
//            }
//            // Set our flag
//            errorDuringDownload = YES;
//            
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                _fProgressView.hidden = YES;
//                NSLog(@"Download error: %@", _errorMessage);
//            });
//        }
//        
//        return (bool)YES;
//    });
//    
//}


@end

























