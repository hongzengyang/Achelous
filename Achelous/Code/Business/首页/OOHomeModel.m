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

- (NSMutableArray<OOHomeDataMenuModel *> *)menuList {
    if (!_menuList) {
        _menuList = [[NSMutableArray alloc] init];
    }
    return _menuList;
}

@end

@implementation OOHomeModel
- (void)fetchHomeData {
    {
        if (!CHECK_NWTWORK(YES)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PREF_KEY_HOME_DATA_FRESH_FINISH object:nil userInfo:nil];
            return;
        }
        
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
            [[NSNotificationCenter defaultCenter] postNotificationName:PREF_KEY_HOME_DATA_FRESH_FINISH object:nil userInfo:nil];
        }];
    }
    
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_getUserInfo parameters:param options:nil block:^(BOOL success, id response) {
            if (success) {
                NSDictionary *data = [response xyDictionaryForKey:@"data"];
                NSDictionary *XC = [data xyDictionaryForKey:@"XC"];
                if ([XC valueForKey:@"id"]) {
                    OOUnFinishedXCModel *model = [[OOUnFinishedXCModel alloc] init];
                    model.xc_id = [[XC valueForKey:@"id"] integerValue];
                    model.XCMC = [XC valueForKey:@"XCMC"];
                    model.XCR = [XC valueForKey:@"XCR"];
                    model.status = [[XC valueForKey:@"Status"] integerValue];
                    model.SJQ = [XC valueForKey:@"SJQ"];
                    model.SJZ = [XC valueForKey:@"SJZ"];
                    
                    [OOXCMgr sharedMgr].unFinishedXCModel = model;
                }else {
                    [OOXCMgr sharedMgr].unFinishedXCModel = nil;
                }
            }
        }];
    }
}

- (OOHomeDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[OOHomeDataModel alloc] init];
    }
    return _dataModel;
}

@end
