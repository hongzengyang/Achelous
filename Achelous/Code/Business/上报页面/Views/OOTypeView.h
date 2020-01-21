//
//  OOTypeView.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOReportModel.h"


typedef NS_ENUM(NSUInteger, OOTypeViewType) {
    OOTypeViewType_type,
    OOTypeViewType_category,
    OOTypeViewType_name,
    OOTypeViewType_place,
    OOTypeViewType_photo
};

NS_ASSUME_NONNULL_BEGIN

@interface OOTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(OOTypeViewType)type model:(OOReportModel *)model;

- (void)update;

@end

NS_ASSUME_NONNULL_END
