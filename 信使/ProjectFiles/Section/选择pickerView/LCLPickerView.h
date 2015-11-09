//
//  LCLPickerView.h
//  信使
//
//  Created by apple on 15/9/27.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLPickerView : UIView

+ (void)showPickerWithCompleteBlock:(LCLSelectBolck)block dataArray:(NSMutableArray *)dataArray tag:(NSString *)tag;

@end
