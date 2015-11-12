//
//  LCLTipsView.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/24.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCLTipsLocation) {
    LCLTipsLocationStatusBar = 1,
    LCLTipsLocationTop = 2,
    LCLTipsLocationMiddle = 3,
    LCLTipsLocationBottom = 4,
};

@interface LCLTipsView : UIImageView

#pragma mark - 显示提示
+ (void)showTips:(NSString *)tips location:(LCLTipsLocation)location;

@end















