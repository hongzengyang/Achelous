//
//  OOCreateXCTableView.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOCreateXCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OOCreateXCTableView : UITableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style model:(OOCreateXCModel *)model;

@end

NS_ASSUME_NONNULL_END
