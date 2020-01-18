//
//  OOPatrolVC.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOPatrolVC.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LNActionSheet.h"

@interface OOPatrolVC ()<BMKMapViewDelegate, BMKLocationManagerDelegate>

@property (nonatomic, strong) UIView *navBar;

@property(nonatomic, strong) BMKLocationManager *locationManager;
@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKLocation *preLocation; //当前位置对象

@property (nonatomic, strong) UILabel *testLab;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation OOPatrolVC
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    _locationManager = nil;
    
    [_timer invalidate];
    _timer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    [self initLocation];
//    [self initBlock];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(tryIndoorLoc) userInfo:nil repeats:YES];
    [self tryIndoorLoc];
    
    [self.view addSubview:self.testLab];
}

-(void)tryIndoorLoc {
    NSLog(@"try indoor loc");
    if (_locationManager) {
        [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.baseIndoorMapEnabled = YES;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)initViews {
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.mapView];
}

#pragma mark -- 初始化地图定位相关
- (void)initLocation {
    _locationManager = [[BMKLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = NO;
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
    
//    [_locationManager setLocatingWithReGeocode:YES];
    
    //开启定位服务
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
}

-(void)initBlock {
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(BMKLocation *location, BMKLocationNetworkState state, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        if (location.location) {//得到定位信息，添加annotation
        
            NSLog(@"LOC = %@",location.location);
            NSLog(@"LOC ID= %@",location.locationID);
            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
            
            pointAnnotation.coordinate = location.location.coordinate;
            pointAnnotation.title = @"单次定位";
            if (location.rgcData) {
                pointAnnotation.subtitle = [location.rgcData description];
            } else {
                pointAnnotation.subtitle = @"rgc = null!";
            }
            
            if (location.rgcData.poiList) {
                for (BMKLocationPoi * poi in location.rgcData.poiList) {
                    NSLog(@"poi = %@, %@, %f, %@, %@", poi.name, poi.addr, poi.relaiability, poi.tags, poi.uid);
                }
            }
            
            if (location.rgcData.poiRegion) {
                NSLog(@"poiregion = %@, %@, %@", location.rgcData.poiRegion.name, location.rgcData.poiRegion.tags, location.rgcData.poiRegion.directionDesc);
            }
            
//            [strongSelf updateMessage:[NSString stringWithFormat:@"当前位置信息： \n经纬度：%.6f,%.6f \n地址信息：%@ \n网络状态：%d",location.location.coordinate.latitude, location.location.coordinate.longitude, [location.rgcData description], state]];
//
//            //[_mapView a];
//            MyLocation * loc = [[MyLocation alloc]initWithLocation:location.location withHeading:nil];
//            [strongSelf addLocToMapView:loc];
            
            weakSelf.mapView.centerCoordinate = location.location.coordinate;
            
        }
        
        if (location.rgcData) {
            NSLog(@"rgc = %@",[location.rgcData description]);
        }
        
        
        NSLog(@"netstate = %d",state);
    };
    
    
}

#pragma mark -- 定位回调
// 定位SDK中，位置变更的回调 //接收位置更新   实时更新位置
- (void)BMKLocationManager:(BMKLocationManager *)manager
         didUpdateLocation:(BMKLocation *)location
                   orError:(NSError *)error {
    if (error) {
        return;
    }
    if (!location) {
        return;
    }
    
    CGFloat distance = [location.location distanceFromLocation:self.preLocation.location];
    NSLog(@"与上一位置点的距离为:%f",distance);
    self.testLab.text = [NSString stringWithFormat:@"%lf米",distance];
    
    self.userLocation.location = location.location;
    [_mapView updateLocationData:self.userLocation];
    
    self.preLocation = location;
    
    
    // 如果大于5米 上传到服务器
    if (distance > 5) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [param setValue:[OOAPPMgr sharedMgr].currentXCID forKey:@"Xcid"];
        
        
        
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Upgps parameters:param options:nil block:^(BOOL success, id response) {
            
        }];
    }
    
}

// 定位SDK中，方向变更的回调
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    
    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)clickShareButton {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *titles = @[@"四乱事件",@"污染事件",@"险情事件",@"巡查实况"];
    for (int i = 0; i < titles.count; i++) {
        LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
        model.title = titles[i];
        model.sheetId = i;
        model.itemType = LNActionSheetItemNoraml;
        
        model.actionBlock = ^{
            [[MDPageMaster master] openUrl:@"xiaoying://oo_report_vc" action:^(MDUrlAction * _Nullable action) {
                [action setString:titles[i] forKey:@"typeText"];
            }];
        };
        [array addObject:model];
    }
    [LNActionSheet showWithDesc:@"上报类型" actionModels:[NSArray arrayWithArray:array] action:nil];
}


#pragma mark -- 百度地图
/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 1.6.0
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager doRequestAlwaysAuthorization:(CLLocationManager * _Nonnull)locationManager {
    
    [locationManager requestAlwaysAuthorization];
}

//-(void)updateMessage:(NSString *)msg
//{
//    locMessage.text = msg;
//
//}
//
//- (void)addLocToMapView:(MyLocation *)loc
//{
//    [_mapView updateLocationData:loc];
//    [_mapView setCenterCoordinate:loc.location.coordinate animated:YES];
//}

- (void)addAnnotationToMapView:(BMKPointAnnotation *)annotation
{
    [_mapView addAnnotation:annotation];
}

#pragma mark -- lazy
- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SAFE_TOP + 44)];
        
        //back
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [backBtn setImage:[UIImage imageNamed:@"mini_common_arrow_back_white"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
        [backBtn sizeToFit];
        [backBtn setFrame:CGRectMake(15, SAFE_TOP + (44 - backBtn.height) / 2.0,backBtn.width , backBtn.height)];
        [_navBar addSubview:backBtn];
        
        //record
        UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [recordBtn addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
        [recordBtn setTitle:@"上报" forState:(UIControlStateNormal)];
        [recordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [recordBtn sizeToFit];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right, SAFE_TOP, recordBtn.left - backBtn.right, 44)];
        titleLab.text = @"河湖巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - SAFE_BOTTOM - self.navBar.bottom)];
        //设置undersideMapView的缩放等级
        [_mapView setZoomLevel:17];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    }
    return _mapView;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (UILabel *)testLab {
    if (!_testLab) {
        _testLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 200, 30)];
        _testLab.font =[UIFont systemFontOfSize:15];
        _testLab.textColor = [UIColor blackColor];
        _testLab.backgroundColor = [UIColor whiteColor];
    }
    return _testLab;
}

@end
