//
//  OOFindQuestionModel.m
//  Achelous
//
//  Created by hzy on 2020/3/5.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOFindQuestionModel.h"

@implementation OOFindQuestionModel
- (instancetype)init {
    if (self = [super init]) {
        self.photoPickModel = [[OOPhotoPickModel alloc] init];
        self.place = @"";
        self.name = @"";
        self.desc = @"";
        self.analyze = @"";
    }
    return self;
}

@end
