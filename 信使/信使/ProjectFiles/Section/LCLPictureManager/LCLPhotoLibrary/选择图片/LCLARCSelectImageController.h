//
//  LCLARCSelectImageController.h
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLARCSelectImageControllerDelegate <NSObject>

//取消
- (void)lclARCSelectImageControllerDidCancel;

//完成
- (void)lclARCSelectImageControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage;

@end


@interface LCLARCSelectImageController : UICollectionViewController<UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *lclImageDictionary;
@property (strong, nonatomic) NSMutableArray *lclImageURLArray;
@property (strong, nonatomic) NSString *lclImageGroupName;

@property (weak, nonatomic) id<LCLARCSelectImageControllerDelegate> lclSelectImageDelegate;

@end







