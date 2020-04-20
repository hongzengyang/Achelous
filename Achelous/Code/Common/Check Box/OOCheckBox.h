//
//  OOCheckBox.h
//  Achelous
//
//  Created by hzy on 2020/4/15.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dismissBlock)(NSArray <NSString *>*selectDataList);

NS_ASSUME_NONNULL_BEGIN

@interface OOCheckBox : UIView
+ (void)configWithDataList:(NSArray *)dataList
               multiSelect:(BOOL)multiSelect
          selectedDataList:(NSArray *)selectedDataList
                  boxTitle:(NSString *)title
              dismissBlock:(dismissBlock)dismissBlock;

@end

NS_ASSUME_NONNULL_END
