//
//  LCLMoviePlayerViewController.m
//  信使
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMoviePlayerViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface LCLMoviePlayerViewController ()

@property (strong, nonatomic) MPMoviePlayerController *movie;

@end

@implementation LCLMoviePlayerViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //视频URL
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    if (self.moviePath) {
        url = [NSURL URLWithString:self.moviePath];
    }
    //视频播放对象
    self.movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.movie.controlStyle = MPMovieControlStyleFullscreen;
    [self.movie.view setFrame:self.view.bounds];
    [self.view addSubview:self.movie.view];
    [self.movie prepareToPlay];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.movie];

}

-(void)myMovieFinishedCallback:(NSNotification*)notify{
    
    NSDictionary *userInfo = [notify userInfo];
    if ([[userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue]==2) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
