//
//  LCLImageHelper.h
//  碧桂园即时通信
//
//  Created by 李程龙 on 14-7-7.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLImageHelper : NSObject

//获取bundle里面的图片 例如@"LCLGeneralResources.bundle/random.png"
+ (UIImage*)getLCLImageFromCustomBundleWithImagePath:(NSString *)path;

//设置圆角图片
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

//获取屏幕截图
+ (UIImage *)getScreenImageFromView:(UIView *)theView;

//调整图片大小
+ (UIImage *)scaleImage:(UIImage *)image scale:(float)scale;

//调整图片大小
+ (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size;

//获取layer渲染的图片
+ (UIImage *)imageFromLayer:(CALayer *)layer;

//根据颜色生成图片
+ (UIImage *)getImageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

//高斯模糊图片 1为最高模糊度
+ (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur;


#pragma mark - 创建icon图片 输出图片地址
+ (void)createImageWithIconImageName:(NSString *)iconName;


@end
