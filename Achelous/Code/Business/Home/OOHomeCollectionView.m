//
//  OOHomeCollectionView.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeCollectionView.h"

@interface OOHomeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) OOHomeModel *homeModel;

@end

@implementation OOHomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout model:(nonnull OOHomeModel *)model {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.homeModel = model;
    }
    return self;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return <#count#>;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return <#cell#>;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return <#count#>;
//}

#pragma mark -- UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return <#size#>;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return <#float#>;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return <#float#>;
//}

@end
