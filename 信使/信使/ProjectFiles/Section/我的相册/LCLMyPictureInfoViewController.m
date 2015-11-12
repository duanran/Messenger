//
//  LCLMyPictureInfoViewController.m
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyPictureInfoViewController.h"

#import "LCLSelectPicView.h"
#import "LCLPictureTableViewCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface LCLMyPictureInfoViewController () <LCLHomeTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *publicArray;
@property (strong, nonatomic) NSMutableArray *privateArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isPublicPhotos;

@end

@implementation LCLMyPictureInfoViewController

- (void)dealloc{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"我的相册"];
    
    self.publicArray = [[NSMutableArray alloc] init];
    self.privateArray = [[NSMutableArray alloc] init];

    [self.segmentControl addTarget:self action:@selector(tabSegmentControl:) forControlEvents:UIControlEventValueChanged];

    self.isPublicPhotos = YES;
    
    @weakify(self);
    
    [self_weak_.tableView addHeaderWithCallback:^{
        
        [self_weak_ getMyPhotos];
    }];
    
    [self_weak_.tableView headerBeginRefreshing];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabSegmentControl:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex==0) {
        self.isPublicPhotos = YES;
        
        if (self.publicArray.count>0) {
            
            [self.tableView hideEmptyDataTips];
            
            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];
            
            [self getMyPhotos];
        }
    }else{
        self.isPublicPhotos = NO;
        
        if (self.privateArray.count>0) {
            
            [self.tableView hideEmptyDataTips];
            
            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];
            
            [self getMyPhotos];
        }
    }
}

- (IBAction)tapAddPhoto:(UIButton *)sender{

    @weakify(self);
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *number) {
        if ([number intValue]==0) {
           
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self lclPhototype:LCLPhotoTypeSystemLibrary finishBlock:^(UIImage *image, NSData *imageData) {
                
                if (self_weak_.isPublicPhotos) {
                    
                    [self_weak_ uploadImageWithImageData:imageData type:@"1"];
                }else{
                    
                    [self_weak_ uploadImageWithImageData:imageData type:@"2"];
                }
                
            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
            }];
            
        }else if ([number intValue]==1){
        
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self lclPhototype:LCLPhotoTypeSystemCamera finishBlock:^(UIImage *image, NSData *imageData) {
                
                if (self_weak_.isPublicPhotos) {
                    
                    [self_weak_ uploadImageWithImageData:imageData type:@"1"];
                }else{
                    
                    [self_weak_ uploadImageWithImageData:imageData type:@"2"];
                }
                
            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
            }];
        }
    }];
    [sheet showInView:self.view];
}

- (void)getMyPhotos{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@?num=50", MyPhotosURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                NSArray *array = [dataSourceDic objectForKey:@"list"];
                
                self_weak_.publicArray = [[NSMutableArray alloc] init];
                self_weak_.privateArray = [[NSMutableArray alloc] init];

                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
                    if ([photoObj.type intValue]==1) {
                        [self_weak_.publicArray addObject:dic];
                    }else{
                        [self_weak_.privateArray addObject:dic];
                    }
                }
                
            }
            
            [self_weak_.tableView reloadData];
            [self_weak_.tableView headerEndRefreshing];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

