//
//  OOCreateXCTableViewCell.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOCreateXCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OOCreateXCTableViewCell : UITableViewCell

@property (nonatomic, strong) OOCreateXCModel *model;
@property (nonatomic, weak) UITableView *preTableView;

- (void)configCellWithType:(OOCreateXCType)type;

@end

NS_ASSUME_NONNULL_END
