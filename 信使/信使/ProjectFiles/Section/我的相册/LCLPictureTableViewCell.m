//
//  LCLHomeTableViewCell.m
//  守艺
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LCLPictureTableViewCell.h"

#import "LCLAddPicButton.h"

@interface LCLPictureTableViewCell (){

    UILongPressGestureRecognizer *onelongPress;
    UILongPressGestureRecognizer *twolongPress;
    UILongPressGestureRecognizer *threelongPress;
}

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet LCLAddPicButton *addButton;

@end

@implementation LCLPictureTableViewCell

- (void)dealloc{

    self.homeCellDelegate = nil;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)longpressButton:(UILongPressGestureRecognizer *)gesture{

    UIButton *button = (UIButton *)gesture.view;
    
    if (gesture.state==UIGestureRecognizerStateBegan) {
        if (self.homeCellDelegate && [self.homeCellDelegate respondsToSelector:@selector(longpressSelectHomeTableViewCellCategoryWithTag:button:)]) {
            [self.homeCellDelegate longpressSelectHomeTableViewCellCategoryWithTag:button.tag button:button];
        }
    }
}

- (IBAction)didTapButton:(UIButton *)sender{

    if (self.homeCellDelegate && [self.homeCellDelegate respondsToSelector:@selector(didSelectHomeTableViewCellCategoryWithTag:button:)]) {
        [self.homeCellDelegate didSelectHomeTableViewCellCategoryWithTag:sender.tag button:sender];
    }
}

//设置信息
- (void)setCategoryDic:(NSDictionary *)categoryDic buttonTag:(NSInteger)buttonTag i:(int)i{

    LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:categoryDic];
    NSLog(@"categoryDic=%@",categoryDic);
//    NSString *url = photoObj.path;
    NSString *url = photoObj.thumb_360;

    NSString *status=[categoryDic objectForKey:@"status"];
    [self.addButton setTag:buttonTag];
    [self.addButton setHidden:YES];

    switch (i) {
        case 0:
            [self.oneButton setTag:buttonTag];
            if (categoryDic && categoryDic.count>0) {
                
                [self.oneButton setImageWithURL:url defaultImagePath:DefaultImagePath];
                if ([status isEqualToString:@"2"]) {
                    UILabel *waitReViewLabel=[[UILabel alloc]init];
                    [waitReViewLabel setFrame:CGRectMake(2, self.oneButton.frame.size.height/2-10, self.oneButton.frame.size.width-4, 20)];
                    waitReViewLabel.textColor=[UIColor whiteColor];
                    waitReViewLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    waitReViewLabel.text=@"待审核";
                    waitReViewLabel.font=[UIFont systemFontOfSize:14];
                    waitReViewLabel.textAlignment=NSTextAlignmentCenter;
                    [self.oneButton addSubview:waitReViewLabel];
                }
                
            }else{
                [self.oneButton setHidden:YES];
                [self.addButton setHidden:NO];
                [self.addButton setFrame:self.oneButton.frame];
            }
            break;
        case 1:
            [self.twoButton setTag:buttonTag];
            if (categoryDic && categoryDic.count>0) {
                
                [self.twoButton setImageWithURL:url defaultImagePath:DefaultImagePath];
                if ([status isEqualToString:@"2"]) {
                    UILabel *waitReViewLabel=[[UILabel alloc]init];
                    [waitReViewLabel setFrame:CGRectMake(2, self.oneButton.frame.size.height/2-10, self.oneButton.frame.size.width-4, 20)];
                    waitReViewLabel.textColor=[UIColor whiteColor];
                    waitReViewLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    waitReViewLabel.text=@"待审核";
                    waitReViewLabel.textAlignment=NSTextAlignmentCenter;
                    waitReViewLabel.font=[UIFont systemFontOfSize:14];
                    [self.twoButton addSubview:waitReViewLabel];
                }

            }else{
                [self.twoButton setHidden:YES];
                if (!self.oneButton.isHidden) {
                    [self.addButton setFrame:self.twoButton.frame];
                }
                [self.addButton setHidden:NO];
            }
            break;
        case 2:
            [self.threeButton setTag:buttonTag];
            if (categoryDic && categoryDic.count>0) {
                [self.threeButton setImageWithURL:url defaultImagePath:DefaultImagePath];
                if ([status isEqualToString:@"2"]) {
                    UILabel *waitReViewLabel=[[UILabel alloc]init];
                    [waitReViewLabel setFrame:CGRectMake(2,self.oneButton.frame.size.height/2-10, self.oneButton.frame.size.width-4, 20)];
                    waitReViewLabel.textColor=[UIColor whiteColor];
                    waitReViewLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    waitReViewLabel.text=@"待审核";
                    waitReViewLabel.textAlignment=NSTextAlignmentCenter;
                    waitReViewLabel.font=[UIFont systemFontOfSize:14];
                    [self.threeButton addSubview:waitReViewLabel];
                }

            }else{
                [self.threeButton setHidden:YES];
                if (!self.twoButton.isHidden) {
                    [self.addButton setFrame:self.threeButton.frame];
                }
                [self.addButton setHidden:NO];
            }
            break;
        default:
            break;
    }
}

- (void)setup{

    if (self.scale==0) {
        self.scale = HomeCellScale;
    }
    
    float width = kDeviceWidth/3.0;
        
    float orgX = 5;
    float orgY = 5;
    float imageWidth = width-orgX*2;
    float imageHeight = width*self.scale-orgY*2;
    
    //设置image位置
    CGRect imageOneFrame = self.oneButton.frame;
    CGRect imageTwoFrame = self.twoButton.frame;
    CGRect imageThreeFrame = self.threeButton.frame;
    imageOneFrame.size.width = imageWidth;
    imageOneFrame.size.height = imageHeight;
    imageOneFrame.origin.x = orgX;
    imageOneFrame.origin.y = orgY;
    imageTwoFrame.size.width = imageWidth;
    imageTwoFrame.size.height = imageHeight;
    imageTwoFrame.origin.x = orgX*3+imageWidth;
    imageTwoFrame.origin.y = orgY;
    imageThreeFrame.size.width = imageWidth;
    imageThreeFrame.size.height = imageHeight;
    imageThreeFrame.origin.x = orgX*5+imageWidth*2;
    imageThreeFrame.origin.y = orgY;
    [self.oneButton setFrame:imageOneFrame];
    [self.twoButton setFrame:imageTwoFrame];
    [self.threeButton setFrame:imageThreeFrame];
    
    [self.addButton setFrame:self.threeButton.frame];
    
    [self.oneButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.twoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.threeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.oneButton removeGestureRecognizer:onelongPress];
    onelongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressButton:)];
    [self.oneButton addGestureRecognizer:onelongPress];
    
    [self.twoButton removeGestureRecognizer:twolongPress];
    twolongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressButton:)];
    [self.twoButton addGestureRecognizer:twolongPress];

    [self.threeButton removeGestureRecognizer:threelongPress];
    threelongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressButton:)];
    [self.threeButton addGestureRecognizer:threelongPress];

}

@end








