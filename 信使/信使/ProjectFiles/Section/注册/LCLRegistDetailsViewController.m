//
//  LCLRegistDetailsViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLRegistDetailsViewController.h"

#import "LCLSelectCityViewController.h"

#import "BaiduPushBindRequest.h"
@interface LCLRegistDetailsViewController () <LCLSelectCityViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordsTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSString *headURL;

@end

@implementation LCLRegistDetailsViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.phoneNumber = nil;
    
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    
    if (self.provinceArray) {
        self.provinceArray = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    [self.navigationItem setTitle:@"注册"];

    self.headURL = @"";
    
    [self getServerCityList];
    
    CGRect frame = self.headButton.frame;
    frame.origin.x = (kDeviceWidth-frame.size.width)/2.0;
    [self.headButton setFrame:frame];
    [self.headButton setRoundedRadius:4.0];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
    [tapgesture setNumberOfTapsRequired:1];
    [self.scrollView addGestureRecognizer:tapgesture];
    
    [self.scrollView setContentSize:CGSizeMake(320, kDeviceHeight+10)];
    
    [self.registButton setRoundedRadius:4.0];
    [self.registButton setBackgroundColor:APPPurpleColor];
    
    [self.sexButton setBackgroundColor:[UIColor clearColor]];
    [self.cityButton setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapScrollView{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)didBeginEditing:(UITextField *)textField{

    CGRect frame = textField.frame;
    frame.size.height = frame.size.height*2+10;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)tapHeadButton:(id)sender{
    
    @weakify(self);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"照片", nil];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        
        int tag = [index intValue];
        if (tag==0) {
            
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self_weak_ lclPhototype:LCLPhotoTypeSystemCamera finishBlock:^(UIImage *image, NSData *imageData) {
                
                [self_weak_.headButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [self_weak_ uploadHeadImage:imageData];
                
            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
            }];
            
        }else if (tag==1){
            
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self_weak_ lclPhototype:LCLPhotoTypeSystemLibrary finishBlock:^(UIImage *image, NSData *imageData) {
                
                [self_weak_.headButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [self_weak_ uploadHeadImage:imageData];

            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
            }];
        }
    }];
    [actionSheet showInView:self.view];
}

- (IBAction)tapSexButton:(id)sender{

    @weakify(self);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        
        int tag = [index intValue];
        if (tag==0) {
            [self_weak_.sexButton setTitle:@"男" forState:UIControlStateNormal];
        }else if (tag==1){
            [self_weak_.sexButton setTitle:@"女" forState:UIControlStateNormal];
        }
    }];
    [actionSheet showInView:self.view];
}

- (IBAction)tapCityButton:(id)sender{

//    LCLSelectCityViewController *selectCity = [[LCLSelectCityViewController alloc] initWithNibName:@"LCLSelectCityViewController" bundle:nil];
//    [selectCity setLclMenuDataSourceArray:self.provinceArray];
//    selectCity.selectCityDelegate = self;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectCity];
//    [self presentViewController:nav animated:YES completion:nil];
    
    @weakify(self);
    
    [LCLAddressPickerView showWithMiniCompleteBlock:^(id object) {
        
//        [self.cityButton setTitle:[cityDic objectForKey:@"areaname"] forState:UIControlStateNormal];
//        self.cityID = [cityDic objectForKey:@"no"];

    } maxCompleteBlock:^(NSDictionary *cityDic) {
        
        [self_weak_.cityButton setTitle:[cityDic objectForKey:@"areaname"] forState:UIControlStateNormal];
        self_weak_.cityID = [cityDic objectForKey:@"no"];

    } provinceArray:self_weak_.provinceArray];
    
}

