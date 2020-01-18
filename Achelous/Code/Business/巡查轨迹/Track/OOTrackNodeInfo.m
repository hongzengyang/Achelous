//
//  OOTrackNodeInfo.m
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOTrackNodeInfo.h"

@implementation OOTrackNodeInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"roadName" : @"roadName",
             @"createTime" : @"createTime",
             @"speed" : @"speed",
             @"location" : @"location",
             @"locTime" : @"locTime"
    };
}

@end
