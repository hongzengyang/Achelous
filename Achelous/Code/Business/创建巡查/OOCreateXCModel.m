//
//  OOCreateXCModel.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCModel.h"
#import <YYModel/YYModel.h>
@implementation OOXCAreaModel

@end

@implementation OOXCObjectModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"objectID" : @"ID",
             @"SKMC" : @"SKMC"
    };
}

@end

@implementation OOXCJoinPartModel


@end

@implementation OOXCJoinPeopleModel


@end

@implementation OOCreateXCModel
- (instancetype)init {
    if (self = [super init]) {
        self.weatherList = @[@"晴",@"阴",@"降雨",@"降雪"];
        self.lakeTypeList = @[@"湖库",@"渠道",@"河段",@"坝塘"];
        self.selectjoinPartList = [[NSMutableArray alloc] init];
        self.selectjoinPeopleList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
