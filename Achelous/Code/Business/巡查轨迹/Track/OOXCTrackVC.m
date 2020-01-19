//
//  OOXCTrackVC.m
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCTrackVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <YYModel/YYModel.h>

@interface OOXCTrackVC ()<BMKMapViewDelegate,BMKLocationManagerDelegate>

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) BMKLocationManager *locationManager;
@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) NSMutableArray *sportNodes; // 轨迹点
@property (nonatomic, copy) NSString *titleText;

@end

@implementation OOXCTrackVC

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    NSDictionary *responce = [urlAction anyObjectForKey:@"responce"];
    NSArray *data = [responce xyArrayForKey:@"data"];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)obj;
            OOSportNode *info = [OOSportNode yy_modelWithJSON:d];
            [self.sportNodes addObject:info];
        }
    }];
    
    self.titleText = [responce valueForKey:@"XCMC"];
}

#pragma mark -- Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
}

#pragma mark -- Other
- (void)addSubViews {
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.mapView];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    
}

#pragma mark -- BMKMapView Delegate
/** 地图加载完成 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
//    NSArray *temp = [[OOXCMgr sharedMgr] handleDouglasPeuckerWithArray:self.sportNodes];
//    [self.sportNodes removeAllObjects];
//    [self.sportNodes addObjectsFromArray:temp];
    
    CLLocation *firstLocation;
    CLLocationCoordinate2D coors[self.sportNodes.count];
    for (NSInteger i = 0; i < self.sportNodes.count; i++) {
        OOSportNode *info = [self.sportNodes objectAtIndex:i];
        NSString *location = info.location;
        NSArray *coordinate = [location componentsSeparatedByString:@","];
        if (coordinate.count == 2) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[coordinate firstObject] floatValue], [[coordinate lastObject] floatValue]);
            coors[i] = location;
        }
        
        if (i == 0) {
            firstLocation = [[CLLocation alloc] initWithLatitude:[[coordinate firstObject] floatValue] longitude:[[coordinate lastObject] floatValue]];
        }
    }
    
    //轨迹
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:self.sportNodes.count];
    [self.mapView addOverlay:polyline];
    
    //起点
    BMKPointAnnotation *beginAnnotation = [[BMKPointAnnotation alloc]init];
    beginAnnotation.coordinate = coors[0];
    beginAnnotation.title = @"起点";
    beginAnnotation.subtitle = @"起点--";
    [self.mapView addAnnotation:beginAnnotation];
    //终点
    BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc]init];
    endAnnotation.coordinate = coors[self.sportNodes.count - 1];
    endAnnotation.title = @"终点";
    endAnnotation.subtitle = @"终点--";
    [self.mapView addAnnotation:endAnnotation];
    

    BMKUserLocation *beginLocation = [[BMKUserLocation alloc] init];
    beginLocation.location = firstLocation;
    [self.mapView updateLocationData:beginLocation];
}

/** 根据overlay生成对应的View */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if (![overlay isKindOfClass:[BMKPolyline class]]) return nil;
    
    BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    polylineView.strokeColor = [UIColor xycColorWithHex:0x3978EB];
    polylineView.lineWidth = 3.0;
    polylineView.lineDashType = kBMKLineDashTypeSquare;
    
    return polylineView;
}

/** 根据anntation生成对应的View */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if ([annotation.title isEqualToString:@"起点"]) {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier_begin";
            BMKAnnotationView *beginAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (beginAnnotationView == nil)
            {
                beginAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:reuseIndetifier];
            }

            beginAnnotationView.image = [UIImage imageNamed:@"oo_ditu_start_icon"];
            return beginAnnotationView;
        }
        
        if ([annotation.title isEqualToString:@"终点"]) {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier_end";
            BMKAnnotationView *endAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (endAnnotationView == nil)
            {
                endAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:reuseIndetifier];
            }

            endAnnotationView.image = [UIImage imageNamed:@"oo_ditu_end_icon"];
            return endAnnotationView;
        }
    }
    
    return nil;
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
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 200)/2.0, SAFE_TOP, 200, 44)];
        titleLab.text = [NSString stringWithFormat:@"%@回放)",self.titleText];
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - SAFE_BOTTOM - self.navBar.bottom)];
        //设置undersideMapView的缩放等级
        [_mapView setZoomLevel:21];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    }
    return _mapView;
}

- (NSMutableArray *)sportNodes {
    if (!_sportNodes) {
        _sportNodes = [[NSMutableArray alloc] init];
    }
    return _sportNodes;
}

@end
