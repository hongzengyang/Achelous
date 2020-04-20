//
//  OOCheckBoxCell.h
//  Achelous
//
//  Created by hzy on 2020/4/15.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOCheckBoxCell : UITableViewCell

- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
