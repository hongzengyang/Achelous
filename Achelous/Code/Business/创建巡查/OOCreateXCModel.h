//
//  OOCreateXCModel.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OOCreateTypeSubType) {
    OOCreateTypeSubType_none = -1,
    OOCreateTypeSubType_huku = 0,
    OOCreateTypeSubType_qudao = 1,
    OOCreateTypeSubType_heduan = 2,
};

@interface OOXCObjectModel : NSObject

@property (nonatomic, assign) long objectID;
@property (nonatomic, copy) NSString *SKMC;

@end

typedef NS_ENUM(NSUInteger, OOCreateXCType) {
    OOCreateXCType_default,
    OOCreateXCType_type,
    OOCreateXCType_object,
    OOCreateXCType_name,
    OOCreateXCType_people,
    OOCreateXCType_startTime,
    OOCreateXCType_owner,
};

NS_ASSUME_NONNULL_BEGIN

@interface OOCreateXCModel : NSObject

@property (nonatomic, assign) OOCreateXCType currentSelectType;

@property (nonatomic, strong) NSMutableArray <OOXCObjectModel *>*xc_objectList;

@property (nonatomic, assign) OOCreateTypeSubType xc_type;
@property (nonatomic, strong) OOXCObjectModel *xc_object;
@property (nonatomic, copy) NSString *xc_name;
@property (nonatomic, copy) NSString *xc_people;
@property (nonatomic, copy) NSString *xc_owner;

@end

NS_ASSUME_NONNULL_END
