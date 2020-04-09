//
//  OOAPPMgr.h
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PREF_KEY_NETWORK_AVAILABLE  @"pref_key_network_available"

#define CHECK_NWTWORK(showDialog)   [[OOAPPMgr sharedMgr] networkAvailable:showDialog]

typedef NS_ENUM(NSUInteger, OOCounty) {
    OOCountyNone = -1,
    OOCountyWD = 0,
    OOCountyDY = 1,
    OOCountyNH = 2,
    OOCountyYA = 3,
    OOCountyDebug = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface OOAPPMgr : NSObject

@property (nonatomic, assign) CGFloat safeTopArea;
@property (nonatomic, assign) CGFloat safeBottomArea;
@property (nonatomic, assign) OOCounty county;


+ (OOAPPMgr *)sharedMgr;

- (NSString *)deviceID;
- (NSString *)appVersion;

- (BOOL)networkAvailable:(BOOL)showDialog;

//获取当前时间戳
- (NSString *)currentTimeStr;
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateString;

//
- (NSTimeInterval)timeIntervalSinceDate:(NSString *)createAt;

- (NSString *)getMMSSFromSS:(NSInteger)seconds;

@end

NS_ASSUME_NONNULL_END
