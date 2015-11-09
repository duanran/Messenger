//
//  LCLSelectPickerView.h
//  信使
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLAddressPickerView : UIView

+ (void)showWithMiniCompleteBlock:(LCLSelectBolck)miniBlock  maxCompleteBlock:(LCLSelectBolck)maxBlock provinceArray:(NSMutableArray *)provinceArray;

@end
