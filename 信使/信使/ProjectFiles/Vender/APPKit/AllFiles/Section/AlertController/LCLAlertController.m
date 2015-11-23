//
//  LCLAlertController.m
//  JoeRhymeLive
//
//  Created by lichenglong on 15/7/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLAlertController.h"

#import "UIView+Animation.h"

#define AnimationTime 0.3
#define AddTag 1000
#define BGViewColor [UIColor colorWithWhite:0 alpha:0.05]

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface LCLAlertWindowController : UIViewController

@property (nonatomic) BOOL hideStatusBar;

@end

@implementation LCLAlertWindowController

- (void)viewDidLoad{
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setUserInteractionEnabled:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden{
    return self.hideStatusBar;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end

@interface BackgroundView : UIButton

@property (assign, nonatomic) LCLAlertStyle alertStyle;
@property (strong, nonatomic) UIViewController *viewController;

@end

@implementation BackgroundView

- (void)dealloc{

    self.viewController = nil;
}

@end


@interface LCLAlertController()

@property (strong, nonatomic) UIWindow *alertWindow;
@property (strong, nonatomic) LCLAlertWindowController *rootController;
@property (nonatomic) BOOL hideStatusBar;

@end

@implementation LCLAlertController

#pragma mark - 创建单例模式
+ (id)getSingletonInstance{
    
    static dispatch_once_t token;
    static id singletonObj = nil;
    
    dispatch_once(&token, ^{
        
        singletonObj = [[[self class] alloc] init];
    });
    
    return singletonObj;
}

//是否隐藏状态栏
+ (void)setHideStatusBar:(BOOL)hide{

    [[LCLAlertController getSingletonInstance] setHideStatusBar:hide];
    [[[LCLAlertController getSingletonInstance] rootController] setHideStatusBar:hide];
}

//隐藏window
+ (void)hideAlertWindow{
    NSArray *viewArray = [[[LCLAlertController getSingletonInstance] alertWindow] subviews];
    BOOL hiden = YES;
    for (id view in viewArray) {
        if ([view isKindOfClass:[BackgroundView class]]) {
            hiden = NO;
            break;
        }
    }
    [[[LCLAlertController getSingletonInstance] alertWindow] setHidden:hiden];
}

//显示view
+ (void)alertFromWindowWithView:(UIView *)view animationBlock:(LCLAlertAnimationBolck)animationBlock tag:(NSInteger)tag{
    
    UIView *bgViews = [[[LCLAlertController getSingletonInstance] alertWindow] viewWithTag:tag+AddTag];
    if (bgViews) {
        [UIView animateWithDuration:AnimationTime animations:^{
            [bgViews setAlpha:0];
        } completion:^(BOOL finished) {
            [bgViews removeFromSuperview];
        }];
    }
    
    LCLAlertStyle alertStyle = LCLAlertStyleCustom;
    
    BackgroundView *bgView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [bgView setBackgroundColor:BGViewColor];
    [bgView setTag:tag+AddTag];
    [bgView setAlertStyle:alertStyle];
    
    [[[LCLAlertController getSingletonInstance] alertWindow] addSubview:bgView];

    [view setTag:tag+AddTag];
    
    if (animationBlock) {
        [[[LCLAlertController getSingletonInstance] alertWindow]setHidden:NO];
        animationBlock(view, bgView);
    }else{
        [self animationWithView:view bgView:bgView alertStyle:alertStyle isAdd:YES];
    }
}

//显示view
+ (void)alertFromWindowWithView:(UIView *)view alertStyle:(LCLAlertStyle)alertStyle tag:(NSInteger)tag{

    UIView *bgViews = [[[LCLAlertController getSingletonInstance] alertWindow] viewWithTag:tag+AddTag];
    if (bgViews) {
        [UIView animateWithDuration:AnimationTime animations:^{
            [bgViews setAlpha:0];
        } completion:^(BOOL finished) {
            [bgViews removeFromSuperview];
        }];
    }
    
    if (!alertStyle) {
        alertStyle = LCLAlertStyleCustom;
    }
    
    BackgroundView *bgView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [bgView setBackgroundColor:BGViewColor];
    [bgView setTag:tag+AddTag];
    [bgView setAlertStyle:alertStyle];
    [bgView addTarget:self action:@selector(tapBgViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[LCLAlertController getSingletonInstance] alertWindow] addSubview:bgView];

    [view setTag:tag+AddTag];
    [self animationWithView:view bgView:bgView alertStyle:alertStyle isAdd:YES];
}

//显示Controller
+ (void)alertFromWindowWithController:(UIViewController *)controller alertStyle:(LCLAlertStyle)alertStyle tag:(NSInteger)tag{

    UIView *bgViews = [[[LCLAlertController getSingletonInstance] alertWindow] viewWithTag:tag+AddTag];
    if (bgViews) {
        [UIView animateWithDuration:AnimationTime animations:^{
            [bgViews setAlpha:0];
        } completion:^(BOOL finished) {
            [bgViews removeFromSuperview];
        }];
    }
    
    if (!alertStyle) {
        alertStyle = LCLAlertStyleCustom;
    }
    
    BackgroundView *bgView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [bgView setBackgroundColor:BGViewColor];
    [bgView setTag:tag+AddTag];
    [bgView setAlertStyle:alertStyle];
    [bgView setViewController:controller];
    [bgView addTarget:self action:@selector(tapBgViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[LCLAlertController getSingletonInstance] alertWindow] addSubview:bgView];

    [controller.view setTag:tag+AddTag];
    [self animationWithView:controller.view bgView:bgView alertStyle:alertStyle isAdd:YES];
}

//移除
+ (void)dismissAlertViewWithAnimationBolck:(LCLAlertAnimationBolck)animationBlock tag:(NSInteger)tag{

    if (animationBlock) {
        
        tag = tag+AddTag;

        UIView *bgViews = [[[LCLAlertController getSingletonInstance] alertWindow] viewWithTag:tag];

        if (bgViews && [bgViews isKindOfClass:[BackgroundView class]]) {
            BackgroundView *bgView = (BackgroundView *)bgViews;
            UIView *view = nil;
            for (UIView *v in [bgView subviews]) {
                if (v.tag==tag) {
                    view = v;
                    break;
                }
            }
            if (view) {
                animationBlock(view, bgView);
            }else{
                [bgView removeFromSuperview];
                [self hideAlertWindow];
            }
        }
    }else{
        [self dismissAlertViewWithTag:tag];
    }
}

//隐藏
+ (void)dismissAlertViewWithTag:(NSInteger)tag{

    tag = tag+AddTag;
    
    UIView *bgViews = [[[LCLAlertController getSingletonInstance] alertWindow] viewWithTag:tag];

    if (bgViews && [bgViews isKindOfClass:[BackgroundView class]]) {
        BackgroundView *bgView = (BackgroundView *)bgViews;
        UIView *view = nil;
        for (UIView *v in [bgView subviews]) {
            if (v.tag==tag) {
                view = v;
                break;
            }
        }
        if (view) {
            [self animationWithView:view bgView:bgView alertStyle:bgView.alertStyle isAdd:NO];
        }else{
            [bgView removeFromSuperview];
            [self hideAlertWindow];
        }
    }else{
        [self hideAlertWindow];
    }
}

//移除
+ (void)dismissAlertView:(UIView *)view{
    if (view) {
        [self dismissAlertViewWithTag:view.tag-AddTag];
    }
}

//移除所有界面
+ (void)dismissAllAlertView{

    NSArray *array = [[[LCLAlertController getSingletonInstance] alertWindow] subviews];
    if (array) {
        for (UIView *bgView in array) {
            if ([bgView isKindOfClass:[BackgroundView class]]) {
                
                [self dismissAlertViewWithTag:bgView.tag-AddTag];
            }
        }
    }else{
        [self hideAlertWindow];
    }
}

//点击背景隐藏
+ (void)tapBgViewAction:(UIButton *)sender{

    [self dismissAlertViewWithTag:sender.tag-AddTag];
}

//获取最终位置
+ (void)animationWithView:(UIView *)view bgView:(UIView *)bgView alertStyle:(LCLAlertStyle)alertStyle isAdd:(BOOL)isAdd {

    [[[LCLAlertController getSingletonInstance] alertWindow] setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    if (!alertStyle) {
        alertStyle = LCLAlertStyleCustom;
    }
    
    [view setShadowLayer:YES];

    CGRect finalFrame = view.frame;
    CGRect orgFrame = view.frame;
    float finalAlpha = 1.0;
    float orgAlpha = 0;

    float w = finalFrame.size.width;
    float h = finalFrame.size.height;
    float xZero = 0;
    float yZero = 0;

    float wFull = kDeviceWidth;
    float hFull = kDeviceHeight;
    float x = wFull-w;
    float y = hFull-h;
    float xMiddle = x/2.0;
    float yMiddle = y/2.0;

    BOOL moveAnimation = NO;
    
    switch (alertStyle) {
        case LCLAlertStyleFadeBottomFull:
            
            finalFrame = CGRectMake(xZero, y, wFull, h);
            orgFrame = CGRectMake(xZero, hFull, wFull, h);
            
            break;
            
        case LCLAlertStyleFadeBottomMiddle:
            
            finalFrame = CGRectMake(xMiddle, y, w, h);
            orgFrame = CGRectMake(xMiddle, hFull, w, h);

            break;
            
        case LCLAlertStyleFadeCenter:
            
            finalFrame = CGRectMake(xMiddle, yMiddle, w, h);
            orgFrame = CGRectMake(xMiddle, hFull, w, h);

            break;
            
        case LCLAlertStyleFadeLeftFull:
            
            finalFrame = CGRectMake(xZero, yZero, w, hFull);
            orgFrame = CGRectMake(-w, yZero, w, hFull);

            break;
            
        case LCLAlertStyleFadeLeftMiddle:
            
            finalFrame = CGRectMake(xZero, yMiddle, w, h);
            orgFrame = CGRectMake(-w, yMiddle, w, h);

            break;
            
        case LCLAlertStyleFadeRightFull:
            
            finalFrame = CGRectMake(x, yZero, w, hFull);
            orgFrame = CGRectMake(wFull, yZero, w, hFull);

            break;
            
        case LCLAlertStyleFadeRightMiddle:
            
            finalFrame = CGRectMake(x, yMiddle, w, h);
            orgFrame = CGRectMake(wFull, yMiddle, w, h);

            break;
            
        case LCLAlertStyleFadeTopFull:
            
            finalFrame = CGRectMake(xZero, yZero, wFull, h);
            orgFrame = CGRectMake(-h, yZero, wFull, h);

            break;
            
        case LCLAlertStyleFadeTopMiddle:
            
            finalFrame = CGRectMake(xMiddle, yZero, w, h);
            orgFrame = CGRectMake(-h, yZero, w, h);

            break;
            
        case LCLAlertStyleMoveBottomFull:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xZero, y, wFull, h);
            orgFrame = CGRectMake(xZero, hFull, wFull, h);

            break;
            
        case LCLAlertStyleMoveBottomMiddle:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xMiddle, y, w, h);
            orgFrame = CGRectMake(xMiddle, hFull, w, h);

            break;
            
        case LCLAlertStyleMoveCenter:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xMiddle, yMiddle, w, h);
            orgFrame = CGRectMake(xMiddle, hFull, w, h);

            break;
            
        case LCLAlertStyleMoveLeftFull:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xZero, yZero, w, hFull);
            orgFrame = CGRectMake(-w, yZero, w, hFull);

            break;
            
        case LCLAlertStyleMoveLeftMiddle:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xZero, yMiddle, w, h);
            orgFrame = CGRectMake(-w, yMiddle, w, h);

            break;
            
        case LCLAlertStyleMoveRightFull:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(x, yZero, w, hFull);
            orgFrame = CGRectMake(wFull, yZero, w, hFull);

            break;
            
        case LCLAlertStyleMoveRightMiddle:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(x, yMiddle, w, h);
            orgFrame = CGRectMake(wFull, yMiddle, w, h);

            break;
            
        case LCLAlertStyleMoveTopFull:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xZero, yZero, wFull, h);
            orgFrame = CGRectMake(-h, yZero, wFull, h);

            break;
            
        case LCLAlertStyleMoveTopMiddle:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xMiddle, yZero, w, h);
            orgFrame = CGRectMake(-h, yZero, w, h);

            break;
           
        case LCLAlertStyleCustomBounceWindow:
            
            moveAnimation = YES;
            finalFrame = CGRectMake(xZero, y, wFull, h);
            orgFrame = CGRectMake(xZero, hFull, wFull, h);
            [[[LCLAlertController getSingletonInstance] alertWindow] setFrame:finalFrame];
            finalFrame.origin.y = 0;
            orgFrame.origin.y = finalFrame.size.height;
            [bgView setBackgroundColor:[UIColor clearColor]];

            break;
            
        default:
            break;
    }
    
    if (isAdd) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [[[LCLAlertController getSingletonInstance] alertWindow]setHidden:NO];
        if (moveAnimation) {
            [view setFrame:orgFrame];
            [bgView setAlpha:orgAlpha];
            [bgView addSubview:view];
            [UIView animateWithDuration:AnimationTime animations:^{
                [bgView setAlpha:finalAlpha];
                [view setFrame:finalFrame];
            }];
        }else{
            [view setFrame:finalFrame];
            [bgView setAlpha:orgAlpha];
            [bgView addSubview:view];
            [UIView animateWithDuration:AnimationTime animations:^{
                [bgView setAlpha:finalAlpha];
            }];
        }
    }else{
        [UIView animateWithDuration:AnimationTime animations:^{
            [bgView setAlpha:orgAlpha];
            if (moveAnimation) {
                [view setFrame:orgFrame];
            }
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [bgView removeFromSuperview];
            [self hideAlertWindow];
        }];
    }
}

//弹出window
- (UIWindow *)alertWindow{
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _alertWindow.backgroundColor = [UIColor clearColor];
        _alertWindow.userInteractionEnabled = YES;
        _alertWindow.windowLevel = UIWindowLevelAlert;
        [_alertWindow setHidden:NO];
        
        self.rootController = [[LCLAlertWindowController alloc] init];
        [self.rootController setHideStatusBar:self.hideStatusBar];
        _alertWindow.rootViewController = self.rootController;
    }
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    return _alertWindow;
}

@end


















