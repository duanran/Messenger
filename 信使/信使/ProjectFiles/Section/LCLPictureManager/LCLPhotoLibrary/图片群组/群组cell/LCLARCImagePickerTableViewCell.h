//
//  LCLARCImagePickerTableViewCell.h
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLARCImagePickerTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *lclImageView;
@property (strong, nonatomic) UILabel *lclTitleLabel;
@property (strong, nonatomic) UILabel *lclCountLabel;

//配置信息
- (void)setupWithThumbnailImage:(UIImage *)thumbnail groupName:(NSString *)groupName count:(NSString *)count;

@end






