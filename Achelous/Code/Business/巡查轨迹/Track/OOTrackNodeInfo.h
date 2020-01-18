//
//  OOTrackNodeInfo.h
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOTrackNodeInfo : NSObject

@property (nonatomic, copy) NSString *roadName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locTime;

@end

NS_ASSUME_NONNULL_END
