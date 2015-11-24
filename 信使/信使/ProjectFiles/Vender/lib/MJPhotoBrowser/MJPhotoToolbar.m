//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"
#import "ComplainRequest.h"

@interface MJPhotoToolbar()<UIAlertViewDelegate>
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}
@property(nonatomic,strong)MJPhoto *currentPhoto;

@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(15, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_saveImageBtn setTitle:@"关闭" forState:UIControlStateHighlighted];

    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    
    
    
    UIButton *complainBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [complainBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-15-btnWidth, 0, btnWidth, btnWidth)];
    complainBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [complainBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [complainBtn setTitle:@"投诉" forState:UIControlStateHighlighted];
    [complainBtn addTarget:self action:@selector(complain) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:complainBtn];
}
-(void)complain
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"投诉" message:@"请您输入投诉理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *TextField=[alertView textFieldAtIndex:0];
        
        if ([TextField.text integerValue]<=0||TextField.text==NULL||[TextField.text isEqualToString:@"(null)"]||TextField.text==nil||[TextField.text isEqualToString:@""]) {
            return;
        }
        
        
        if (self.currentPhoto.picId) {
        ComplainRequest *request=[[ComplainRequest alloc]init];
            request.uKey=self.currentPhoto.uKey;
            request.pic_id=self.currentPhoto.picId;
            request.reason=TextField.text;
            
        [request GETRequest:^(id reponseObject) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"投诉成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } failureCallback:^(NSString *errorMessage) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"投诉失败" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
            

        }
    }
}
- (void)saveImage
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colsePhoto)]) {
        [self.delegate colsePhoto];
    }
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled=YES;
    self.currentPhoto=photo;
    
    
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
