//
//  ConsumeTableViewCell.h
//  Messenger
//
//  Created by duanran on 15/12/7.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumeTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *headImageView;
@property(nonatomic,strong)IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *reasonLabel;
@end
