//
//  LCLMeetingButtonTableViewCell.h
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMeetingButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *meetInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *faqiButton;
@property (weak, nonatomic) IBOutlet UIButton *jiedongButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
