//
//  LCLMyFocusTableViewCell.h
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMyFocusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;

@property (weak, nonatomic) IBOutlet UILabel *peopleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *peopleHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

- (void)setPeopleNameWithName:(NSString *)name;

@end
