//
//  OOHomeCollectionView.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeCollectionView.h"
#import "OOHomeCollectionCell.h"
#import "OORefreshHeader.h"
#import "MDPageMaster.h"

@interface OOHomeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) OOHomeModel *homeModel;

@end

@implementation OOHomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout model:(nonnull OOHomeModel *)model {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.homeModel = model;
        
        self.contentInset = UIEdgeInsetsMake(20, 15, 0, 15);
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[OOHomeCollectionCell class] forCellWithReuseIdentifier:@"OOHomeCollectionCell"];
        
        __weak typeof(self) weakSelf = self;
        self.mj_header = [OORefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.homeModel fetchHomeData];
        }];
        self.mj_header.mj_w = self.width - self.contentInset.left - self.contentInset.right;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDataRefreshFinished) name:PREF_KEY_HOME_DATA_FRESH_FINISH object:nil];
    }
    return self;
}

#pragma mark -- 通知
- (void)homeDataRefreshFinished {
    [self reloadData];
    
    [self.mj_header endRefreshing];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([OOXCMgr sharedMgr].unFinishedXCModel) {
            [[MDPageMaster master] openUrl:@"xiaoying://oo_patrol_vc" action:^(MDUrlAction * _Nullable action) {
                
            }];
        }else {
            [[MDPageMaster master] openUrl:@"xiaoying://oo_createxc_vc" action:^(MDUrlAction * _Nullable action) {
                
            }];
        }
    }else if (indexPath.row == 1) {
        [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_track_page_vc" action:^(MDUrlAction * _Nullable action) {
            
        }];
    }else if (indexPath.row == 3 || indexPath.row == 10) {
        OOHomeDataMenuModel *model = [self.homeModel.dataModel.menuList objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@",model.url,[[OOUserMgr sharedMgr] loginUserInfo].UserId];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_h5_vc" action:^(MDUrlAction * _Nullable action) {
            [action setString:url forKey:@"linkUrl"];
            [action setString:model.name forKey:@"titleText"];
        }];
    }else {
        OOHomeDataMenuModel *model = [self.homeModel.dataModel.menuList objectAtIndex:indexPath.row];
        [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_h5_vc" action:^(MDUrlAction * _Nullable action) {
            [action setString:model.url forKey:@"linkUrl"];
            [action setString:model.name forKey:@"titleText"];
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeModel.dataModel.menuList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OOHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OOHomeCollectionCell" forIndexPath:indexPath];
    OOHomeDataMenuModel *model = [self.homeModel.dataModel.menuList objectAtIndex:indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake((self.width - self.contentInset.left - self.contentInset.right - 40) / 3, 120);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
