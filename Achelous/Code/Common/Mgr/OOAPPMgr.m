//
//  OOAPPMgr.m
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOAPPMgr.h"
#import <AFNetworking/AFNetworking.h>

@interface OOAPPMgr ()

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation OOAPPMgr

+ (OOAPPMgr *)sharedMgr {
    static OOAPPMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[OOAPPMgr alloc] init];
        [sharedInstance initAPP];
    });
    
    return sharedInstance;
}

- (void)initAPP {
    self.county = OOCountyNone;
    id cache = [[NSUserDefaults standardUserDefaults] valueForKey:@"pref_key_county"];
    if (cache && [cache isKindOfClass:[NSNumber class]]) {
        self.county = [cache integerValue];
    }
    
    [self startMonitorNetwork];
}

- (NSString *)deviceID {
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceID;
}

- (NSString *)appVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

- (void)setCounty:(OOCounty)county {
    _county = county;
    [[NSUserDefaults standardUserDefaults] setValue:@(county) forKey:@"pref_key_county"];
}

#pragma mark -- 网络监听
- (void)startMonitorNetwork {
    self.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:PREF_KEY_NETWORK_AVAILABLE object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [[NSNotificationCenter defaultCenter] postNotificationName:PREF_KEY_NETWORK_AVAILABLE object:nil];
                break;
        }
        self.networkStatus = status;
    }];

    //开始监控
    [manager startMonitoring];
}

- (BOOL)networkAvailable:(BOOL)showDialog {
    BOOL available = NO;
    if (self.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN || self.networkStatus ==  AFNetworkReachabilityStatusReachableViaWiFi) {
        available = YES;
    }
    
    if (!available && showDialog) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_NOT_AVAILABLE];
        });
    }
    
    return available;
}

#pragma mark -- 工具方法
//获取当前时间戳
- (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateString {
    NSTimeInterval time= [[self currentTimeStr] doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (NSTimeInterval)timeIntervalSinceDate:(NSString *)createAt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:createAt];
    //八小时时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:timeDate];
    NSDate *mydate = [timeDate dateByAddingTimeInterval:interval];
    NSDate *nowDate = [[NSDate date]dateByAddingTimeInterval:interval];
    //两个时间间隔
    NSTimeInterval timeInterval = [mydate timeIntervalSinceDate:nowDate];
    timeInterval = -timeInterval;
    
    return timeInterval;
}

- (NSString *)getMMSSFromSS:(NSInteger)seconds {
    if (seconds <= 0) {
        return @"00:00:00";
    }
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

@end
