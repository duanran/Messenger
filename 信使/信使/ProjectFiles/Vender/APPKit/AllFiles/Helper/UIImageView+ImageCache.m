//
//  UIImageView+ImageCache.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIImageView+ImageCache.h"

#import "LCLCacheDefaults.h"
#import "LCLImageHelper.h"

@implementation UIImageView (ImageCache)

//设置图片
- (void)setImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath{

    if (picURL) {
        NSData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:picURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self setImage:image];
        }else{
            if (defaultImagePath) {
                NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
                [self setImage:[UIImage imageWithData:data]];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [[LCLCacheDefaults standardCacheDefaults]  setCacheFileWithData:data forKey:picURL];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self setImage:image];
                    });
                }
            });
        }
    }else{
        if (defaultImagePath) {
            NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
            [self setImage:[UIImage imageWithData:data]];
        }
    }
}

//设置图片
- (void)setImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath blur:(CGFloat)blur{

    if (picURL) {
        NSData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:picURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self setImage:[LCLImageHelper blurImage:image withBlurLevel:blur]];
        }else{
            if (defaultImagePath) {
                NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
                [self setImage:[UIImage imageWithData:data]];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [[LCLCacheDefaults standardCacheDefaults]  setCacheFileWithData:data forKey:picURL];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self setImage:[LCLImageHelper blurImage:image withBlurLevel:blur]];
                    });
                }
            });
        }
    }else{
        if (defaultImagePath) {
            NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
            [self setImage:[UIImage imageWithData:data]];
        }
    }
}

@end





