//
//  OOPhotoPickCell.h
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOPhotoPickModel.h"

typedef void(^ClickCloseBtnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface OOPhotoPickCell : UICollectionViewCell

@property (nonatomic, copy) ClickCloseBtnBlock clickCloseBlock;

- (void)configCellWithAsset:(OOAssetModel *)model;

@end

NS_ASSUME_NONNULL_END
