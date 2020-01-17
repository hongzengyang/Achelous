//
//  OOAPPMgr.m
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOAPPMgr.h"

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
}

- (NSString *)deviceID {
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceID;
}

- (NSString *)appVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

@end
