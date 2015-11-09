//
//  LCLMapViewController.h
//  信使
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

#import <MapKit/MapKit.h>

@protocol LCLMapViewControllerDelegate <NSObject>

@optional
- (void)didSelectLng:(CGFloat)lng lat:(CGFloat)lat place:(NSString *)place;

@end

@interface LCLMapViewController : BaseViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) id<LCLMapViewControllerDelegate> mapDelegate;


@end
