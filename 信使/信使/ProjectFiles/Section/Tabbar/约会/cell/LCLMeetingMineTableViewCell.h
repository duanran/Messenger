//
//  LCLMeetingMineTableViewCell.h
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMeetingMineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetCreateTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *yuewoButton;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property  (strong,nonatomic) IBOutlet UIButton *locationBtn;

@end
