//
//  LCLControlXMPPAndDataBase+Action
//  LCLTestArchitectureDesign
//
//  Created by lcl on 14-4-3.
//  Copyright (c) 2014年 lcl. All rights reserved.
//

#import "LCLARCImagePickerViewController.h"
#import<AssetsLibrary/AssetsLibrary.h>

@implementation LCLARCImagePickerViewController (Action)

//取消选择图片
- (IBAction)cancleAction:(id)sender{
    
    if (self.lclImagePickerViewDelegate && [self.lclImagePickerViewDelegate respondsToSelector:@selector(lclARCImagePickerViewControllerDidCancel)]) {
        [self.lclImagePickerViewDelegate lclARCImagePickerViewControllerDidCancel];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取系统图片信息
- (void)getSystemImagesInfo{
    
    @autoreleasepool {
        
        //生成整个photolibrary句柄的实例
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group == nil){
                
                if (stop) {
                    [self.lclTableView reloadData];
                }
            }else{
                //groupInfo= ALAssetsGroup- Name:Camera Roll, Type:Saved Photos, Assets count:71
                NSString *groupInfo = [NSString stringWithFormat:@"%@",group];//获取相簿的组
                
                NSString *g1 = [groupInfo substringFromIndex:16] ;
                
                NSArray *arr = [[NSArray alloc] init];
                
                arr = [g1 componentsSeparatedByString:@","];
                
                NSString *groupName = [[arr objectAtIndex:0]substringFromIndex:5];
                
                if ([groupName isEqualToString:@"Camera Roll"]) {
                    groupName = @"相机胶卷";
                }
                
                [self.lclImageGroupArray insertObject:groupName atIndex:0];
                
                NSMutableArray *urlArray = [[NSMutableArray alloc]init];
                
                //获取所有group
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    //从group里面
                    NSString* assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]) {
                        
                        NSString *urlStr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        [urlArray addObject:urlStr];
                        
                        //获得照片缩略图
                        [self.lclImageDictionary setObject:[UIImage imageWithCGImage:result.thumbnail] forKey:urlStr];

                        //NSLog(@"图片 Size = %lld",[[result defaultRepresentation]size]);
                    }else if([assetType isEqualToString:ALAssetTypeVideo]){
                        NSLog(@"获取系统相册里的视频");
                    }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                        NSLog(@"获取系统相册里的未知类型文件");
                    }
                    
                    if (result==nil) {
                        if (stop) {
                            [self.lclImageGroupURLArray insertObject:urlArray atIndex:0];
                        }
                    }
                }];
            }
            
        } failureBlock:^(NSError *error) {
            
            if ([error.localizedDescription rangeOfString:@"Global deniedaccess"].location!=NSNotFound) {
                
                [self lclShowAlertViewWithMessage:@"无法访问相册位置服务.请在'设置->隐私->定位服务'设置为打开状态."];
            }else{
                [self lclShowAlertViewWithMessage:[NSString stringWithFormat:@"无法访问相册.请在'设置->隐私->照片'设置本APP为打开状态."]];
            }
        }];
    }
}

//获取图片
- (void)getImageWithSystemImageUrl:(NSString *)urlStr{
    
    @autoreleasepool {
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
        [assetLibrary assetForURL:[NSURL URLWithString:urlStr] resultBlock:^(ALAsset *asset){
            
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            
            NSLog(@"%@", image);
            
        }failureBlock:^(NSError *error) {
            
            [self lclShowAlertViewWithMessage:[NSString stringWithFormat:@"相册访问失败:%@",[error localizedDescription]]];
        }];
    }
}

//提示信息
- (void)lclShowAlertViewWithMessage:(NSString *)alertStr{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


@end

















