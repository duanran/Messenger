//
//  LCLImageHelper.m
//  碧桂园即时通信
//
//  Created by 李程龙 on 14-7-7.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLImageHelper.h"

#import "LCLFilePathHelper.h"

#import <Accelerate/Accelerate.h>

@implementation LCLImageHelper

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight){
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

//设置圆角图片
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r{
    
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapAlphaInfoMask);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

//获取屏幕截图
+(NSData *)getScreenImageDataFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    image = nil;
    view = nil;
    
    return imageData;
}

//获取屏幕截图
+ (UIImage *)getScreenImageFromView:(UIView *)theView{

    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//调整图片大小
+ (UIImage *)scaleImage:(UIImage *)image scale:(float)scale{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scale,image.size.height*scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height *scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//调整图片大小
+ (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//获取bundle里面的图片 例如@"LCLGeneralResources.bundle/random.png"
+ (UIImage*)getLCLImageFromCustomBundleWithImagePath:(NSString *)path{
    
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    
    return [[UIImage imageWithData:[NSMutableData dataWithContentsOfFile:main_images_dir_path options:NSDataReadingMappedIfSafe error:nil]]stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

//获取layer渲染的图片
+ (UIImage *)imageFromLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

//根据颜色生成图片
+ (UIImage *)getImageWithColor:(UIColor *)color imageSize:(CGSize)imageSize{

    if (!color) {
        return nil;
    }
    // 使用颜色创建UIImage
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

//高斯模糊图片 1为最高模糊度
+ (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from LCLAppKit convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - 创建icon图片 输出图片地址
+ (void)createImageWithIconImageName:(NSString *)iconName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *folderPath = [LCLFilePathHelper getLCLCacheFolderPathWithFolderName:@"testImage"];
        NSLog(@"iconPath:==%@==", folderPath);
        
        UIImage *image = [UIImage imageNamed:iconName];
        
        UIImage *saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(72, 72)];
        NSData *imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"Logo_72_72.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(120, 120)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"Logo_120.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(144, 144)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"Logo_144_144.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(57, 57)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(114, 114)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon@2x.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(76, 76)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon~ipad.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(152, 152)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon@2x~ipad.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(28, 28)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon_28_28.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(108, 108)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon_108_108.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(512, 512)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon_512_512.png"] atomically:YES];
        
        saveImage = [LCLImageHelper scaleImage:image size:CGSizeMake(16, 16)];
        imageData = UIImagePNGRepresentation(saveImage);
        [imageData writeToFile:[folderPath stringByAppendingString:@"icon_16_16.png"] atomically:YES];
    });
}




@end







