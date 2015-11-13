//
//  LCLVideoViewController.m
//  Messenger
//
//  Created by duanran on 15/11/12.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "LCLVideoViewController.h"
#import "KrVideoPlayerController.h"

@interface LCLVideoViewController ()
@property (nonatomic, strong) KrVideoPlayerController  *videoController;


@end

@implementation LCLVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playVideo];

    
    // Do any additional setup after loading the view from its nib.
}
- (void)playVideo{
    [self addVideoPlayerWithURL:[NSURL URLWithString:self.videoUrl]];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
//            weakSelf.videoController = nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
