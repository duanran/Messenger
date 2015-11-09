//
//  LCLHomeTableViewCell.h
//  守艺
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HomeCellScale 3/4.0

@protocol LCLHomeTableViewCellDelegate <NSObject>

@optional
- (void)didSelectHomeTableViewCellCategoryWithTag:(NSInteger)categoryTag button:(UIButton *)button;

- (void)longpressSelectHomeTableViewCellCategoryWithTag:(NSInteger)categoryTag button:(UIButton *)button;

@end

@interface LCLPictureTableViewCell : UITableViewCell

@property (nonatomic) CGFloat scale;
@property (weak, nonatomic) id<LCLHomeTableViewCellDelegate> homeCellDelegate;


//设置信息
- (void)setCategoryDic:(NSDictionary *)categoryDic buttonTag:(NSInteger)buttonTag i:(int)i;


@end
