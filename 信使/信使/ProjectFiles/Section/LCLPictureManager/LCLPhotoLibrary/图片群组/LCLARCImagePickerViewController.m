//
//  LCLARCImagePickerViewController.m
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCImagePickerViewController.h"
#import "LCLARCImagePickerTableViewCell.h"
#import "LCLARCSelectImageController.h"

@interface LCLARCImagePickerViewController () <LCLARCSelectImageControllerDelegate>

@end

@implementation LCLARCImagePickerViewController

- (void)dealloc{
    
    for (CALayer *layer in [self.navigationController.navigationBar.layer sublayers]) {
        [layer removeFromSuperlayer];
    }
    
    self.lclImagePickerViewDelegate = nil;
    
    self.lclTableView.delegate = nil;
    self.lclTableView.dataSource = nil;

    [self.lclTableView removeFromSuperview];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{

    self.view.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.view.alpha = 1;
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"照片"];

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],UITextAttributeTextShadowColor,[UIFont systemFontOfSize:17],UITextAttributeFont,nil]];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancleAction:)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    
    self.lclImageGroupArray = [[NSMutableArray alloc]init];
    self.lclImageGroupURLArray = [[NSMutableArray alloc]init];
    self.lclImageDictionary = [[NSMutableDictionary alloc]init];

    [self getSystemImagesInfo];
    
    self.lclTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.lclTableView.delegate = self;
    self.lclTableView.dataSource = self;
    [self.view addSubview:self.lclTableView];

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

#pragma -
#pragma tableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lclImageGroupArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LCLARCImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        
        cell = [[LCLARCImagePickerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSString *groupName = [self.lclImageGroupArray objectAtIndex:indexPath.row];
    
    NSMutableArray *arr = [self.lclImageGroupURLArray objectAtIndex:indexPath.row];
    
    NSString *finalUrl = @"";
    if ([arr count]>0) {
        finalUrl = [arr objectAtIndex:0];
        if ([groupName isEqualToString:@"相机胶卷"]) {
            finalUrl = [arr objectAtIndex:([arr count]-1)];
        }
    }
    
    UIImage *image = [self.lclImageDictionary objectForKey:finalUrl];
    
    [cell setupWithThumbnailImage:image groupName:groupName count:[NSString stringWithFormat:@"%i", [arr count]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(77, 77);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    [layout setHeaderReferenceSize:CGSizeMake(320, 2)];
    [layout setFooterReferenceSize:CGSizeMake(320, 10)];
    [layout setSectionInset:UIEdgeInsetsMake(0, 2, 0, 2)];
    
    LCLARCSelectImageController *select = [[LCLARCSelectImageController alloc]initWithCollectionViewLayout:layout];
    select.lclSelectImageDelegate = self;
    [select setLclImageDictionary:self.lclImageDictionary];
    [select setLclImageURLArray:[self.lclImageGroupURLArray objectAtIndex:indexPath.row]];
    [select setLclImageGroupName:[self.lclImageGroupArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:select animated:YES];
    
}


#pragma -
#pragma LCLARCSelectImageControllerDelegate Methods

//取消
- (void)lclARCSelectImageControllerDidCancel{

    if (self.lclImagePickerViewDelegate && [self.lclImagePickerViewDelegate respondsToSelector:@selector(lclARCImagePickerViewControllerDidCancel)]) {
        [self.lclImagePickerViewDelegate lclARCImagePickerViewControllerDidCancel];
    }
}

//完成
- (void)lclARCSelectImageControllerDidFinishPickingImage:(UIImage *)image lclThumbnailImage:(UIImage *)lclThumbnailImage{

    if (self.lclImagePickerViewDelegate && [self.lclImagePickerViewDelegate respondsToSelector:@selector(lclARCImagePickerViewControllerDidFinishPickingImage:lclThumbnailImage:)]) {
        [self.lclImagePickerViewDelegate lclARCImagePickerViewControllerDidFinishPickingImage:image lclThumbnailImage:lclThumbnailImage];
    }
}

@end















