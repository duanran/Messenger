//
//  SelectedMapViewController.h
//  Messenger
//
//  Created by duanran on 15/11/17.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface SelectedMapViewController : BaseViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic,assign)CLLocationCoordinate2D dateCoordinate;
@property(nonatomic,strong)NSString *address;
@end
