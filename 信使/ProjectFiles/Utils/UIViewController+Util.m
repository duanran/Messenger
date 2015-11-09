//
//  UIViewController+Util.m
//  信使
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIViewController+Util.h"

@implementation UIViewController (Util)

- (UIActionSheet *)getActionSheetWithTitle:(NSString *)title otherTitles:(NSArray *)otherTitles cancleTitle:(NSString *)cancleTitle{

    NSString *titles = @"";
    for (int i=0; i<otherTitles.count; i++) {
        NSString *t = [otherTitles objectAtIndex:i];
        if (i==0) {
            titles = t;
        }else{
            titles = [NSString stringWithFormat:@"%@,%@", titles, t];
        }
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancleTitle destructiveButtonTitle:nil otherButtonTitles:titles, nil];
    
    return sheet;
}

@end
