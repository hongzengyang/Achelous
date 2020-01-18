//
//  OOHomeCollectionCell.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OOHomeCollectionCell : UICollectionViewCell

- (void)updateCellWithModel:(OOHomeDataMenuModel *)model;

@end

NS_ASSUME_NONNULL_END
