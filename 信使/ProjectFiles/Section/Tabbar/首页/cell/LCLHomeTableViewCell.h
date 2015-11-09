//
//  LCLHomeTableViewCell.h
//  信使
//
//  Created by 李程龙 on 15/5/28.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;

@property (weak, nonatomic) IBOutlet UILabel *peopleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *yuehuiButton;
@property (weak, nonatomic) IBOutlet UIButton *peopleHeadButton;

- (void)setPeopleNameWithName:(NSString *)name;

@end






