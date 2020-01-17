//
//  OOHomeVC.m
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import "OOHomeVC.h"
#import "OOAPPMgr.h"
#import "OOHomeNavBar.h"
#import "OOHomeHeaderView.h"
#import "OOHomeCollectionView.h"
#import "OOHomeModel.h"


@interface OOHomeVC ()
@property (nonatomic, strong) OOHomeNavBar *navBar;
@property (nonatomic, strong) OOHomeHeaderView *headerView;
@property (nonatomic, strong) OOHomeCollectionView *collectionView;

@property (nonatomic, strong) OOHomeModel *homeModel;

@end

@implementation OOHomeVC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navBar];
}

- (OOHomeNavBar *)navBar {
    if (!_navBar) {
        _navBar = [[OOHomeNavBar alloc] initWithFrame:CGRectMake(0, SAFE_TOP, SCREEN_WIDTH, 44)];
        _navBar.backgroundColor = [UIColor clearColor];
    }
    return _navBar;
}

- (OOHomeHeaderView *)headerView  {
    if (!_headerView) {
        _headerView = [[OOHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) model:self.homeModel];
        _headerView.backgroundColor = [UIColor grayColor];
    }
    return _headerView;
}

- (OOHomeCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[OOHomeCollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.headerView.bottom - SAFE_BOTTOM) collectionViewLayout:[UICollectionViewFlowLayout new] model:self.homeModel];
        _collectionView.backgroundColor = [UIColor yellowColor];
    }
    return _collectionView;
}

- (OOHomeModel *)homeModel {
    if (!_homeModel) {
        _homeModel = [[OOHomeModel alloc] init];
    }
    return _homeModel;
}

@end
