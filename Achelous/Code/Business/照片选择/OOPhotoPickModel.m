//
//  OOPhotoPickModel.m
//  Achelous
//
//  Created by hzy on 2020/3/5.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOPhotoPickModel.h"

@implementation OOAssetModel

@end

@implementation OOPhotoPickModel
- (instancetype)init {
    if (self = [super init]) {        
        _assetsArray = [[NSMutableArray alloc] init];
        OOAssetModel *temp = [[OOAssetModel alloc] init];
        [_assetsArray addObject:temp];
    }
    return self;
}

@end
