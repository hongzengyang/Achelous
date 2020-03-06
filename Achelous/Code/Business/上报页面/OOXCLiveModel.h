//
//  OOXCLiveModel.h
//  Achelous
//
//  Created by hzy on 2020/3/5.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOPhotoPickModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OOXCLiveModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *place;
//@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) OOPhotoPickModel *photoPickModel;

@end

NS_ASSUME_NONNULL_END
