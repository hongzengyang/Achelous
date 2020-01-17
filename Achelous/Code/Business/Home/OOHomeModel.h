//
//  OOHomeModel.h
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOHomeDataMenuModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;

@end

@interface OOHomeDataModel : NSObject

@property (nonatomic, copy) NSString *SLinfo;
@property (nonatomic, copy) NSString *WRinfo;
@property (nonatomic, copy) NSString *XQinfo;
@property (nonatomic, copy) NSString *JBinfo;

@property (nonatomic, strong) NSMutableArray <OOHomeDataMenuModel *>*menuList;

@end

@interface OOHomeModel : NSObject

@property (nonatomic, strong) OOHomeDataModel *dataModel;

- (void)fetchHomeDataWithCompleteBlock:(OOCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
