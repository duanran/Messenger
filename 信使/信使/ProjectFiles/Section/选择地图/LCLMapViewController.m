//
//  LCLMapViewController.m
//  信使
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMapViewController.h"
#import "MapTableViewCell.h"


@interface LCLMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{

    NSInteger defaultSelectIndex;
    CLGeocoder *_geocoder;
}

@property (strong, nonatomic) CLLocationManager *locationManager;//定义Manager

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation LCLMapViewController

- (void)dealloc{

    self.mapDelegate = nil;
    
    [_locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    defaultSelectIndex=-1;
    [self.navigationItem setTitle:@"选择地点"];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(clickOk)];
    
    [barItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = barItem;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 23.126055;
    coordinate.longitude = 113.290995;

    float zoomLevel = 0.05;
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    self.mapView.showsUserLocation = YES;

    _geocoder=[[CLGeocoder alloc]init];
    
    [self locationAction:self.locationButton];

}
-(void)clickOk
{
    if (defaultSelectIndex>-1) {
        if (self.mapDelegate && [self.mapDelegate respondsToSelector:@selector(didSelectLng:lat:place:)]) {
            CLPlacemark *placemark = [self.dataArray objectAtIndex:defaultSelectIndex];
            CLLocation *location = placemark.location;//位置
            NSDictionary *addressDic = placemark.addressDictionary;//详细
            
            [self.mapDelegate didSelectLng:location.coordinate.longitude lat:location.coordinate.latitude place:[NSString stringWithFormat:@"%@", [addressDic objectForKey:@"Name"]]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }

    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationAction:(id)sender{
    
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        }
        
        [self.locationButton setEnabled:NO];
        
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=10;
        [self.locationManager requestWhenInUseAuthorization];//添加这句
        [self.locationManager startUpdatingLocation];
        
    }else {
        //提示用户无法进行定位操作
        
        [LCLTipsView showTips:@"亲，定位服务还没打开呢" location:LCLTipsLocationMiddle];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    [self.locationButton setEnabled:YES];
    [manager stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@ Lng: %@", strLat, strLng);
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *newLocation = [locations lastObject];
    
    [self.locationButton setEnabled:YES];
    [manager stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@ Lng: %@", strLat, strLng);
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    @weakify(self);
    
    //创建一个位置信息对象，第一个参数为经纬度，第二个为纬度检索范围，单位为米，第三个为经度检索范围，单位为米
    //初始化一个检索请求对象
    MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc]init];
    //设置检索参数
    req.region=region;
    //兴趣点关键字
    req.naturalLanguageQuery=@"place";
    //初始化检索
    MKLocalSearch * ser = [[MKLocalSearch alloc]initWithRequest:req];
    //开始检索，结果返回在block中
    [ser startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //兴趣点节点数组
        NSArray * array = [NSArray arrayWithArray:response.mapItems];
        self_weak_.dataArray = [[NSMutableArray alloc] init];

        for (int i=0; i<array.count; i++) {
            MKMapItem * item=array[i];
            MKPointAnnotation * point = [[MKPointAnnotation alloc]init];
            point.title=item.name;
            point.subtitle=item.phoneNumber;
            point.coordinate=item.placemark.coordinate;
            [self_weak_.mapView addAnnotation:point];
//            [self_weak_.mapView setRegion:region animated:NO];
            
            [self_weak_.dataArray addObject:item.placemark];
        }
        
        [self_weak_.tableView reloadData];
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    [manager stopUpdatingLocation];
    
    [self.locationButton setEnabled:YES];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status==3 || status==4) {
        
        [manager startUpdatingLocation];
        
    }else{

        [LCLTipsView showTips:@"亲，请打开位置服务" location:LCLTipsLocationMiddle];
        
        [manager stopUpdatingLocation];
        
        [self.locationButton setEnabled:YES];
    }
}


#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"homecell";
    
    MapTableViewCell *cell=[[MapTableViewCell alloc]init];
    
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
//    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//    }
    
    NSArray *cellArr=[[NSBundle mainBundle]loadNibNamed:@"MapTableViewCell" owner:self options:nil];
    if (cell==nil) {
        cell=[cellArr objectAtIndex:0];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    CLPlacemark *placemark = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *addressDic= placemark.addressDictionary;//详细

    [cell.titleLabel setText:[addressDic objectForKey:@"Name"]];
    [cell.detialLabel setText:[NSString stringWithFormat:@"%@ %@", [addressDic objectForKey:@"Country"], [addressDic objectForKey:@"Name"]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLLocationCoordinate2D coordinate;

    
    
    CLPlacemark *placemark = [self.dataArray objectAtIndex:indexPath.row];
    CLLocation *location = placemark.location;//位置

    
    coordinate=location.coordinate;
    float zoomLevel = 0.05;
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

    defaultSelectIndex=indexPath.row;
    
    
//    if (self.mapDelegate && [self.mapDelegate respondsToSelector:@selector(didSelectLng:lat:place:)]) {
//        
//        CLPlacemark *placemark = [self.dataArray objectAtIndex:indexPath.row];
//        CLLocation *location = placemark.location;//位置
//        NSDictionary *addressDic = placemark.addressDictionary;//详细
//        
//        [self.mapDelegate didSelectLng:location.coordinate.longitude lat:location.coordinate.latitude place:[NSString stringWithFormat:@"%@", [addressDic objectForKey:@"Name"]]];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self endKeyboardEditting];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>0) {
        
        [self getCoordinateByAddress:textField.text];
    }
    return YES;
}


#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    
    [self endKeyboardEditting];
    
    @weakify(self);
    
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        
        self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:placemarks];
        
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
        
        [self_weak_.tableView reloadData];
    }];
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
