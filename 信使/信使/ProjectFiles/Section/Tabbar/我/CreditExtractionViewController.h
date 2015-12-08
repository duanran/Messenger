//
//  CreditExtractionViewController.h
//  Messenger
//
//  Created by duanran on 15/12/7.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface CreditExtractionViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UIButton *submitBtn;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@end
