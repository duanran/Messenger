//
//  LCLARCPicManager.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-5.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCPicManager.h"

#import "LCLARCImagePickerController.h"
#import "LCLARCPicManagerImage.m"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface LCLARCPicManager ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, LCLARCImagePickerControllerDelegate>

@property (copy, nonatomic) LCLARCFinishSelectBlock lclCompleteBlock;
@property (copy, nonatomic) LCLARCCancleSelectBlock lclCancleBlock;
@property (copy, nonatomic) LCLARCBeginSelectBlock lclBeginBlock;
@property (copy, nonatomic) LCLSelectBolck lclMovieBlock;

@property (assign, nonatomic) LCLPhotoType lclPicType;

@end


@implementation LCLARCPicManager

//释放内存
- (void)dealloc{
    
    self.lclCompleteBlock = nil;
    self.lclCancleBlock = nil;
    self.lclBeginBlock = nil;
}

//初始化
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//初始化
+ (id) shareLCLARCPicManager{
    
    static dispatch_once_t imageToken;
    static id shareLCLARCPicManager = nil;
    
    dispatch_once(&imageToken, ^{
        shareLCLARCPicManager = [[[self class] alloc] init];
    });
    return shareLCLARCPicManager;
}

//显示图片控制器
+ (void)showLCLPhotoControllerOnViewController:(UIViewController *)viewController lclPhototype:(LCLPhotoType)lclPhotoType finishBlock:(LCLARCFinishSelectBlock)finishBlock cancleBlock:(LCLARCCancleSelectBlock)cancleBlock beginBlock:(LCLARCBeginSelectBlock)beginBlock movieFinish:(LCLSelectBolck)movieFinish{

    [[self shareLCLARCPicManager] showLCLPhotoControllerOnViewController:viewController lclPhototype:lclPhotoType finishBlock:finishBlock cancleBlock:cancleBlock beginBlock:beginBlock movieFinish:movieFinish];
}

//显示图片控制器
- (void)showLCLPhotoControllerOnViewController:(UIViewController *)viewController lclPhototype:(LCLPhotoType)lclPhotoType finishBlock:(LCLARCFinishSelectBlock)finishBlock cancleBlock:(LCLARCCancleSelectBlock)cancleBlock beginBlock:(LCLARCBeginSelectBlock)beginBlock movieFinish:(LCLSelectBolck)movieFinish{
    
    self.lclCompleteBlock = finishBlock;
    self.lclCancleBlock = cancleBlock;
    self.lclBeginBlock = beginBlock;
    self.lclMovieBlock = movieFinish;
    self.lclPicType = lclPhotoType;
    
    if (lclPhotoType == LCLPhotoTypeMyCamera) {
        
        
    }else if (lclPhotoType == LCLPhotoTypeMyLibrary){
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            LCLARCImagePickerController *imagePickerController=[[LCLARCImagePickerController alloc] init];
            imagePickerController.lclARCImagePickerControllerDelegate = self;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }else if (lclPhotoType == LCLPhotoTypeSystemLibrary){
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }else if (lclPhotoType == LCLPhotoTypeSystemCamera){
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }else if (lclPhotoType == LCLPhotoTypeSystemMovie){
    
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            
            imagePickerController.mediaTypes=@[(NSString *)kUTTypeMovie];
            imagePickerController.videoMaximumDuration = 10.0;//10秒
            imagePickerController.videoQuality=UIImagePickerControllerQualityType640x480;
            imagePickerController.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}



#pragma -
#pragma UIImagePickerControllerDelegate Methods
//取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
	[picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    
    self.lclCancleBlock();
}

//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        
        self.lclBeginBlock();
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            
            @autoreleasepool {
                
                NSData *imageData = nil;
                UIImage *newImage = [image fixOrientation];
                imageData = UIImageJPEGRepresentation(newImage, 0);
                newImage = [UIImage imageWithData:imageData scale:0.1];
                
                dispatch_async(dispatch_get_main_queue(),^(){
                    
                    self.lclCompleteBlock(newImage, imageData);
                    
                });
            }
        });
        
        image = nil;
        
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            
        }else{
        
            if (self.lclMovieBlock) {
                self.lclMovieBlock(urlStr);
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        
        if (self.lclMovieBlock) {
            self.lclMovieBlock(nil);
        }

    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        
        if (self.lclMovieBlock) {
            self.lclMovieBlock(url);
        }
    }
}

////完成
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    
//    self.lclBeginBlock();
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        
//        @autoreleasepool {
//            
//            NSData *imageData = nil;
//            UIImage *newImage = [image fixOrientation];
//            imageData = UIImageJPEGRepresentation(newImage, 0);
//            newImage = [UIImage imageWithData:imageData scale:0.1];
//            
//            dispatch_async(dispatch_get_main_queue(),^(){
//                
//                self.lclCompleteBlock(newImage, imageData);
//                
//            });
//        }
//    });
//    
//    image = nil;
//
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    picker = nil;
//    
//
//}

//取消
- (void)lclARCImagePickerControllerDidCancel{

    self.lclCancleBlock();
}

//完成
- (void)lclARCImagePickerControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage{

    self.lclBeginBlock();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        @autoreleasepool {
            
            NSData *imageData = nil;
            UIImage *newImage = [image fixOrientation];
            imageData = UIImageJPEGRepresentation(newImage, 0);
            newImage = [UIImage imageWithData:imageData scale:0.1];
            
            self.lclCompleteBlock(newImage, imageData);
        }
    });
    
    image = nil;
    lclThumbnailImage = nil;
}

@end




















