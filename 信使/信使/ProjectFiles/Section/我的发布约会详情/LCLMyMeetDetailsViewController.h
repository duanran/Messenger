//
//  LCLMyMeetDetailsViewController.h
//  信使
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

typedef enum
{
    normalStatus        =   1001,
    existStatus         =   1002
}complainSatus;



#import "BaseViewController.h"

@interface LCLMyMeetDetailsViewController : BaseViewController<UIAlertViewDelegate>

@property (strong, nonatomic) LCLCreateMeetObject *meetDetailsObj;


@end
