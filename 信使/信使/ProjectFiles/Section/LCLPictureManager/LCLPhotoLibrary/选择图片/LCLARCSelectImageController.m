//
//  LCLARCSelectImageController.m
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCSelectImageController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "LCLARCSelectImageCell.h"

#define CELL_ID @"CELL_ID"


@interface LCLARCSelectImageController ()

@property (strong, nonatomic) UIImage *lclThumbnailImage;

@end

@implementation LCLARCSelectImageController

- (void)dealloc{
    
    self.lclSelectImageDelegate = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:self.lclImageGroupName];

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancleAction:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[LCLARCSelectImageCell class] forCellWithReuseIdentifier:CELL_ID];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)scrollToBottom{

    NSInteger rows = [self.collectionView numberOfItemsInSection:0];
    if (rows > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//取消选择图片
- (IBAction)cancleAction:(id)sender{

    if (self.lclSelectImageDelegate && [self.lclSelectImageDelegate respondsToSelector:@selector(lclARCSelectImageControllerDidCancel)]) {
        [self.lclSelectImageDelegate lclARCSelectImageControllerDidCancel];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -
#pragma UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.lclImageURLArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LCLARCSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    NSString *url = [self.lclImageURLArray objectAtIndex:indexPath.row];
    UIImage *image = [self.lclImageDictionary objectForKey:url];
    
    [cell setTag:indexPath.row];
    [cell.lclImageView setImage:image];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *url = [self.lclImageURLArray objectAtIndex:indexPath.row];
    self.lclThumbnailImage = [self.lclImageDictionary objectForKey:url];

    [self getImageWithSystemImageUrl:url];
    
}


//获取图片
- (void)getImageWithSystemImageUrl:(NSString *)urlStr{
    
    @autoreleasepool {
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
        [assetLibrary assetForURL:[NSURL URLWithString:urlStr] resultBlock:^(ALAsset *asset){
            
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            [self lclARCSelectImageControllerDidFinishSelectImage:image lclThumbnailImage:self.lclThumbnailImage];
            
        }failureBlock:^(NSError *error) {
            
            [self lclARCSelectImageControllerDidFinishSelectImage:nil lclThumbnailImage:self.lclThumbnailImage];
        }];
    }
}

//完成
- (void)lclARCSelectImageControllerDidFinishSelectImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage{

    if (self.lclSelectImageDelegate && [self.lclSelectImageDelegate respondsToSelector:@selector(lclARCSelectImageControllerDidFinishPickingImage:lclThumbnailImage:)]) {
        [self.lclSelectImageDelegate lclARCSelectImageControllerDidFinishPickingImage:image lclThumbnailImage:lclThumbnailImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end











