//
//  OOHomeCollectionView.h
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OOHomeCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout model:(OOHomeModel *)model;

@end

NS_ASSUME_NONNULL_END
