//
//  LCLARCImagePickerController.h
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLARCImagePickerControllerDelegate <NSObject>

//取消
- (void)lclARCImagePickerControllerDidCancel;

//完成
- (void)lclARCImagePickerControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage;

@end


@interface LCLARCImagePickerController : UINavigationController

@property (weak, nonatomic) id<LCLARCImagePickerControllerDelegate> lclARCImagePickerControllerDelegate;

@end










