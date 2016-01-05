//
//  UserInstrunctionViewController.h
//  Messenger
//
//  Created by duanran on 15/12/2.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInstrunctionViewController : BaseViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)IBOutlet  UIWebView *userWebView;

@end
