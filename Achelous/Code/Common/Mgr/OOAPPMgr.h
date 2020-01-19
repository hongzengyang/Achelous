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

NS_ASSUME_NONNULL_BEGIN

@interface OOAPPMgr : NSObject

@property (nonatomic, assign) CGFloat safeTopArea;
@property (nonatomic, assign) CGFloat safeBottomArea;

+ (OOAPPMgr *)sharedMgr;

- (NSString *)deviceID;
- (NSString *)appVersion;

- (BOOL)networkAvailable:(BOOL)showDialog;

//获取当前时间戳
- (NSString *)currentTimeStr;
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateString;

@end

NS_ASSUME_NONNULL_END
