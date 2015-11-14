//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "WatchVideoRequest.h"

#import "RequestURL.h"

@interface MJPhotoView ()<UIAlertViewDelegate>
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
    BOOL isVideo;
}

@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        _photo.srcImageView.image = nil;
        
        
        // 不是gif，就马上开始下载
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            __unsafe_unretained MJPhotoView *photoView = self;
            __unsafe_unretained MJPhoto *photo = _photo;
            [_imageView setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                photo.image = image;
                
                // 调整frame参数
                [photoView adjustFrame];
            }];
        }
    } else {
        [self photoStartLoad];
    }

    // 调整frame参数
    [self adjustFrame];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        WatchVideoRequest *request=[[WatchVideoRequest alloc]init];
        NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];

        request.parameters=@{@"uKey":myObj.ukey,
                             @"id":_photo.videoId
                             };
        
        [request GETRequest:^(id reponseObject) {
            
            NSString *pathStr=[NSString stringWithFormat:@"%@",[reponseObject objectForKey:@"path"]];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,pathStr]];
            [self videoStartDownLoad:url fileName:pathStr];
        } failureCallback:^(NSString *errorMessage) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

        }];
    }
}
#pragma mark 下载视频
-(void)videoStartDownLoad:(NSURL *)Url fileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *lastCoponet=[fileName lastPathComponent];
    NSString *filePath=[docDir stringByAppendingPathComponent:lastCoponet];
    
    
    
    //判断文件是否已存在
    NSFileManager *fileManger=[NSFileManager defaultManager];
    
    if ([fileManger fileExistsAtPath:filePath]) {
        //文件已经存在无需下载
        if (self.photoViewDelegate&&[self.photoViewDelegate respondsToSelector:@selector(photoViewPlayVideo:)]) {
            _doubleTap = NO;
            [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
            [self.photoViewDelegate photoViewPlayVideo:_photo.videoUrl];
        }
        return;

    }
    

    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:Url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
//    [_photoLoadingView showLoading];
//    __unsafe_unretained MJPhotoView *photoView = self;
//    __unsafe_unretained MJPhotoLoadingView *loading = _photoLoadingView;
//
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
//            loading.progress = (float)totalBytesRead/totalBytesExpectedToRead;
//
//        
//    }];

    
    
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];

        if (self.photoViewDelegate&&[self.photoViewDelegate respondsToSelector:@selector(photoViewPlayVideo:)]) {
            _doubleTap = NO;
            [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
            [self.photoViewDelegate photoViewPlayVideo:_photo.videoUrl];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"下载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //下载失败
    }];
    
    [operation start];

}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        __unsafe_unretained MJPhotoView *photoView = self;
        __unsafe_unretained MJPhotoLoadingView *loading = _photoLoadingView;
        [_imageView setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
            if (receivedSize > kMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [photoView photoDidFinishLoadWithImage:image];
        }];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 2.0; 
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if ([_photo.photoStyle isEqualToString:@"video"]) {
        
        if ([_photo.IsSee integerValue]==1) {
                [self videoStartDownLoad:_photo.url fileName:[NSString stringWithFormat:@"%@",_photo.videoUrl]];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"查看视频需要%@【信用豆】，确定观看？",_photo.videoCoin] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    else{
        _doubleTap = NO;
        [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
    }
    
}
- (void)hide
{
    if (_doubleTap) return;
    
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    // 清空底部的小图
    _photo.srcImageView.image = nil;
    
    CGFloat duration = 0.15;
    if (_photo.srcImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    
    [UIView animateWithDuration:duration + 0.1 animations:^{
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        // 设置底部的小图片
        _photo.srcImageView.image = _photo.placeholder;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)dealloc
{
    // 取消请求
    [_imageView setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end