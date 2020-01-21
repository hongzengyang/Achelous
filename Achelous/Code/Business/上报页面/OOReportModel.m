//
//  OOReportModel.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOReportModel.h"

@implementation OOReportModel
- (NSMutableArray *)photoPathArray {
    if (!_photoPathArray) {
        _photoPathArray = [[NSMutableArray alloc] init];
        [_photoPathArray addObject:@""];
        
        _uploadPhotoPathArray = [[NSMutableArray alloc] init];
        
        _serverReturnPhotoPathArray = [[NSMutableArray alloc] init];
    }
    return _photoPathArray;
}

@end
