//
//  OOXCLiveModel.m
//  Achelous
//
//  Created by hzy on 2020/3/5.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCLiveModel.h"

@implementation OOXCLiveModel
- (instancetype)init {
    if (self = [super init]) {
        self.photoPickModel = [[OOPhotoPickModel alloc] init];
        self.name = @"";
        self.place = @"";
        self.desc = @"";
    }
    return self;
}

@end
