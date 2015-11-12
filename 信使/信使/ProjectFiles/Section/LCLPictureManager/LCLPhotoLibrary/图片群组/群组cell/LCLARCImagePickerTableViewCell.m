//
//  LCLARCImagePickerTableViewCell.m
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCImagePickerTableViewCell.h"

@implementation LCLARCImagePickerTableViewCell


- (void)dealloc{
    
    [self.lclCountLabel removeFromSuperview];
    [self.lclImageView removeFromSuperview];
    [self.lclTitleLabel removeFromSuperview];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//配置信息
- (void)setupWithThumbnailImage:(UIImage *)thumbnail groupName:(NSString *)groupName count:(NSString *)count{

    self.lclImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 72, 72)];
    [self.lclImageView setImage:thumbnail];
    [self.lclImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.lclImageView];
    
    self.lclTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 200, 30)];
    [self.lclTitleLabel setText:groupName];
    [self addSubview:self.lclTitleLabel];

    self.lclCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 40, 200, 30)];
    [self.lclCountLabel setText:count];
    [self.lclCountLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.lclCountLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:self.lclCountLabel];

}

@end











