//
//  LCLRegistPhoneViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLRegistPhoneViewController.h"

#import "LCLRegistDetailsViewController.h"
#import "LCLWebViewController.h"

#import "SectionsViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
@interface LCLRegistPhoneViewController ()<SecondViewControllerDelegate>{

    NSMutableArray* _areaArray;
    NSString* _defaultCode;
    NSString* _defaultCountryName;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneVerifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *regetVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSTimer *countTimer;

@end

@implementation LCLRegistPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"获取验证码"];
    
    [self.nextButton setRoundedRadius:4.0];
    [self.nextButton setBackgroundColor:APPPurpleColor];

    _areaArray= [NSMutableArray array];
    //设置本地区号
    [self setTheLocalAreaCode];
    //获取支持的地区列表
    [SMSSDK getZone:^(enum SMSResponseState state, NSArray *zonesArray) {
        //区号数据
        _areaArray = [NSMutableArray arrayWithArray:zonesArray];
    }];
    
//    [SMSSDK getZone:^(enum SMS_ResponseState state, NSArray *array){
//         if (1==state){
//             //区号数据
//             _areaArray = [NSMutableArray arrayWithArray:array];
//         }
//     }];
}

//设置本地区号
-(void)setTheLocalAreaCode{
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString *tt = [locale objectForKey:NSLocaleCountryCode];
    NSString *defaultCode = [dictCodes objectForKey:tt];
    NSString *defaultCountryName = [locale displayNameForKey:NSLocaleCountryCode value:tt];

//    defaultCode = @"86";
    
    self.countryCodeLabel.text = [NSString stringWithFormat:@"+%@",defaultCode];
    [self.countryButton setTitle:defaultCountryName forState:UIControlStateNormal];
    
    _defaultCode = defaultCode;
    _defaultCountryName = defaultCountryName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)tapTiaokuanButton:(id)sender{

    LCLWebViewController *web = [[LCLWebViewController alloc] init];
    [web setHidesBottomBarWhenPushed:YES];
    [web setItemName:@"服务条款"];
    [web setUrl:YinSiTiaoKuanURL];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)changeTime{
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%li秒后可重发", (long)self.seconds]];
    
    if (self.seconds==0) {
        [self.countTimer invalidate];
        self.seconds = 60;
        [self.timeLabel setText:@""];

        [self.regetVerifyCodeButton setHidden:NO];
        [self.regetVerifyCodeButton setTitle:@"重新发送" forState: UIControlStateNormal];
        [self.regetVerifyCodeButton setEnabled:YES];
    }
    
    self.seconds--;
}

- (IBAction)tapCountryButton:(id)sender{

    SectionsViewController *country2 = [[SectionsViewController alloc] init];
    country2.delegate = self;
    [country2 setAreaArray:_areaArray];
    [self presentViewController:country2 animated:YES completion:^{
        ;
    }];
}

- (IBAction)tapResendMessageButton:(id)sender{

    int compareResult = 0;
    for (int i=0; i<_areaArray.count; i++){
        
        NSDictionary* dict1=[_areaArray objectAtIndex:i];
        NSString* code1=[dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]){
            
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:self.phoneTextField.text];
            if (!isMatch){
                
                [LCLTipsView showTips:NSLocalizedString(@"errorphonenumber", nil) location:LCLTipsLocationMiddle];
                
                return;
            }
            break;
        }
    }
    
    if (!compareResult){
        
        if (self.phoneTextField.text.length!=11){
            //手机号码不正确
            
            [LCLTipsView showTips:NSLocalizedString(@"errorphonenumber", nil) location:LCLTipsLocationMiddle];
            
            return;
        }
    }
    
//    NSString* str=[NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"willsendthecodeto", nil),self.countryCodeLabel.text,self.phoneTextField.text];
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"surephonenumber", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
//    [alert show];
    
    self.seconds = 59;
    [self.regetVerifyCodeButton setEnabled:NO];
    [self.regetVerifyCodeButton setHidden:YES];
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [self.countTimer fire];
    
    NSString* str2=[self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    [SMSSDK getVerificationCodeBySMSWithPhone:self.phoneTextField.text zone:str2 result:^(NSError *error) {
//        if (error){
//            [LCLTipsView showTips:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription] location:LCLTipsLocationMiddle];
//        }
    }];
}

- (IBAction)tapNextButton:(id)sender{
    
    @weakify(self);
    
    if (TestContact) {
        LCLRegistDetailsViewController *details = [[LCLRegistDetailsViewController alloc] initWithNibName:@"LCLRegistDetailsViewController" bundle:nil];
        [details setPhoneNumber:self.phoneTextField.text];
        [self.navigationController pushViewController:details animated:YES];
    }
    else{
        if (self.phoneTextField.text.length!=11) {
            [LCLTipsView showTips:@"请输入正确手机号码" location:LCLTipsLocationMiddle];
            return;
        }
        
        if(self.phoneVerifyTextField.text.length!=4){
            [LCLTipsView showTips:NSLocalizedString(@"verifycodeformaterror", nil) location:LCLTipsLocationMiddle];
        }
        else{
            
//            SMSSDK commitVerificationCode:self.phoneVerifyTextField.text phoneNumber:self.phoneTextField.text zone:nil result:^(NSError *error) {
//                
//            }
            
            [SMSSDK commitVerifyCode:self.phoneVerifyTextField.text result:^(enum SMSResponseState state) {
                if (1==state){
                    LCLRegistDetailsViewController *details = [[LCLRegistDetailsViewController alloc] initWithNibName:@"LCLRegistDetailsViewController" bundle:nil];
                    [details setPhoneNumber:self_weak_.phoneTextField.text];
                    [self_weak_.navigationController pushViewController:details animated:YES];
                }
                else if(0==state){
                    NSString* str=[NSString stringWithFormat:NSLocalizedString(@"verifycodeerrormsg", nil)];
                    [LCLTipsView showTips:str location:LCLTipsLocationMiddle];
                }
            }];
            
//            [SMSSDK commitVerifyCode:self.phoneVerifyTextField.text result:^(enum SMS_ResponseState state) {
//                if (1==state){
//                    LCLRegistDetailsViewController *details = [[LCLRegistDetailsViewController alloc] initWithNibName:@"LCLRegistDetailsViewController" bundle:nil];
//                    [details setPhoneNumber:self_weak_.phoneTextField.text];
//                    [self_weak_.navigationController pushViewController:details animated:YES];
//                }
//                else if(0==state){
//                    NSString* str=[NSString stringWithFormat:NSLocalizedString(@"verifycodeerrormsg", nil)];
//                    [LCLTipsView showTips:str location:LCLTipsLocationMiddle];
//                }
//            }];
            
            
            
            
            
            
            
        }
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

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(SMSSDKCountryAndAreaCode *)data{
    
    _defaultCode = data.areaCode;
    _defaultCountryName = data.countryName;
    
    self.countryCodeLabel.text=[NSString stringWithFormat:@"+%@",data.areaCode];
    [self.countryButton setTitle:data.countryName forState:UIControlStateNormal];
}

#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (1==buttonIndex){
        
        self.seconds = 59;
        [self.regetVerifyCodeButton setEnabled:NO];
        [self.regetVerifyCodeButton setHidden:YES];
        self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        [self.countTimer fire];
        
        NSString* str2=[self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];

        [SMSSDK getVerificationCodeBySMSWithPhone:self.phoneTextField.text zone:str2 result:^(NSError *error) {
//             if (error){
//                 
//                 [LCLTipsView showTips:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription] location:LCLTipsLocationMiddle];
//             }
         }];
    }
}

@end



















