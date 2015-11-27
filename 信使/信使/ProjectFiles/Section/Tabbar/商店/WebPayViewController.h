//
//  WebPayViewController.h
//  Messenger
//
//  Created by duanran on 15/11/27.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface WebPayViewController : BaseViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString * payUrl;
@end
