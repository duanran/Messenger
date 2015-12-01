//
//  LCLPeopleInfoPicTableViewCell.m
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPeopleInfoPicTableViewCell.h"


@implementation LCLPeopleInfoPicTableViewCell

- (void)dealloc{

    self.picCellDelegate = nil;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPicArray:(NSArray *)picArray{

    _picArray = picArray;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat orgX = 10;
    CGFloat orgY = 10;
    CGFloat width = (kDeviceWidth-4*orgX)/3.0;
    CGFloat height = width*3/4.0;
    
    for (int i=0; i<picArray.count; i++) {
        
        NSDictionary *dic = [picArray objectAtIndex:i];
        LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
        
        NSInteger row = i/3;
        NSInteger column = i%3;
        
        LCLPhotoButton *button = [LCLPhotoButton loadXibView];
        [button setFrame:CGRectMake(orgX*(column+1)+width*column, orgY*(row+1)+height*row, width, height)];
        [button.photoButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [self addSubview:button];
        
        NSString *path = photoObj.thumb_360;
        if (self.isFromMe) {
            path = photoObj.thumb_360;
        }
//        [button.photoButton setBackgroundImageWithURL:path defaultImagePath:DefaultImagePath];
        [button.blurImageView setImageWithURL:path defaultImagePath:DefaultImagePath];
    }
}

- (IBAction)tapButton:(UIButton *)sender{

    LCLPhotoButton *button = (LCLPhotoButton *)sender.superview;
//    [[LCLAvatarBrowser shareLCLImageController] showImage:button.blurImageView];
    if (self.picCellDelegate && [self.picCellDelegate respondsToSelector:@selector(didTapPicWithButton:)]) {
        [self.picCellDelegate didTapPicWithButton:button];
    }
}

@end





