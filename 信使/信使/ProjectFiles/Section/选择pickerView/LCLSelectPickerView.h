//
//  LCLSelectPickerView.h
//  信使
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLSelectPickerView : UIView


+ (void)showWithMiniCompleteBlock:(LCLSelectBolck)miniBlock miniArray:(NSMutableArray *)miniArray maxCompleteBlock:(LCLSelectBolck)maxBlock maxArray:(NSMutableArray *)maxArray  tag:(NSString *)tag;

@end
