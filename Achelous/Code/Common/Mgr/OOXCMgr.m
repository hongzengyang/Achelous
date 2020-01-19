//
//  OOXCMgr.m
//  Achelous
//
//  Created by hzy on 2020/1/19.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCMgr.h"
#import "DouglasPeucker.h"

@implementation OOUnFinishedXCModel

@end

@implementation OOSportNode

- (double)getLatitude {
    NSArray *latitudeAndLongitude = [self.location componentsSeparatedByString:@","];
    if (latitudeAndLongitude.count == 2) {
        return [[latitudeAndLongitude firstObject] doubleValue];
    }
    return 0;
}

- (double)getLongitude {
    NSArray *latitudeAndLongitude = [self.location componentsSeparatedByString:@","];
    if (latitudeAndLongitude.count == 2) {
        return [[latitudeAndLongitude lastObject] doubleValue];
    }
    return 0;
}

@end

@interface OOXCMgr ()<BMKLocationManagerDelegate>

@property(nonatomic, strong) BMKLocationManager *locationManager;
@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) BMKLocation *preLocation; //当前位置对象

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isStartUpdatingLocation;  //是否开启了定位

@property (nonatomic, strong) DouglasPeucker *peucker;

@end

@implementation OOXCMgr

+ (OOXCMgr *)sharedMgr {
    static OOXCMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[OOXCMgr alloc] init];
        [sharedInstance initAPP];
    });
    
    return sharedInstance;
}

- (void)initAPP {
    [self initLocationManager];
    [self initCompleteBlock];
    [self requestLocation];
}

- (void)initLocationManager {
    self.locationManager = [[BMKLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.locationTimeout = 10;
    self.locationManager.reGeocodeTimeout = 10;
}

-(void)initCompleteBlock {
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(BMKLocation *location, BMKLocationNetworkState state, NSError *error) {
//        if (error) {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//        }
//
//        if (location.location) {//得到定位信息，添加annotation
//
//            NSLog(@"LOC = %@",location.location);
//            NSLog(@"LOC ID= %@",location.locationID);
//            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
//
//            pointAnnotation.coordinate = location.location.coordinate;
//            pointAnnotation.title = @"单次定位";
//            if (location.rgcData) {
//                pointAnnotation.subtitle = [location.rgcData description];
//            } else {
//                pointAnnotation.subtitle = @"rgc = null!";
//            }
//
//            if (location.rgcData.poiList) {
//                for (BMKLocationPoi * poi in location.rgcData.poiList) {
//                    NSLog(@"poi = %@, %@, %f, %@, %@", poi.name, poi.addr, poi.relaiability, poi.tags, poi.uid);
//                }
//            }
//
//            if (location.rgcData.poiRegion) {
//                NSLog(@"poiregion = %@, %@, %@", location.rgcData.poiRegion.name, location.rgcData.poiRegion.tags, location.rgcData.poiRegion.directionDesc);
//            }
//        }
//
//        if (location.rgcData) {
//            NSLog(@"rgc = %@",[location.rgcData description]);
//        }

        CGFloat distance = [location.location distanceFromLocation:weakSelf.preLocation.location];
        NSLog(@"与上一位置点的距离为:%f",distance);
        
        weakSelf.userLocation.location = location.location;
        [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_didUpdateLocation object:nil];
        
        weakSelf.preLocation = location;
        
        if ([OOXCMgr sharedMgr].unFinishedXCModel.status != OOXCStatus_ing) {
            return;
        }
        OOSportNode *sportNode;
        NSString *createTime = [[OOAPPMgr sharedMgr] getDateString];
        NSString *intervalTime = [[OOAPPMgr sharedMgr] currentTimeStr];
        NSString *roadName = @"";
        CGFloat speed = 0;
        CGFloat latitude = location.location.coordinate.latitude;
        CGFloat longitude = location.location.coordinate.longitude;
        // 如果大于5米 上传到服务器
        if (distance > 0) {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
            [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"Xcid"];
            
            NSArray *points;
            {
                NSMutableDictionary *uploadLocation = [[NSMutableDictionary alloc] init];
                [uploadLocation setValue:createTime forKey:@"createTime"];
                [uploadLocation setValue:intervalTime forKey:@"locTime"];
                [uploadLocation setValue:roadName forKey:@"roadName"];
                [uploadLocation setValue:@(speed) forKey:@"speed"];
                
                NSMutableDictionary *longitudeAndLatitude = [[NSMutableDictionary alloc] init];
                [longitudeAndLatitude setValue:@(latitude) forKey:@"latitude"];
                [longitudeAndLatitude setValue:@(longitude) forKey:@"longitude"];
                [uploadLocation setValue:longitudeAndLatitude forKey:@"location"];
                
                points = @[uploadLocation];
            }
            [param setValue:points forKey:@"points"];
            
            [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Upgps parameters:param options:nil block:^(BOOL success, id response) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_upload_location_success object:nil];
                }
            }];
            
            OOSportNode *node = [[OOSportNode alloc] init];
            node.location = [NSString stringWithFormat:@"%lf",latitude];
            node.location = [node.location stringByAppendingString:@","];
            node.location = [node.location stringByAppendingFormat:@"%lf",longitude];
            node.locTime = intervalTime;
            node.speed = [NSString stringWithFormat:@"%lf",speed];
            node.createTime = createTime;
            node.roadName = roadName;
            sportNode = node;
            [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_upload_location_begin object:nil userInfo:@{@"sportNode":sportNode}];
        }
        
    };


}

