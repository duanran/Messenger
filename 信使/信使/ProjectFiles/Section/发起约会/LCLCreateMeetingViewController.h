//
//  LCLCreateMeetingViewController.h
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"



@interface LCLCreateMeetingViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *topMeetInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomMeetInfoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIButton *meetTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic) BOOL isInviteMeet;
@property (strong, nonatomic) NSString *inviteuid;

@property(nonatomic,strong)IBOutlet UIButton *styleBtn;
@property(nonatomic,strong)IBOutlet UIButton *moneyBtn;
@property(nonatomic,strong)IBOutlet UIButton *mapBtn;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn;

@end
