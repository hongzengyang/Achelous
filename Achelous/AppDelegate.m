//
//  AppDelegate.m
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import "AppDelegate.h"
#import "OONavigationController.h"
#import "OOHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    OOHomeVC *viewController = [[OOHomeVC alloc] init];
    OONavigationController *nav = [[OONavigationController alloc] initWithRootViewController:viewController];
    //设置主界面并显示
    [self.window makeKeyAndVisible];
    self.window.rootViewController = nav;
    
    
    return YES;
}


@end
