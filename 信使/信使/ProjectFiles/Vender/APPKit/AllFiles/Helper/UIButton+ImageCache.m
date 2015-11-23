//
//  UIButton+ImageCache.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIButton+ImageCache.h"

#import "LCLCacheDefaults.h"

@implementation UIButton (ImageCache)

//设置图片
- (void)setImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath{
    
    if (picURL) {
        NSData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:picURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
        }else{
            NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
            [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [[LCLCacheDefaults standardCacheDefaults]  setCacheFileWithData:data forKey:picURL];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self setImage:image forState:UIControlStateNormal];
                    });
                }
            });
        }
    }else{
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
        [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }
}

//设置图片
- (void)setBackgroundImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath{

    if (picURL) {
        NSData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:picURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
            [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [[LCLCacheDefaults standardCacheDefaults]  setCacheFileWithData:data forKey:picURL];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self setBackgroundImage:image forState:UIControlStateNormal];
                    });
                }
            });
        }
    }else{
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:defaultImagePath options:NSDataReadingMappedIfSafe error:nil];
        [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }
}

@end
