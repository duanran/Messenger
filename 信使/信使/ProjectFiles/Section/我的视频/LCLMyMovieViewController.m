//
//  LCLMyMovieViewController.m
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyMovieViewController.h"

#import "LCLSelectPicView.h"
#import "LCLAddPicButton.h"
#import "LCLMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SaveVideoRequest.h"
@interface LCLMyMovieViewController ()<LCLSelectPicViewDelegate>
{
    BOOL isUpload;
}
@property (weak, nonatomic) IBOutlet LCLAddPicButton *publicButton;
@property (strong, nonatomic) MPMoviePlayerViewController *movie;

@end

@implementation LCLMyMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    isUpload=false;
    [self.navigationItem setTitle:@"视频认证"];
    
    [self.publicView setBackgroundColor:[UIColor clearColor]];

    [self getMyPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapAddPhoto:(UIButton *)sender{
    
    @weakify(self);
    
    [LCLARCPicManager showLCLPhotoControllerOnViewController:self lclPhototype:LCLPhotoTypeSystemMovie finishBlock:^(UIImage *image, NSData *imageData) {
        
    } cancleBlock:^{
        
    } beginBlock:^{
        
    } movieFinish:^(NSString *moviePath) {
        
        [self_weak_ uploadMovieWithPath:moviePath];
        
    }];
}


- (void)getMyPhotos{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@?num=50", MyMovieURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                NSArray *array = [dataSourceDic objectForKey:@"list"];
                
                LCLSelectPicView *publicScrollView = [[LCLSelectPicView alloc] initWithFrame:self.publicView.bounds];
                publicScrollView.movieDelegate = self;
                [publicScrollView setupWithMovieArray:array];
                [self_weak_.publicView addSubview:publicScrollView];
                
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

- (void)didTapMoviePath:(NSString *)path{
    
    LCLMoviePlayerViewController *movie = [[LCLMoviePlayerViewController alloc] init];
    [movie setMoviePath:path];
    [self presentViewController:movie animated:YES completion:^{
        
    }];
 
//    //视频URL
//    path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    url = [NSURL URLWithString:path];
//    //视频播放对象
//    self.movie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    [self.movie.moviePlayer prepareToPlay];
//    [self.movie.view setBackgroundColor:[UIColor clearColor]];
//    [self.movie.view setFrame:self.view.bounds];
//    [self presentViewController:self.movie animated:YES completion:^{
//        
//    }];
}

- (void)uploadMovieWithPath:(NSString *)moviePath{

    NSString *fileName = @"capturedvideo.mov";
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
//    moviePath = path;
//    fileName = @"test.mp4";
    
    @weakify(self);

    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    
    [LCLGetToken checkGetUploadInfoWithCompleteBlock:^(NSDictionary *dataDic) {
        
        if (dataDic.count>0) {
            
            [LCLTipsView showTips:@"正在上传，请稍后！" location:LCLTipsLocationMiddle];
            
            NSString *success=[dataDic objectForKey:@"success"];
            if ([success integerValue]==1) {
                isUpload=true;
            }
            
            NSString *serverUrl = [dataDic objectForKey:@"url"];
            
            LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
            NSString *url = UploadMovieURL(serverUrl, userObj.ukey);
            
            LCLUploader *uploader = [[LCLUploader alloc] initWithURLString:url fileName:fileName filePath:moviePath];
            [uploader setTimeout:@"120"];
            [uploader setFormName:@"file"];
            [uploader setHttpMehtod:LCLHttpMethodPost];
            [uploader setFirstResponseBlock:^(NSURLResponse *response, NSString *urlString){
                
            }];
            [uploader setProgressBlock:^(NSInteger sendLength, NSInteger totalLength, NSInteger totalExpectedLength, NSString *urlString){
                CGFloat percent = (totalLength/(float)totalExpectedLength)*100;
                [self_weak_.navigationItem setTitle:[NSString stringWithFormat:@"已上传%.0f%%", percent]];
            }];
            [uploader setCompleteBlock:^(NSString *errorString, NSMutableData *responseData, NSString *urlString){
                
                [self_weak_.navigationItem setTitle:@"视频认证"];
                
                [LCLWaitView showIndicatorView:NO];
                
                NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:responseData withSuccessString:@"上传成功,正在上传视频截图" error:@""];
                if (dataDic) {
                    if (isUpload==true) {
                        NSString *success=[dataDic objectForKey:@"success"];
                        if ([success integerValue]==1) {
                            SaveVideoRequest *request=[[SaveVideoRequest alloc]init];
                            request.ukey=userObj.ukey;
                            request.path=moviePath;
                            NSString *urlPath=[dataDic objectForKey:@"path"];
//                          NSString *Path = [XSURL stringByAppendingString:urlPath];
                            request.path=urlPath;
                            request.firstUrl=serverUrl;
                            request.picPath=[dataDic objectForKey:@"pic"];
                            [request GETRequest:^(id reponseObject) {
                                NSLog(@"reponseObject=%@",reponseObject);

                            } failureCallback:^(NSString *errorMessage) {
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"视频上传失败" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                
                                [alert show];
                            }];
                            
                        }
                    }
                    
                    
                }
            }];
            [uploader startToUpload];
            
        }else{
            
            [LCLWaitView showIndicatorView:NO];
        }
    }];

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
