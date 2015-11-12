//
//  LCLARCPicManager.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-5.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LCLPhotoTypeMyLibrary,
    LCLPhotoTypeMyCamera,
    LCLPhotoTypeSystemLibrary,
    LCLPhotoTypeSystemCamera,
    LCLPhotoTypeSystemMovie,
}LCLPhotoType;


typedef void (^LCLARCFinishSelectBlock)(UIImage *image, NSData *imageData);
typedef void (^LCLARCCancleSelectBlock)();
typedef void (^LCLARCBeginSelectBlock)();


@interface LCLARCPicManager : NSObject


//显示图片控制器
+ (void)showLCLPhotoControllerOnViewController:(UIViewController *)viewController lclPhototype:(LCLPhotoType)lclPhotoType finishBlock:(LCLARCFinishSelectBlock)finishBlock cancleBlock:(LCLARCCancleSelectBlock)cancleBlock beginBlock:(LCLARCBeginSelectBlock)beginBlock movieFinish:(LCLSelectBolck)movieFinish;


@end

























