//
//  LCLMeetingDetailTableViewCell.h
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMeetingDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *meetNumberBGLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetAcceptNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
