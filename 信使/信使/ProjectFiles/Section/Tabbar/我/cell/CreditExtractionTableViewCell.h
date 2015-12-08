//
//  CreditExtractionTableViewCell.h
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditExtractionTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *createTimeLabel;
@property(nonatomic,strong)IBOutlet UILabel *statusLabel;
@property(nonatomic,strong)IBOutlet UILabel *aliPayAnccount;
@end
