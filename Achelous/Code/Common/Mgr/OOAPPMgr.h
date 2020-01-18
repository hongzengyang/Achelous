//
//  OOAPPMgr.h
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOAPPMgr : NSObject

@property (nonatomic, assign) CGFloat safeTopArea;
@property (nonatomic, assign) CGFloat safeBottomArea;

@property (nonatomic, copy) NSString *currentXCID;

+ (OOAPPMgr *)sharedMgr;

- (NSString *)deviceID;
- (NSString *)appVersion;

@end

NS_ASSUME_NONNULL_END
