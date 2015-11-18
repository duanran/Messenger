//
//  SelectedMapViewController.m
//  Messenger
//
//  Created by duanran on 15/11/17.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "SelectedMapViewController.h"

@interface SelectedMapViewController ()<MKMapViewDelegate>

@end

@implementation SelectedMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CLLocationCoordinate2D coordinate;
    
    
//        coordinate.latitude = 23.126055;
//        coordinate.longitude = 113.290995;
    
    
    coordinate=self.dateCoordinate;
    
    float zoomLevel = 0.05;
    
    self.title=self.address;
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    [ann setTitle:self.address];
    //触发viewForAnnotation
    [self.mapView addAnnotation:ann];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate=self;
    
;
    // Do any additional setup after loading the view from its nib.
}
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
////    //点击大头针，会出现以下信息
////    userLocation.title=@"中国";
////    userLocation.subtitle=@"四大文明古国之一";
//    
//    //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
//    //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    
//    
//    //这个方法可以设置地图精度以及显示用户所在位置的地图
//    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
//    MKCoordinateRegion region=MKCoordinateRegionMake(self.dateCoordinate, span);
//    [mapView setRegion:region animated:YES];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
