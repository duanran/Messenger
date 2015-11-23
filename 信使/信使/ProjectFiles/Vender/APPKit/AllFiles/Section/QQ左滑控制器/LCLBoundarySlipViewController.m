//
//  LCLBoundarySlipViewController.m
//  LCLAppKit
//
//  Created by lichenglong on 15/8/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLBoundarySlipViewController.h"

#define AnimationTime 0.3

NSString *BoundarySlipControllerDidShowLeftNotification = @"BoundarySlipControllerDidShowLeftNotification";
NSString *BoundarySlipControllerDidShowMainNotification = @"BoundarySlipControllerDidShowMainNotification";
NSString *BoundarySlipControllerDidShowRightNotification = @"BoundarySlipControllerDidShowRightNotification";

@interface LCLBoundarySlipViewController (){
    
@private
    UIViewController * leftControl;
    UIViewController * mainControl;
    UIViewController * righControl;
    
    UIImageView * imgBackground;
    
    CGFloat scalef;
}

//是否允许点击视图恢复视图位置。默认为yes
@property (strong, nonatomic) UITapGestureRecognizer *sideslipTapGes;
//当前显示的视图
@property (assign, nonatomic) BoundaryViewType slideLipeType;

@end

@implementation LCLBoundarySlipViewController

#pragma mark - System Methods
- (void)dealloc{

    self.sideslipTapGes = nil;
    
    leftControl = nil;
    mainControl = nil;
    righControl = nil;
    
    imgBackground = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return !self.showStatusBar; //返回NO表示要显示，返回YES将hiden
}

#pragma mark - Plublic Methods
-(instancetype)initWithLeftView:(UIViewController *)leftView
                       mainView:(UIViewController *)mainView
                      rightView:(UIViewController *)righView
                backgroundImage:(UIImage *)image{
    
    if(self){
        
        self.boundarySpeed = 0.5;
        self.showStatusBar = YES;
        self.slideLipeType = BoundaryViewTypeMain;
        self.enableScale = YES;
        self.slideWidth = 150;
        
        leftControl = leftView;
        mainControl = mainView;
        righControl = righView;
        
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imgview setBackgroundColor:[UIColor blackColor]];
        [imgview setImage:image];
        [self.view addSubview:imgview];
        
        //滑动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [mainControl.view addGestureRecognizer:pan];
        
        //单击手势
        self.sideslipTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        [self setEnableBoundaryTap:YES];
        
        [mainControl.view addGestureRecognizer:self.sideslipTapGes];
        
        if (leftControl) {
            leftControl.view.hidden = YES;
            [self.view addSubview:leftControl.view];
        }
        
        if (righControl) {
            righControl.view.hidden = YES;
            [self.view addSubview:righControl.view];
        }
        
        if (mainControl) {
            [self.view addSubview:mainControl.view];
        }
    }
    return self;
}

//恢复位置
-(void)showMainView{
    
    if (mainControl) {
        
        self.slideLipeType = BoundaryViewTypeMain;

        [UIView animateWithDuration:AnimationTime animations:^{
            if (self.enableScale) {
                mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
            }
            mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BoundarySlipControllerDidShowMainNotification object:nil];
        }];
    }
}

//显示左视图
-(void)showLeftView{
    
    if (leftControl) {
        
        self.slideLipeType = BoundaryViewTypeLeft;

        [UIView animateWithDuration:AnimationTime animations:^{
            if (self.enableScale) {
                mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
            }
            mainControl.view.center = CGPointMake(([UIScreen mainScreen].bounds.size.width-self.slideWidth)/2.0+[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BoundarySlipControllerDidShowLeftNotification object:nil];
        }];
    }
}

//显示右视图
-(void)showRighView{
    
    if (righControl) {
        
        self.slideLipeType = BoundaryViewTypeRight;

        [UIView animateWithDuration:AnimationTime animations:^{
            if (self.enableScale) {
                mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
            }
            mainControl.view.center = CGPointMake((self.slideWidth-[UIScreen mainScreen].bounds.size.width)/2.0, [UIScreen mainScreen].bounds.size.height/2);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BoundarySlipControllerDidShowRightNotification object:nil];
        }];
    }
}


#pragma mark - Events
//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)rec{
    
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (scalef>140*self.boundarySpeed){
            [self showLeftView];
        }
        else if (scalef<-140*self.boundarySpeed) {
            [self showRighView];
        }
        else {
            [self showMainView];
            scalef = 0;
        }
    }else if (rec.state==UIGestureRecognizerStateChanged){
    
        CGPoint point = [rec translationInView:self.view];
        scalef = (point.x*self.boundarySpeed+scalef);
        
        //根据视图位置判断是左滑还是右边滑动
        if (rec.view.frame.origin.x==0) {
            
            rec.view.center = CGPointMake(rec.view.center.x + point.x*self.boundarySpeed*0.00001, rec.view.center.y);
            
        }else if (rec.view.frame.origin.x>0){
        
            if (leftControl) {
                
                rec.view.center = CGPointMake(rec.view.center.x + point.x*self.boundarySpeed, rec.view.center.y);
                if (self.enableScale) {
                    rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
                }
                [rec setTranslation:CGPointMake(0, 0) inView:self.view];

                leftControl.view.hidden = NO;
            }else{
                rec.view.center = self.view.center;
                scalef = 0;
            }
            
            if (righControl) {
                righControl.view.hidden = YES;
            }
        }
        else if(rec.view.frame.origin.x<0){
            
            if (righControl) {
                
                rec.view.center = CGPointMake(rec.view.center.x + point.x*self.boundarySpeed, rec.view.center.y);
                if (self.enableScale) {
                    rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1+scalef/1000,1+scalef/1000);
                }
                [rec setTranslation:CGPointMake(0, 0) inView:self.view];

                righControl.view.hidden = NO;
            }else{
                rec.view.center = self.view.center;
                scalef = 0;
            }
            
            if (leftControl) {
                leftControl.view.hidden = YES;
            }
        }
    }
}

//单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self showMainView];
        scalef = 0;
    }
}



#pragma mark - Notifications


#pragma mark - System Delegate Methods


#pragma mark - Custom Delegate Methods


#pragma mark - Private Methods


#pragma mark - Setter and Getter
- (void)setEnableBoundaryTap:(BOOL)enableBoundaryTap{
    _enableBoundaryTap = enableBoundaryTap;
    self.sideslipTapGes.enabled = enableBoundaryTap;
}

- (BoundaryViewType)viewType{
    return self.slideLipeType;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end









