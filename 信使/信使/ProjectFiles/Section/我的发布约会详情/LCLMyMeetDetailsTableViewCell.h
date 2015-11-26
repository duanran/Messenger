//
//  LCLMyMeetDetailsTableViewCell.h
//  信使
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMyMeetDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetCreateTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property(nonatomic,strong) IBOutlet UIButton *complainBtn;


@end
