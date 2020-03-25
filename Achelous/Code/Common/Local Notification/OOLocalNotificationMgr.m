//
//  OOLocalNotificationMgr.m
//  Achelous
//
//  Created by hzy on 2020/3/6.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOLocalNotificationMgr.h"
#import <UserNotifications/UserNotifications.h>

@interface OOLocalNotificationMgr ()<UNUserNotificationCenterDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, copy) NSString *localNotiReqIdentifer;

@end

@implementation OOLocalNotificationMgr
+ (OOLocalNotificationMgr *)sharedMgr {
    static OOLocalNotificationMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[OOLocalNotificationMgr alloc] init];
        [sharedInstance initLocalNotification];
    });
    
    return sharedInstance;
}

- (void)initLocalNotification {
    self.localNotiReqIdentifer = @"localNotiReqIdentifer";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pref_key_notification_interval"]) {
        self.notificationInterval = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pref_key_notification_interval"] integerValue];
    }
    
    [self registerLocalNotification];
}

- (void)registerLocalNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)sendNotification {
    NSInteger minute = [OOXCMgr sharedMgr].xcDuration / 60;
    
    NSString *title = @"河长制";
    NSString *subtitle = nil;
    NSString *body = [NSString stringWithFormat:@"巡查已经进行了%ld分钟",(long)minute];
    NSInteger badge = 1;
    NSInteger timeInteval = 1;
    NSDictionary *userInfo = @{@"id":@"LOCAL_NOTIFY_SCHEDULE_ID"};

    if (@available(iOS 10.0, *)) {
        // 1.创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
        content.sound = [UNNotificationSound defaultSound];
        content.title = title;
        content.subtitle = subtitle;
        content.body = body;
        content.badge = @(badge);

        content.userInfo = userInfo;

        // 2.设置通知附件内容
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"oo_app_not__icon@2x" ofType:@"png"];
        UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
        if (error) {
            NSLog(@"attachment error %@", error);
        }
        content.attachments = @[att];
        content.launchImageName = @"icon_certification_status1@2x";
        // 2.设置声音
        UNNotificationSound *sound = [UNNotificationSound defaultSound];// [UNNotificationSound defaultSound];
        content.sound = sound;

        // 3.触发模式
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInteval repeats:NO];

        // 4.设置UNNotificationRequest
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:self.localNotiReqIdentifer content:content trigger:trigger];

        // 5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];

    } else {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        // 1.设置触发时间（如果要立即触发，无需设置）
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        
        // 2.设置通知标题
        localNotification.alertBody = title;
        
        // 3.设置通知动作按钮的标题
        localNotification.alertAction = @"查看";
        
        // 4.设置提醒的声音
        localNotification.soundName = UILocalNotificationDefaultSoundName;// UILocalNotificationDefaultSoundName;
        
        // 5.设置通知的 传递的userInfo
        localNotification.userInfo = userInfo;
        
        // 6.在规定的日期触发通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        // 6.立即触发一个通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

#pragma mark -- Setter
- (void)setNotificationInterval:(NSInteger)notificationInterval {
    _notificationInterval = notificationInterval;
    
    [[NSUserDefaults standardUserDefaults] setValue:@(notificationInterval) forKey:@"pref_key_notification_interval"];
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
