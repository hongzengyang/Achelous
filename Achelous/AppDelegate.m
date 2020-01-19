//
//  AppDelegate.m
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import "AppDelegate.h"
#import "OONavigationController.h"
#import "MDPageMaster.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>

@interface AppDelegate ()<BMKLocationAuthDelegate,BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    // 初始化定位SDK
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"67bgD1oNYg9Pas2ovGYcOLMnP5eSfB9U" authDelegate:self];
//    要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }

    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:@"67bgD1oNYg9Pas2ovGYcOLMnP5eSfB9U" generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }
    
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    
    [OOAPPMgr sharedMgr];
    [OOUserMgr sharedMgr];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    [self setupPageMaster];
    
    return YES;
}

- (void)setupPageMaster {
    //设置根导航
    NSDictionary *params = @{@"schema":@"xiaoying",
                             @"pagesFile":@"urlmapping",
                             @"rootVC":@"OOLoginVC"};
    [[MDPageMaster master] setupNavigationControllerWithParams:params];
    [MDPageMaster master].navigationContorller.view.backgroundColor = [UIColor whiteColor];
    [MDPageMaster master].navigationContorller.navigationBar.hidden = YES;
    self.window.rootViewController = [MDPageMaster master].navigationContorller;
}

/**
 联网结果回调

 @param iError 联网结果错误码信息，0代表联网成功
 */
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"联网失败：%d", iError);
    }
}

/**
 鉴权结果回调

 @param iError 鉴权结果错误码信息，0代表鉴权成功
 */
- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"授权失败：%d", iError);
    }
}


@end
