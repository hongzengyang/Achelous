//
//  OOUserMgr.m
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOUserMgr.h"
#import "OOServerService.h"
#import <YYModel/YYModel.h>

@implementation OOUserInfo
//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
//
////    [dict setValue:@"UserId" forKey:@"userId"];
////    [dict setValue:@"RealName" forKey:@"realName"];
////    [dict setValue:@"AreaCode" forKey:@"areaCode"];
//    return dict;
//}

@end

@interface OOUserMgr ()

@property (nonatomic, strong) OOUserInfo *userInfo;

@end

@implementation OOUserMgr
+ (OOUserMgr *)sharedMgr {
    static OOUserMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[OOUserMgr alloc] init];
        [sharedInstance initAPP];
    });
    
    return sharedInstance;
}

- (void)initAPP {
    [self userInfoFromLocal];
}

- (BOOL)isLogin {
    return self.userInfo != nil;
}

- (OOUserInfo *)loginUserInfo {
    return self.userInfo;
}

- (void)logout {
    self.userInfo = nil;
    
    [self saveUserInfoToLocal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PREF_KEY_USER_LOGOUT object:nil];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password completeBlock:(OOCompleteBlock)completeBlock {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:account forKey:@"username"];
    [param setValue:password forKey:@"userpassword"];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_user_Iuserlogin parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            NSDictionary *data = [response xyDictionaryForKey:@"data"];
            OOUserInfo *info = [OOUserInfo yy_modelWithJSON:data];
            self.userInfo = info;
            [self saveUserInfoToLocal];
        }
        
        if (completeBlock) {
            completeBlock(success);
        }
    }];
}

- (void)refreshUserInfoWithCompleteHandle:(void (^)(BOOL))completeHandle {
    if (![[OOUserMgr sharedMgr] isLogin]) {
        if (completeHandle) {
            completeHandle(YES);
        }
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_getUserInfo parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            NSDictionary *data = [response xyDictionaryForKey:@"data"];
            //xc
            {
                NSDictionary *XC = [data xyDictionaryForKey:@"XC"];
                if ([XC valueForKey:@"id"]) {
                    OOUnFinishedXCModel *model = [[OOUnFinishedXCModel alloc] init];
                    model.xc_id = [[XC valueForKey:@"id"] integerValue];
                    model.XCMC = [XC valueForKey:@"XCMC"];
                    model.XCR = [XC valueForKey:@"XCR"];
                    model.status = [[XC valueForKey:@"Status"] integerValue];
                    model.SJQ = [XC valueForKey:@"SJQ"];
                    model.SJZ = [XC valueForKey:@"SJZ"];
                    model.Stoptime = [XC valueForKey:@"Stoptime"];
    //                model.Stoptime = nil;
                    
                    [OOXCMgr sharedMgr].unFinishedXCModel = model;
                    
                    if (model.status == OOXCStatus_ing) {
                        [[OOXCMgr sharedMgr] startUpdatingLocation];
                    }else {
                        [[OOXCMgr sharedMgr] finishUpdatingLocation];
                    }
                }else {
                    [OOXCMgr sharedMgr].unFinishedXCModel = nil;
                }
            }
            //user
            {
                self.userInfo.UserName = [data valueForKey:@"UserName"];
                self.userInfo.Uzw = [data valueForKey:@"Uzw"];
            }
        }
        
        if (completeHandle) {
            completeHandle(YES);
        }
    }];
}

#pragma mark - 本地
- (void)saveUserInfoToLocal {
    NSString *json;
    if (self.userInfo) {
        NSDictionary *dic = [self.userInfo yy_modelToJSONObject];
        json = [dic xy_getJSONString];
    }else {
        json = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:json forKey:@"k_pref_mini_login_userinfo"];
}

- (void)userInfoFromLocal {
    NSString *json = [[NSUserDefaults standardUserDefaults] valueForKey:@"k_pref_mini_login_userinfo"];
    NSDictionary *dic = [json xy_getObjectFromJSONString];
    
    if (dic) {
        self.userInfo = [OOUserInfo yy_modelWithJSON:dic];
    }
}

@end
