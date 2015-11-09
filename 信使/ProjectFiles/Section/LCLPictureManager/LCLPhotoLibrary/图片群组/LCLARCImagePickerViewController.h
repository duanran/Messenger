//
//  LCLARCImagePickerViewController.h
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLARCImagePickerViewControllerDelegate <NSObject>

//取消
- (void)lclARCImagePickerViewControllerDidCancel;

//完成
- (void)lclARCImagePickerViewControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage;

@end

@interface LCLARCImagePickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *lclTableView;

@property (strong, nonatomic) NSMutableArray *lclImageGroupArray;
@property (strong, nonatomic) NSMutableArray *lclImageGroupURLArray;

@property (strong, nonatomic) NSMutableDictionary *lclImageDictionary;

@property (weak, nonatomic) id<LCLARCImagePickerViewControllerDelegate> lclImagePickerViewDelegate;

@end



@interface LCLARCImagePickerViewController (Action)

//取消选择图片
- (IBAction)cancleAction:(id)sender;

//获取系统图片信息
-(void)getSystemImagesInfo;

//获取图片
- (void)getImageWithSystemImageUrl:(NSString *)urlStr;

@end




