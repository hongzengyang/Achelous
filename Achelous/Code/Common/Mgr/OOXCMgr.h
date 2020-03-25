//
//  OOXCMgr.h
//  Achelous
//
//  Created by hzy on 2020/1/19.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define pref_key_notification_didUpdateLocation                   @"pref_key_notification_didUpdateLocation"
#define pref_key_notification_didUpdateHeading                    @"pref_key_notification_didUpdateHeading"
#define pref_key_notification_upload_location_success             @"pref_key_notification_upload_location_success"
#define pref_key_notification_upload_location_begin               @"pref_key_notification_upload_location_begin"

//巡查状态 0：未巡查，1：巡查中 ，2：暂停，3：已结束（不会出现）
typedef NS_ENUM(NSUInteger,OOXCStatus) {
    OOXCStatus_notBegin,
    OOXCStatus_ing,
    OOXCStatus_pause,
    OOXCStatus_end,
};

NS_ASSUME_NONNULL_BEGIN

@interface OOUnFinishedXCModel : NSObject

@property (nonatomic, assign) NSInteger xc_id;//巡查ID
@property (nonatomic, copy) NSString *XCMC;//巡查名称
@property (nonatomic, copy) NSString *XCR;//巡查用户ID
@property (nonatomic, assign) OOXCStatus status;//巡查状态 0：未巡查，1：巡查中 ，2：暂停，3：已结束（不会出现）
@property (nonatomic, copy) NSString *Stoptime;//本次巡查如果有暂停过，暂停的总时间 单位：秒
@property (nonatomic, copy) NSString *SJQ; //巡查开始时间
@property (nonatomic, copy) NSString *SJZ; //巡查结束时间 没用

@end

@interface OOSportNode : NSObject

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locTime;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *roadName;

- (double)getLatitude;
- (double)getLongitude;

@end

@interface OOXCMgr : NSObject

@property (nonatomic, strong) OOUnFinishedXCModel *unFinishedXCModel;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, assign) NSInteger xcDuration; //巡查时间  秒单位

+ (OOXCMgr *)sharedMgr;

//定位(连续)
- (void)startUpdatingLocation;
- (void)finishUpdatingLocation;

//定位(单次)
- (void)requestLocation;

//上传当前点到server
- (void)uploadCurrentLoactionToServer;

- (CGFloat)distanceFrompreUploadLocation;

//发现问题 巡查实况
- (NSArray <NSString *>*)reportTypeArray;

- (void)fetchCurentUnfinishedXCModelWithCompleteHandle:(void(^)(BOOL complete))completeHandle;

@end

NS_ASSUME_NONNULL_END
