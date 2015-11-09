//
//  SJAvatarBrowser.m
//  
//
//  Created by 李程龙 QQ：244272324 on 13-11-1.
//  Copyright (c) 2013年 bgy. All rights reserved.
//

#import "LCLAvatarBrowser.h"

@interface LCLAvatarBrowser(){

    CGRect oldframe;
    
    UIImage *bgyImage;
}

@end

@implementation LCLAvatarBrowser

//初始化
+ (id)shareLCLImageController{
    
    static dispatch_once_t LCLAvatarBrowser;
    static id shareLCLImage = nil;
    
    dispatch_once(&LCLAvatarBrowser, ^{
        shareLCLImage = [[[self class] alloc] init];
    });
    return shareLCLImage;
}

-(void)showImage:(UIImageView *)avatarImageView{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    
    UIImage *image=avatarImageView.image;
    bgyImage = image;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIScrollView *backgroundView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.delegate = self;
    [backgroundView setMinimumZoomScale:1.0];
    [backgroundView setMaximumZoomScale:3.0];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
    [longGesture setMinimumPressDuration:0.3];
    [backgroundView addGestureRecognizer:longGesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            imageView.frame = backgroundView.frame;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
        } completion:^(BOOL finished) {
        }];
    }];
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];

    UIScrollView *backgroundView= (UIScrollView *)tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [backgroundView setZoomScale:1.0];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}

-(void)longPressImage:(UILongPressGestureRecognizer *)longGesture{

    if (longGesture.state==UIGestureRecognizerStateBegan) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存相片",nil];
        [sheet showInView:longGesture.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {//保存图片
        
        //[JDStatusBarNotification showWithStatus:@"正在保存图片到相册"];
        [self saveImageToPhotos:bgyImage];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage{
    
    LCLBackQueue(^(){
        
        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo{
    
    if(error != NULL){
        //[JDStatusBarNotification showWithStatus:@"保存图片失败" dismissAfter:2.0 styleName:JDStatusBarStyleError];
    }else{
        //[JDStatusBarNotification showWithStatus:@"保存图片成功" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (id view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return  nil;
}

@end




