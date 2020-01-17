//
//  OOHomeModel.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeModel.h"
#import "OOUserMgr.h"
#import <YYModel/YYModel.h>

@implementation OOHomeDataMenuModel

@end

@implementation OOHomeDataModel

- (NSDictionary *)modelCustomPropertyMapper {
    return @{@"SLinfo" : @"SLinfo",
             @"WRinfo" : @"WRinfo",
             @"XQinfo" : @"XQinfo",
             @"JBinfo" : @"JBinfo",
             @"menuList" : @"menu"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"menuList" : [OOHomeDataMenuModel class]};
}

@end

@implementation OOHomeModel
- (void)fetchHomeDataWithCompleteBlock:(OOCompleteBlock)completeBlock {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Appmenu parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            NSDictionary *data = [response xyDictionaryForKey:@"data"];
            self.dataModel.SLinfo = [data xyStringForKey:@"SLinfo"];
            self.dataModel.WRinfo = [data xyStringForKey:@"WRinfo"];
            self.dataModel.XQinfo = [data xyStringForKey:@"XQinfo"];
            self.dataModel.JBinfo = [data xyStringForKey:@"JBinfo"];
            
            [self.dataModel.menuList removeAllObjects];
            NSArray *array = [data xyArrayForKey:@"menu"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    OOHomeDataMenuModel *model = [OOHomeDataMenuModel yy_modelWithJSON:dic];
                    [self.dataModel.menuList addObject:model];
                }
            }];
        }
        
        if (completeBlock) {
            completeBlock(success);
        }
    }];
}

- (OOHomeDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[OOHomeDataModel alloc] init];
    }
    return _dataModel;
}

@end