- (IBAction)tapRegistButton:(id)sender{

    if (!self.nicknameTextField.text || self.nicknameTextField.text.length==0) {
        
        [LCLTipsView showTips:@"昵称不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (!self.passwordTextField.text || self.passwordTextField.text.length==0) {
        
        [LCLTipsView showTips:@"密码不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (!self.passwordsTextField.text || self.passwordsTextField.text.length==0) {
        
        [LCLTipsView showTips:@"确认密码不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.passwordsTextField.text]) {
        
        [LCLTipsView showTips:@"密码不一致" location:LCLTipsLocationMiddle];
        
        return;
    }

    if (!self.cityButton.titleLabel.text || self.cityButton.titleLabel.text.length==0) {
        
        [LCLTipsView showTips:@"城市不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }

    if (!self.ageTextField.text || self.ageTextField.text.length==0) {
        
        [LCLTipsView showTips:@"年龄不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }

    if (!self.heightTextField.text || self.heightTextField.text.length==0) {
        
        [LCLTipsView showTips:@"身高不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (!self.weightTextField.text || self.weightTextField.text.length==0) {
        
        [LCLTipsView showTips:@"体重不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    [LCLWaitView showIndicatorView:YES];

    NSNumber *sex = [NSNumber numberWithInt:1];
    if ([self.sexButton.titleLabel.text isEqualToString:@"女"]) {
        sex = [NSNumber numberWithInt:0];
    }
    
    @weakify(self);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneNumber forKey:@"username"];
    [dic setObject:self.passwordsTextField.text forKey:@"password"];
    [dic setObject:self.nicknameTextField.text forKey:@"nickname"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:self.ageTextField.text forKey:@"age"];
    [dic setObject:self.heightTextField.text forKey:@"height"];
    [dic setObject:self.weightTextField.text forKey:@"weight"];
    [dic setObject:self.cityID forKey:@"city"];
    [dic setObject:self.headURL forKey:@"headimg"];
    
    NSString *registString = [[NSString alloc] initWithFormat:@"username=%@&password=%@&nickname=%@&sex=%@&age=%@&height=%@&weight=%@&city=%@&headimg=%@", self.phoneNumber, self.passwordTextField.text, self.nicknameTextField.text, sex, self.ageTextField.text, self.heightTextField.text, self.weightTextField.text, self.cityID, self.headURL];
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:RegistURL];
    [login setHttpMehtod:LCLHttpMethodPost];
    [login setEncryptType:LCLEncryptTypeNone];
    [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            [self login:dic];
//            NSString *ukey = [dataDic objectForKey:@"ukey"];
//            NSString *pwd = [dataDic objectForKey:@"pwd"];
//            if (ukey && pwd) {
//                
//                NSString *jid = [dataDic objectForKey:@"jid"];
//                if (!jid || [jid isKindOfClass:[NSNull class]]) {
//                    jid = @"";
//                }
//                [dic setObject:ukey forKey:@"ukey"];
//                [dic setObject:pwd forKey:@"pwd"];
//                [dic setObject:jid forKey:@"jid"];
//                
//                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
//
//                [LCLAppLoader loginAction];
//            }
        }
        
        [LCLWaitView showIndicatorView:NO];

    }];
    [login startToDownloadWithIntelligence:NO];
}
-(void)login:(NSDictionary *)infoDic
{
    NSString *userName=[infoDic objectForKey:@"username"];
    NSString *password=[infoDic objectForKey:@"password"];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
   
    
    NSString *loginString = [[NSString alloc] initWithFormat:@"username=%@&password=%@", userName, password];
    NSString *token = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:DeviceTokenKey];
    if (token) {
        if (token.length>0) {
            
            token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            loginString = [[NSString alloc] initWithFormat:@"%@&token=%@&channel_id=%@&type=%@", loginString, token, userName, @"2"];
        }
    }
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    
    NSString *channel_id=GetPushChanel_id();
    NSString *body=[NSString stringWithFormat:@"%@&token=%@&type=2",loginString,channel_id];
    
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:LoginURL];
    [login setHttpMehtod:LCLHttpMethodPost];
    [login setHttpBodyData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            
            NSString *ukey = [dataDic objectForKey:@"ukey"];
            if (ukey) {
                
                if (channel_id) {
                    BaiduPushBindRequest *request=[[BaiduPushBindRequest alloc]init];
                    request.uKey=ukey;
                    request.token=channel_id;
                    
                    [request GETRequest:^(id reponseObject) {
                        NSLog(@"reponseObject=%@",reponseObject);
                        
                    } failureCallback:^(NSString *errorMessage) {
                        NSLog(@"error=%@",errorMessage);
                        
                    }];
                }
                
                
                NSString *uid=[dataDic objectForKey:@"uid"];

                
                LCLUserInfoObject *userObj = [LCLUserInfoObject allocModel];
                userObj.ukey = ukey;
                userObj.password = password;
                userObj.pwd = password;
                userObj.nickname = userName;
                userObj.email = @"";
                userObj.headimg = @"";
                userObj.mobile = userName;
                userObj.sex = @"1";
                userObj.qq = @"";
                userObj.province_name = @"";
                userObj.city_name = @"";
                userObj.area_name = @"";
                userObj.uid = uid;
                userObj.ID = @"";
                userObj.last_login = @"";
                userObj.freezing_coin = [dataDic objectForKey:@"freezing_coin"];
                userObj.sxf = [dataDic objectForKey:@"sxf"];
                userObj.shop_onoff=[dataDic objectForKey:@"shop_onoff"];
                
                
                NSDictionary *dic = [userObj getAllPropertyAndValue];
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
                
                [LCLAppLoader loginAction];
                
                [self_weak_ dismissViewControllerAnimated:YES completion:nil];
                
                
                
            }
        }
        
        [LCLWaitView showIndicatorView:NO];
    }];
    [login startToDownloadWithIntelligence:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    [self endKeyboardEditting];
}

#pragma mark - 获取城市列表
- (void)getServerCityList{
    
    __weak typeof(self) weakself = self;
    
    [LCLWaitView showIndicatorView:YES];
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:GetCityURL];
    [login setHttpMehtod:LCLHttpMethodGet];
    [login setEncryptType:LCLEncryptTypeNone];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [weakself.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            
            weakself.provinceArray = [[NSMutableArray alloc] initWithArray:[dataDic objectForKey:@"list"]];
            if (weakself.provinceArray.count>0) {
                
                for (int i=0; i<weakself.provinceArray.count; i++) {
                    
                    NSMutableDictionary *provinceDic = [[NSMutableDictionary alloc] initWithDictionary:[weakself.provinceArray objectAtIndex:i]];
                    NSString *num = [provinceDic objectForKey:@"no"];
                    if (!num) {
                        num = @"";
                    }
                    
                    LCLDownloader *download = [[LCLDownloader alloc] initWithURLString:[NSString stringWithFormat:@"%@no=%@", GetCityURL, num]];
                    [download setHttpMehtod:LCLHttpMethodGet];
                    [download setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
                        
                        NSDictionary *dataDic = [weakself.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                        if (dataDic) {
                            NSArray *list = [dataDic objectForKey:@"list"];
                            if (list) {
                                [provinceDic setObject:list forKey:@"list"];
                            }else{
                                [provinceDic setObject:[[NSArray alloc]init] forKey:@"list"];
                            }
                        }else{
                            [provinceDic setObject:[[NSArray alloc]init] forKey:@"list"];
                        }
                        
                        [weakself.provinceArray replaceObjectAtIndex:i withObject:provinceDic];
                        
                        if ([[LCLNetworkManager sharedLCLARCNetManager] operationQueue].operationCount==1) {
                            [LCLWaitView showIndicatorView:NO];
                        }
                    }];
                    [download startToDownloadWithIntelligence:NO];
                }
            }else{
                [LCLWaitView showIndicatorView:NO];
            }
        }else{
            [LCLWaitView showIndicatorView:NO];
        }
    }];
    [login startToDownloadWithIntelligence:NO];
}

