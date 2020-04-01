//
//  OOTabBar.h
//  Achelous
//
//  Created by hzy on 2020/4/1.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTabBarBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface OOTabBar : UIView

- (void)handleTabBarClickBlock:(ClickTabBarBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
