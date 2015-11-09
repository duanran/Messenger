//
//  LCLARCImagePickerController.m
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCImagePickerController.h"
#import "LCLARCImagePickerViewController.h"

@interface LCLARCImagePickerController ()<LCLARCImagePickerViewControllerDelegate>

@end

@implementation LCLARCImagePickerController

- (void)dealloc{

    self.lclARCImagePickerControllerDelegate = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{

    LCLARCImagePickerViewController *view = [[LCLARCImagePickerViewController alloc]init];
    view.lclImagePickerViewDelegate = self;
    self = [super initWithRootViewController:view];

    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma LCLARCImagePickerViewControllerDelegate Methods

//取消
- (void)lclARCImagePickerViewControllerDidCancel{

    if (self.lclARCImagePickerControllerDelegate && [self.lclARCImagePickerControllerDelegate respondsToSelector:@selector(lclARCImagePickerControllerDidCancel)]) {
        [self.lclARCImagePickerControllerDelegate lclARCImagePickerControllerDidCancel];
    }
}

//完成
- (void)lclARCImagePickerViewControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage{

    if (self.lclARCImagePickerControllerDelegate && [self.lclARCImagePickerControllerDelegate respondsToSelector:@selector(lclARCImagePickerControllerDidFinishPickingImage:lclThumbnailImage:)]) {
        [self.lclARCImagePickerControllerDelegate lclARCImagePickerControllerDidFinishPickingImage:image lclThumbnailImage:lclThumbnailImage];
    }
}


@end








