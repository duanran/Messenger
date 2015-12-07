//
//  RechargeRecordViewController.h
//  Messenger
//
//  Created by duanran on 15/12/4.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeRecordViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet UIView *headView;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UIButton *calenderBtn;
@property(nonatomic,strong)IBOutlet UILabel *creditBeansLabel;
@property(nonatomic,strong)IBOutlet UILabel *moneyLabel;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
@property(nonatomic,strong)IBOutlet UITextField *DateField;

@end
