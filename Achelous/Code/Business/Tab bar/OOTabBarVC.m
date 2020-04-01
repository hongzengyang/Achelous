//
//  OOTabBarVC.m
//  Achelous
//
//  Created by hzy on 2020/4/1.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOTabBarVC.h"
#import "OOHomeVC.h"
#import "OOUserCenterVC.h"
#import "OOTabBar.h"

@interface OOTabBarVC ()
@property (nonatomic, strong) OOTabBar *oo_tabBar;
@end

@implementation OOTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configTabBar];
    [self configViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBar.hidden = YES;
}

#pragma mark - init
- (void)configTabBar {
    self.oo_tabBar = [[OOTabBar alloc] initWithFrame:CGRectMake(0, self.view.height - SAFE_BOTTOM - TABBAR_HEIGHT, self.view.width, TABBAR_HEIGHT + SAFE_BOTTOM)];
    __weak typeof(self) weakSelf = self;
    [self.oo_tabBar handleTabBarClickBlock:^(NSInteger index) {
        weakSelf.selectedIndex = index;
    }];
    [self.view addSubview:self.oo_tabBar];
}

- (void)configViewControllers {
    if (self.viewControllers.count > 0) {
        return;
    }
    
    OOHomeVC *homeVC = [[OOHomeVC alloc] init];
    OOUserCenterVC *userCenterVC = [[OOUserCenterVC alloc] init];
    
    self.viewControllers = @[homeVC, userCenterVC];
}

@end
