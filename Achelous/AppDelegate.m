//
//  AppDelegate.m
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import "AppDelegate.h"
#import "OONavigationController.h"
#import "MDPageMaster.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    [self setupPageMaster];
    
    return YES;
}

- (void)setupPageMaster {
    //设置根导航
    NSDictionary *params = @{@"schema":@"xiaoying",
                             @"pagesFile":@"urlmapping",
                             @"rootVC":@"OOLoginVC"};
    [[MDPageMaster master] setupNavigationControllerWithParams:params];
    [MDPageMaster master].navigationContorller.view.backgroundColor = [UIColor whiteColor];
    [MDPageMaster master].navigationContorller.navigationBar.hidden = YES;
    self.window.rootViewController = [MDPageMaster master].navigationContorller;
}


@end