- (void)uploadImageWithImageData:(NSData *)imageData type:(NSString *)type{

    [LCLWaitView showIndicatorView:YES];
    
    [LCLTipsView showTips:@"正在上传图片" location:LCLTipsLocationMiddle];

    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    [LCLGetToken checkGetUploadInfoWithCompleteBlock:^(NSDictionary *dataDic) {
        
        if (dataDic.count>0) {
           
            NSString *fileName = [[LCLTimeHelper getCurrentTimeString] stringByAppendingString:@".jpg"];
            NSString *filePath = [[LCLFilePathHelper getLCLCacheFolderPath] stringByAppendingString:fileName];
            if ([imageData writeToFile:filePath atomically:YES]) {
                
                NSString *serverUrl = [dataDic objectForKey:@"url"];
                
                LCLUploader *uploader = [[LCLUploader alloc] initWithURLString:UploadPictureURL(serverUrl, userObj.ukey) fileName:fileName filePath:filePath];
                [uploader setFormName:@"image"];
                [uploader setCompleteBlock:^(NSString *errorString, NSMutableData *responseData, NSString *urlString) {
                    
                    NSDictionary *imageDic = [self_weak_.view getResponseDataDictFromResponseData:responseData withSuccessString:nil error:@""];
                    if (imageDic) {
                        
                        NSString *listURL = [NSString stringWithFormat:@"%@", SavePictureURL(userObj.ukey)];
                        
                        NSString *loginString = [[NSString alloc] initWithFormat:@"path=%@&firsturl=%@&type=%@", [imageDic objectForKey:@"path"], serverUrl, type];
                        
                        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:listURL];
                        [login setHttpMehtod:LCLHttpMethodPost];
                        [login setHttpBodyData:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
                        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
                            
                            [LCLWaitView showIndicatorView:NO];

                            NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                            if (dataDic) {
                                
                                [LCLTipsView showTips:@"上传图片成功" location:LCLTipsLocationMiddle];

                                [self_weak_ getMyPhotos];
                                
                            }
                        }];
                        [login startToDownloadWithIntelligence:NO];
                        
                    }else{
                        [LCLWaitView showIndicatorView:NO];
                    }
                }];
                [uploader startToUpload];
                
            }else{
                [LCLWaitView showIndicatorView:NO];
            }
        }else{
        
            [LCLWaitView showIndicatorView:NO];
        }
    }];
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (kDeviceWidth/3.0)*HomeCellScale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.privateArray;
    if (self.isPublicPhotos) {
        array = self.publicArray;
    }
    
    NSInteger count = array.count+1;
    
    NSInteger n = count/3;
    NSInteger m = count%3;
    
    if (m==0) {
        return n;
    }else{
        return n+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"homecell";
    
    LCLPictureTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [LCLPictureTableViewCell loadXibView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.homeCellDelegate = self;
    
    NSArray *array = self.privateArray;
    if (self.isPublicPhotos) {
        array = self.publicArray;
    }
    
    NSInteger count = array.count+1;

    NSInteger n = count/3;
    NSInteger m = count%3;

    NSInteger r = n;
    if (m==0) {
    }else{
        r = n+1;
    }

    
    for (int i=0; i<3; i++) {
        NSInteger row = indexPath.row*3+i;
        NSDictionary *dic = nil;
        if (array.count>row) {
            dic = [array objectAtIndex:row];
        }else{
            row = -1;
        }
        
        [cell setCategoryDic:dic buttonTag:row i:i];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)didSelectHomeTableViewCellCategoryWithTag:(NSInteger)categoryTag button:(UIButton *)button{
    
    if (categoryTag==-1) {
        
        [self tapAddPhoto:nil];
        
    }else{
    
        NSArray *picArray = self.privateArray;
        if (self.isPublicPhotos) {
            picArray = self.publicArray;
        }

        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:picArray.count];
        for (int i = 0; i<picArray.count; i++) {
            // 替换为中等尺寸图片
            
            NSDictionary *dic = [picArray objectAtIndex:i];
            LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:photoObj.path]; // 图片路径
            photo.srcImageView = button.imageView; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        NSInteger t = categoryTag;
        if (categoryTag>=photos.count) {
            t = photos.count-1;
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = t; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];

    }
}

- (void)longpressSelectHomeTableViewCellCategoryWithTag:(NSInteger)categoryTag button:(UIButton *)button{

    if (categoryTag==-1) {
        return;
    }

    @weakify(self);
    
    NSArray *picArray = self.privateArray;
    if (self.isPublicPhotos) {
        picArray = self.publicArray;
    }
    NSDictionary *dic = [picArray objectAtIndex:categoryTag];
    LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定删除此照片？"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        if ([index integerValue]==1) {
            
            [self_weak_ deletePic:photoObj.iD];
        }
    }];
    [alertView show];
}

- (void)deletePic:(NSString *)pid{

    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];

    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", DeletePicturURL(userObj.ukey, pid)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                [self_weak_ getMyPhotos];
            }
            
            [self_weak_.tableView reloadData];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }

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










