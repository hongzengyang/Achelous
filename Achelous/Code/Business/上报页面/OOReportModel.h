//
//  OOReportModel.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOReportModel : NSObject

@property (nonatomic, assign) NSInteger typeIndex;   //四乱事件0 污染事件1 险情事件2 巡查实况3
@property (nonatomic, copy) NSString *categoryText;
@property (nonatomic, copy) NSString *nameText;
@property (nonatomic, copy) NSString *placeText;
@property (nonatomic, copy) NSMutableArray *photoPathArray;

@property (nonatomic, strong) NSMutableArray *uploadPhotoPathArray;

@property (nonatomic, strong) NSMutableArray *serverReturnPhotoPathArray;

@end

NS_ASSUME_NONNULL_END
