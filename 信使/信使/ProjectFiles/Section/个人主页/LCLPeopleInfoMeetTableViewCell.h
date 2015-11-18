//
//  LCLPeopleInfoMeetTableViewCell.h
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLPeopleInfoMeetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *meetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *meeButton;

@property(nonatomic,strong)IBOutlet UIButton *locationBtn;
@end
