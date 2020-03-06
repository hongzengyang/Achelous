//
//  OOLocalNotificationMgr.h
//  Achelous
//
//  Created by hzy on 2020/3/6.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOLocalNotificationMgr : NSObject

+ (OOLocalNotificationMgr *)sharedMgr;

- (void)sendNotification;

@end

NS_ASSUME_NONNULL_END
