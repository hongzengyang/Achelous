//
//  OOHomeHeaderTypeView.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOHomeHeaderTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)strTitle;

- (void)updateCount:(NSString *)strCount;

@end

NS_ASSUME_NONNULL_END
