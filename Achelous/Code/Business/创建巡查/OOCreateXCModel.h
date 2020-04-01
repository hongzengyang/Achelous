//
//  OOCreateXCModel.h
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OOXCAreaModel : NSObject

@property (nonatomic, copy) NSString *ADNM; //武定县辖区
@property (nonatomic, copy) NSString *ADID; //532329009000000

@end

@interface OOXCObjectModel : NSObject

@property (nonatomic, assign) long objectID;
@property (nonatomic, copy) NSString *SKMC;

@end

@interface OOXCJoinPartModel : NSObject

@property (nonatomic, copy) NSString *Dpcode; //100001
@property (nonatomic, copy) NSString *Dpnm; //县委

@end

@interface OOXCContentModel : NSObject

@property (nonatomic, copy) NSString *contentID; 
@property (nonatomic, copy) NSString *XCNR;

@end

@interface OOXCJoinPeopleModel : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *RealName; //县委

@end

NS_ASSUME_NONNULL_BEGIN

@interface OOCreateXCModel : NSObject
@property (nonatomic, strong) NSArray *weatherList;
@property (nonatomic, copy) NSString *weather;

@property (nonatomic, strong) NSArray *lakeTypeList;
@property (nonatomic, copy) NSString *lakeType;

@property (nonatomic, strong) NSArray <OOXCAreaModel *>*xcAreaList;
@property (nonatomic, strong) OOXCAreaModel *xcAreaModel;

@property (nonatomic, strong) NSArray <OOXCObjectModel *>*xcObjectList;
@property (nonatomic, strong) OOXCObjectModel *xcObject;

@property (nonatomic, copy) NSString *xcName;

@property (nonatomic, strong) NSArray <OOXCContentModel *>*contentList;
@property (nonatomic, strong) NSMutableArray <OOXCContentModel *>*selectContentList;

@property (nonatomic, strong) NSArray <OOXCJoinPartModel *>*joinPartList;
@property (nonatomic, strong) NSMutableArray <OOXCJoinPartModel *>*selectjoinPartList;

@property (nonatomic, strong) NSArray <OOXCJoinPeopleModel *>*joinPeopleList;
@property (nonatomic, strong) NSMutableArray <OOXCJoinPeopleModel *>*selectjoinPeopleList;

@end

NS_ASSUME_NONNULL_END
