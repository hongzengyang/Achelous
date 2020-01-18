//
//  OOXCTrackPageModel.h
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOXCTrackPageModel : NSObject

@property (nonatomic, copy) NSString *XCMC;
@property (nonatomic, copy) NSString *SJQ;
@property (nonatomic, copy) NSString *SJZ;
@property (nonatomic, copy) NSString *XCR;
@property (nonatomic, assign) long modelID;

@end

NS_ASSUME_NONNULL_END
