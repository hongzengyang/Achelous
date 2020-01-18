//
//  OOCreateXCModel.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCModel.h"
#import <YYModel/YYModel.h>


@implementation OOXCObjectModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"objectID" : @"ID",
             @"SKMC" : @"SKMC"
    };
}

@end

@implementation OOCreateXCModel
- (instancetype)init {
    if (self = [super init]) {
        self.xc_type = OOCreateTypeSubType_none;
        self.xc_objectList = [[NSMutableArray alloc] init];
        
        self.xc_people = @"app测试";
        self.xc_owner = @"app测试";
    }
    return self;
}

@end
