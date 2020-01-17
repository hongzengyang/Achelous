//
//  UIApplication+XYState.m
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import "UIApplication+XYState.h"
#import "pthread.h"

@implementation UIApplication (XYState)

- (BOOL)xy_isForegroundState {
    __block BOOL b = YES;
    if (pthread_main_np()) {
        b = self.applicationState == UIApplicationStateActive;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            b = self.applicationState == UIApplicationStateActive;
        });
    }
    
    return b;
}

@end
