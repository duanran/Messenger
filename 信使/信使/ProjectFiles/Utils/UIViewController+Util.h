//
//  UIViewController+Util.h
//  信使
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Util)

- (UIActionSheet *)getActionSheetWithTitle:(NSString *)title otherTitles:(NSArray *)otherTitles cancleTitle:(NSString *)cancleTitle;

@end
