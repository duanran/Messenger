//
//  UIButton+ImageCache.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageCache)

//设置图片
- (void)setImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath;

//设置图片
- (void)setBackgroundImageWithURL:(NSString *)picURL defaultImagePath:(NSString *)defaultImagePath;

@end
