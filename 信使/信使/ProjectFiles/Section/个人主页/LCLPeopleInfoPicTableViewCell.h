//
//  LCLPeopleInfoPicTableViewCell.h
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCLPhotoButton.h"

@protocol LCLPeopleInfoPicTableViewCellDelegate <NSObject>

- (void)didTapPicWithButton:(LCLPhotoButton *)button;

@end

@interface LCLPeopleInfoPicTableViewCell : UITableViewCell

@property (nonatomic) BOOL isFromMe;

@property (strong, nonatomic) NSArray *picArray;

@property (weak, nonatomic) id<LCLPeopleInfoPicTableViewCellDelegate> picCellDelegate;

@end
