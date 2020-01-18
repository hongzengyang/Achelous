//
//  OOXCTrackPageModel.m
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCTrackPageModel.h"

@implementation OOXCTrackPageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"SJQ" : @"SJQ",
             @"XCMC" : @"XCMC",
             @"SJZ" : @"SJZ",
             @"XCR" : @"XCR",
             @"modelID" : @"id"
    };
}

@end
