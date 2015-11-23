//
//  LCLTipsView.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/24.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLTipsView.h"

#import "UIView+Animation.h"

#define AnimationTime 0.5
#define DismissAnimationTime 1.5

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface LCLTipsView (){

    UIWindow *statusBarWindow;
}

@end

@implementation LCLTipsView

#pragma mark - 显示提示
+ (void)showTips:(NSString *)tips location:(LCLTipsLocation)location{
   
    LCLTipsView *tipsView = [self getShowTipsViewWithTips:tips location:location];
    
    if (location==LCLTipsLocationStatusBar) {
        
        if (!tipsView->statusBarWindow) {
            tipsView->statusBarWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
            tipsView->statusBarWindow.backgroundColor = [UIColor clearColor];
            tipsView->statusBarWindow.userInteractionEnabled = YES;
            tipsView->statusBarWindow.windowLevel = UIWindowLevelStatusBar;
            [tipsView->statusBarWindow setHidden:NO];
        }
        [tipsView->statusBarWindow addSubview:tipsView];
        
        [tipsView performSelector:@selector(dismissFromStatusBar) withObject:nil afterDelay:DismissAnimationTime];
    }else{
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipsView];
        [tipsView performSelector:@selector(dismissAfterSeconds) withObject:nil afterDelay:DismissAnimationTime];
    }
}

//获取显示的view
+ (LCLTipsView *)getShowTipsViewWithTips:(NSString *)tips location:(LCLTipsLocation)location{

    if ([tips isKindOfClass:[NSNull class]]) {
        tips = @"null";
    }
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    
    LCLTipsView *imageView = [[LCLTipsView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [imageView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    
    float w = 18*2; //tips边框宽度
    float orgX = 20.0;
    float orgY = 65.0;
    float maxWidth = kDeviceWidth-orgX*2;
    float maxHeight = kDeviceHeight-orgY*2;

    if (location==LCLTipsLocationStatusBar) {
        font = [UIFont systemFontOfSize:12.0];
        w = 3*2;
        maxWidth = kDeviceWidth;
        maxHeight = orgY;
    }else{
        [imageView setRoundedRadius:4.0];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize tipsSize = [tips boundingRectWithSize:CGSizeMake(maxWidth-w, maxHeight-w) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    float backWidth = tipsSize.width+w;
    float backHeight = tipsSize.height+w;
    float backX = orgX+(maxWidth-backWidth)/2.0;
    float backY = orgY+(maxHeight-backHeight)/2.0;
    if (location==LCLTipsLocationTop) {
        backY = orgY;
    }else if (location==LCLTipsLocationBottom){
        backY = orgY+maxHeight-backHeight;
    }

    [imageView setFrame:CGRectMake(backX, backY, backWidth, backHeight)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(w/2.0, w/2.0, tipsSize.width, tipsSize.height)];
    [textLabel setFont:font];
    [textLabel setText:tips];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setNumberOfLines:0];
    [imageView addSubview:textLabel];
    
    if (location==LCLTipsLocationStatusBar) {
        float tipsHeight = tipsSize.height;
        if (tipsHeight<20-w) {
            tipsHeight = 20.0-w;
        }else if(tipsHeight>orgY-w){
            tipsHeight = orgY-w;
        }
        
        [imageView setFrame:CGRectMake(0, -tipsHeight-w, kDeviceWidth, tipsHeight+w)];
        [textLabel setFrame:CGRectMake(w/2.0, (tipsHeight-tipsSize.height)/2.0, kDeviceWidth-w, tipsSize.height)];
        
        [UIView animateWithDuration:AnimationTime animations:^{
            [imageView setFrame:CGRectMake(0, 0, kDeviceWidth, tipsHeight)];
        }];
    }else{
        [imageView setAlpha:0];
        [UIView animateWithDuration:AnimationTime animations:^{
            [imageView setAlpha:1];
        }];
    }

    return imageView;
}

#pragma mark - 消失
- (void)dismissAfterSeconds{

    [UIView animateWithDuration:AnimationTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissFromStatusBar{
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    [UIView animateWithDuration:AnimationTime animations:^{
        [self setFrame:frame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end











