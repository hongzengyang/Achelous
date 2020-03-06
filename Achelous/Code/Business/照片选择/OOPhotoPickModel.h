//
//  OOPhotoPickModel.h
//  Achelous
//
//  Created by hzy on 2020/3/5.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *localCopyPath;
@property (nonatomic, copy) NSString *remoteUrl;

@end

@interface OOPhotoPickModel : NSObject
@property (nonatomic, strong) NSMutableArray <OOAssetModel *>*assetsArray;
@end

NS_ASSUME_NONNULL_END