- (void)uploadImageWithImageData:(NSData *)data{

    [LCLWaitView showIndicatorView:YES];

    NSString *fileName = [[LCLTimeHelper getCurrentTimeString] stringByAppendingString:@".jpg"];
    NSString *filePath = [[LCLFilePathHelper getLCLCacheFolderPath] stringByAppendingString:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
    
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:GetUploadFileURL];
        [login setHttpMehtod:LCLHttpMethodGet];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            NSDictionary *dataDic = [self.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataDic) {
                
                NSString *url = [dataDic objectForKey:@"url"];
                if (url) {
                    
                    LCLUploader *uploader = [[LCLUploader alloc] initWithURLString:[NSString stringWithFormat:@"%@/index.php/Api/User/album/ukey/image", url] fileName:fileName filePath:filePath];
                    [uploader setFormName:@"image"];
                    [uploader setCompleteBlock:^(NSString *errorString, NSMutableData *responseData, NSString *urlString) {
                        
                        NSDictionary *imageDic = [self.view getResponseDataDictFromResponseData:responseData withSuccessString:nil error:@""];
                        if (imageDic) {
                            
                            NSString *url = [imageDic objectForKey:@"url"];
                            [[LCLCacheDefaults standardCacheDefaults] setCacheFileWithData:data forKey:url];
                        }
                        [LCLWaitView showIndicatorView:NO];
                    }];
                    [uploader startToUpload];
                }else{
                    [LCLWaitView showIndicatorView:NO];
                }
            }else{
                [LCLWaitView showIndicatorView:NO];
            }
        }];
        [login startToDownloadWithIntelligence:NO];
    }
}

- (void)uploadHeadImage:(NSData *)data{

    [LCLWaitView showIndicatorView:YES];
    
    NSString *fileName = [[LCLTimeHelper getCurrentTimeString] stringByAppendingString:@".jpg"];
    NSString *filePath = [[LCLFilePathHelper getLCLCacheFolderPath] stringByAppendingString:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        
        LCLUploader *uploader = [[LCLUploader alloc] initWithURLString:UploadHeadImageURL fileName:fileName filePath:filePath];
        [uploader setFormName:@"image"];
        [uploader setCompleteBlock:^(NSString *errorString, NSMutableData *responseData, NSString *urlString) {
            
            NSDictionary *imageDic = [self.view getResponseDataDictFromResponseData:responseData withSuccessString:nil error:@""];
            if (imageDic) {
                
                NSString *url = [imageDic objectForKey:@"path"];
                if (url) {
                    url = [XSURL stringByAppendingString:url];
                }
                [[LCLCacheDefaults standardCacheDefaults] setCacheFileWithData:data forKey:url];
            }
            [LCLWaitView showIndicatorView:NO];
        }];
        [uploader startToUpload];

    }
}

#pragma mark - LCLSelectCityViewDelegate
- (void)didSelectCity:(NSDictionary *)cityDic{

    [self.cityButton setTitle:[cityDic objectForKey:@"areaname"] forState:UIControlStateNormal];
    self.cityID = [cityDic objectForKey:@"no"];
}

#pragma mark - keyboard events
- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
   
    CGRect frame = self.scrollView.frame;
    frame.size.height = kDeviceHeight-keyboardRect.size.height-64;
    [self.scrollView setFrame:frame];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGRect frame = self.scrollView.frame;
    frame.size.height = kDeviceHeight-64;
    [self.scrollView setFrame:frame];
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