- (void)startUpdatingLocation {
//    if (self.isStartUpdatingLocation) {
//        return;
//    }
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
//    [self beginTimer];
    self.isStartUpdatingLocation = YES;
}

- (void)finishUpdatingLocation {
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
//    [self endTimer];
    self.isStartUpdatingLocation = NO;
}

- (void)requestLocation {
    BOOL success = [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];
}

- (NSArray *)handleDouglasPeuckerWithArray:(NSArray<OOSportNode *> *)dataList {
    return [self.peucker douglasAlgorithm:dataList threshold:10];
}

#pragma mark -- 百度定位
// 定位SDK中，位置变更的回调 //接收位置更新   实时更新位置
- (void)BMKLocationManager:(BMKLocationManager *)manager
         didUpdateLocation:(BMKLocation *)location
                   orError:(NSError *)error {
    if (!self.isStartUpdatingLocation) {
        NSLog(@"当前并没有开启巡查");
        return;
    }
    CGFloat distance = [location.location distanceFromLocation:self.preLocation.location];
    NSLog(@"与上一位置点的距离为:%f",distance);
    
    self.userLocation.location = location.location;
    [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_didUpdateLocation object:nil];
    
    self.preLocation = location;
    
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status != OOXCStatus_ing) {
        return;
    }
    OOSportNode *sportNode;
    NSString *createTime = [[OOAPPMgr sharedMgr] getDateString];
    NSString *intervalTime = [[OOAPPMgr sharedMgr] currentTimeStr];
    NSString *roadName = @"";
    CGFloat speed = 0;
    CGFloat latitude = location.location.coordinate.latitude;
    CGFloat longitude = location.location.coordinate.longitude;
    // 如果大于5米 上传到服务器
    if (distance > 20) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"Xcid"];
        
        NSArray *points;
        {
            NSMutableDictionary *uploadLocation = [[NSMutableDictionary alloc] init];
            [uploadLocation setValue:createTime forKey:@"createTime"];
            [uploadLocation setValue:intervalTime forKey:@"locTime"];
            [uploadLocation setValue:roadName forKey:@"roadName"];
            [uploadLocation setValue:@(speed) forKey:@"speed"];
            
            NSMutableDictionary *longitudeAndLatitude = [[NSMutableDictionary alloc] init];
            [longitudeAndLatitude setValue:@(latitude) forKey:@"latitude"];
            [longitudeAndLatitude setValue:@(longitude) forKey:@"longitude"];
            [uploadLocation setValue:longitudeAndLatitude forKey:@"location"];
            
            points = @[uploadLocation];
        }
        [param setValue:points forKey:@"points"];
        
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Upgps parameters:param options:nil block:^(BOOL success, id response) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_upload_location_success object:nil];
            }
        }];
        
        OOSportNode *node = [[OOSportNode alloc] init];
        node.location = [NSString stringWithFormat:@"%lf",latitude];
        node.location = [node.location stringByAppendingString:@","];
        node.location = [node.location stringByAppendingFormat:@"%lf",longitude];
        node.locTime = intervalTime;
        node.speed = [NSString stringWithFormat:@"%lf",speed];
        node.createTime = createTime;
        node.roadName = roadName;
        sportNode = node;
        [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_upload_location_begin object:nil userInfo:@{@"sportNode":sportNode}];
    }
}

// 定位SDK中，方向变更的回调
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    
    self.userLocation.heading = heading;
    [[NSNotificationCenter defaultCenter] postNotificationName:pref_key_notification_didUpdateHeading object:nil];
}

/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 1.6.0
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager doRequestAlwaysAuthorization:(CLLocationManager * _Nonnull)locationManager {
    [locationManager requestAlwaysAuthorization];
}

#pragma mark -- 定时器相关
- (void)beginTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(requestLocation) userInfo:nil repeats:YES];
}

- (void)endTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -- lazy
- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (DouglasPeucker *)peucker {
    if (!_peucker) {
        _peucker = [[DouglasPeucker alloc] init];
    }
    return _peucker;
}

@end
