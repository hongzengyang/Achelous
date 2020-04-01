//
//  OOCreateXCVC.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCVC.h"
#import "OOCreateXCModel.h"
#import "OOPatrolVC.h"
#import <YYModel/YYModel.h>
#import <WMZDialog/WMZDialog.h>

@interface OOCreateXCVC ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *navBar;
//@property (nonatomic, strong) OOCreateXCTableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *weatherView;   //天气
@property (nonatomic, strong) UILabel *weatherLab;
@property (nonatomic, strong) UIView *lakeTypeView;  //河湖类型
@property (nonatomic, strong) UILabel *lakeTypeLab;
@property (nonatomic, strong) UIView *xcAreaView;    //巡查区域
@property (nonatomic, strong) UILabel *xcAreaLab;
@property (nonatomic, strong) UIView *xcObjectView;  //巡查对象
@property (nonatomic, strong) UILabel *xcObjectLab;
@property (nonatomic, strong) UIView *xcNameView;    //巡查名称
@property (nonatomic, strong) UITextField *xcNameTextField;
@property (nonatomic, strong) UIView *xcContentView;  //巡查内容
@property (nonatomic, strong) UILabel *xcContentLab;
@property (nonatomic, strong) UIView *joinPartView;  //参与单位
@property (nonatomic, strong) UILabel *joinPartLab;
@property (nonatomic, strong) UIView *joinPeopleView;//参与人员
@property (nonatomic, strong) UILabel *joinPeopleLab;
@property (nonatomic, strong) UIView *xcQTPeopleView; //巡查内容
@property (nonatomic, strong) UITextView *xcQTPeopleTextView;
@property (nonatomic, strong) UIView *startTimeView; //开始时间
@property (nonatomic, strong) UILabel *startTimeLab;
@property (nonatomic, strong) OOCreateXCModel *model;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *contentFont;

@end

@implementation OOCreateXCVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    self.contentFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    [self.view addSubview:self.navBar];
//    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.weatherView];
    [self.scrollView addSubview:self.lakeTypeView];
    [self.scrollView addSubview:self.xcAreaView];
    [self.scrollView addSubview:self.xcObjectView];
    [self.scrollView addSubview:self.xcNameView];
    [self.scrollView addSubview:self.xcContentView];
    [self.scrollView addSubview:self.joinPartView];
    [self.scrollView addSubview:self.joinPeopleView];
    [self.scrollView addSubview:self.xcQTPeopleView];
    [self.scrollView addSubview:self.startTimeView];
    [self.scrollView setContentSize:CGSizeMake(self.view.width, self.startTimeView.bottom)];
    
    self.model.weather = [self.model.weatherList firstObject];
    [self updateData];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    if ([NSString xy_isEmpty:self.model.weather]) {
        [SVProgressHUD showErrorWithStatus:@"请选择天气"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.lakeType]) {
        [SVProgressHUD showErrorWithStatus:@"请选择河湖类型"];
        return;
    }
    if (!self.model.xcAreaModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查区域"];
        return;
    }
    
    if (!self.model.xcObject) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查对象"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.xcName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入巡查名称"];
        return;
    }
    
    if (self.model.selectContentList.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查内容"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].AreaCode forKey:@"AreaCode"];
    [param setValue:self.model.xcObject.SKMC forKey:@"Hkname"];
    [param setValue:@(self.model.xcObject.objectID) forKey:@"ID"];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@([self.model.weatherList indexOfObject:self.model.weather]) forKey:@"Weather"];
    [param setValue:self.model.xcName forKey:@"XCname"];
    [param setValue:@([self.model.lakeTypeList indexOfObject:self.model.lakeType]) forKey:@"Xclx"];
    [param setValue:self.xcQTPeopleTextView.text forKey:@"Qtuser"];
    
    {
        //巡查内容
        __block NSString *contentID = @"";
        [self.model.selectContentList enumerateObjectsUsingBlock:^(OOXCContentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            contentID = [contentID stringByAppendingString:obj.contentID];
            if (idx != self.model.selectContentList.count - 1) {
                contentID = [contentID stringByAppendingString:@","];
            }
        }];
        [param setValue:contentID forKey:@"Xccontent"];
    }
    
    {
        //参与单位
        __block NSString *xcdw = @"";
        [self.model.selectjoinPartList enumerateObjectsUsingBlock:^(OOXCJoinPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            xcdw = [xcdw stringByAppendingString:obj.Dpcode];
            if (idx != self.model.selectjoinPartList.count - 1) {
                xcdw = [xcdw stringByAppendingString:@","];
            }
        }];
        [param setValue:xcdw forKey:@"Xcdw"];
    }
    {
        //参与人员
        __block NSString *xcuser = @"";
        [self.model.selectjoinPeopleList enumerateObjectsUsingBlock:^(OOXCJoinPeopleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            xcuser = [xcuser stringByAppendingString:obj.UserId];
            if (idx != self.model.selectjoinPeopleList.count - 1) {
                xcuser = [xcuser stringByAppendingString:@","];
            }
        }];
        [param setValue:xcuser forKey:@"Xcuser"];
    }
    
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_createXC parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD dismiss];
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                NSDictionary *data = [dic xyDictionaryForKey:@"data"];
                
                if ([data valueForKey:@"id"]) {
                    OOUnFinishedXCModel *model = [[OOUnFinishedXCModel alloc] init];
                    model.xc_id = [[data valueForKey:@"id"] integerValue];
                    model.XCMC = self.model.xcName;
                    model.XCR = [[OOUserMgr sharedMgr] loginUserInfo].UserId;
                    model.status = OOXCStatus_notBegin;
                    
                    [OOXCMgr sharedMgr].unFinishedXCModel = model;
                }
                [[MDPageMaster master] openUrl:@"xiaoying://oo_patrol_vc" action:^(MDUrlAction * _Nullable action) {
                    
                }];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
        }
    }];
}

#pragma mark -- Tap
- (void)clickWeather {
    if ([self.xcNameTextField isFirstResponder] || [self.xcQTPeopleTextView isFirstResponder]) {
        [self.view endEditing:YES];
    }

    __weak typeof(self) weakSelf = self;
    Dialog()
    .wTypeSet(DialogTypeSelect)
    .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
        weakSelf.model.weather = anyID;
        [weakSelf updateData];
    })
    .wTitleSet(@"天气情况")
    .wTitleColorSet([UIColor blackColor])
    .wTitleFontSet(16.0)
    .wMessageSet(@"")
    .wMessageColorSet([UIColor appTextColor])
    .wMessageFontSet(15.0)
    .wDataSet(self.model.weatherList)
    .wStart();
}

- (void)clickLakeType {
    if ([self.xcNameTextField isFirstResponder] || [self.xcQTPeopleTextView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    if ([NSString xy_isEmpty:self.model.weather]) {
        [SVProgressHUD showErrorWithStatus:@"请输入天气"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    Dialog()
    .wTypeSet(DialogTypeSelect)
    .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
        weakSelf.model.lakeType = anyID;
        [weakSelf updateData];
    })
    .wTitleSet(@"河湖类型")
    .wTitleColorSet([UIColor blackColor])
    .wTitleFontSet(16.0)
    .wMessageSet(@"")
    .wMessageColorSet([UIColor appTextColor])
    .wMessageFontSet(15.0)
    .wDataSet(self.model.lakeTypeList)
    .wStart();
}

- (void)clickXcArea {
    if ([self.xcNameTextField isFirstResponder] || [self.xcQTPeopleTextView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    if ([NSString xy_isEmpty:self.model.weather]) {
        [SVProgressHUD showErrorWithStatus:@"请输入天气"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.lakeType]) {
        [SVProgressHUD showErrorWithStatus:@"请输入河湖类型"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void(^bottomSheetBlock)(void) = ^(void) {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.xcAreaList enumerateObjectsUsingBlock:^(OOXCAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.ADNM];
        }];
        
        if (titles.count > 0) {
            __weak typeof(self) weakSelf = self;
            Dialog()
            .wTypeSet(DialogTypeSelect)
            .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
                weakSelf.model.xcAreaModel = weakSelf.model.xcAreaList[path.row];
                [weakSelf updateData];
            })
            .wTitleSet(@"巡查区域")
            .wTitleColorSet([UIColor blackColor])
            .wTitleFontSet(16.0)
            .wMessageSet(@"")
            .wMessageColorSet([UIColor appTextColor])
            .wMessageFontSet(15.0)
            .wDataSet(titles)
            .wStart();
        }
    };
    
    if (self.model.xcAreaList.count == 0) {
        [self fetchXcAreaListWithCompeteHandle:^(BOOL complete) {
            if (complete) {
                bottomSheetBlock();
            }
        }];
        return;
    }
    
    bottomSheetBlock();
}

- (void)clickXcObject {
    if ([self.xcNameTextField isFirstResponder] || [self.xcQTPeopleTextView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    if ([NSString xy_isEmpty:self.model.weather]) {
        [SVProgressHUD showErrorWithStatus:@"请选择天气"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.lakeType]) {
        [SVProgressHUD showErrorWithStatus:@"请选择河湖类型"];
        return;
    }
    if (!self.model.xcAreaModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查区域"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void(^actionSheetBlock)(void) = ^ {
        NSMutableArray *array = [NSMutableArray new];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.xcObjectList enumerateObjectsUsingBlock:^(OOXCObjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.SKMC];
        }];
        
        if (titles.count > 0) {
            __weak typeof(self) weakSelf = self;
            Dialog()
            .wTypeSet(DialogTypeSelect)
            .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
                weakSelf.model.xcObject = weakSelf.model.xcObjectList[path.row];
                [weakSelf updateData];
            })
            .wTitleSet(@"巡查对象")
            .wTitleColorSet([UIColor blackColor])
            .wTitleFontSet(16.0)
            .wMessageSet(@"")
            .wMessageColorSet([UIColor appTextColor])
            .wMessageFontSet(15.0)
            .wDataSet(titles)
            .wStart();
        }
    };
    
    if (self.model.xcObjectList.count == 0) {
        [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [param setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[self.model.lakeTypeList indexOfObject:self.model.lakeType]] forKey:@"Xclx"];
        [param setValue:self.model.xcAreaModel.ADID forKey:@"ADID"];
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_returnhk parameters:param options:nil block:^(BOOL success, id response) {
            if (success) {
                [SVProgressHUD dismiss];
                if ([response isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)response;
                    NSArray *data = [dic xyArrayForKey:@"data"];
                    
                    if (data.count > 0) {
                        NSMutableArray *muArray = [[NSMutableArray alloc] init];
                        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *d = (NSDictionary *)obj;
                                OOXCObjectModel *model = [OOXCObjectModel yy_modelWithJSON:d];
                                [muArray addObject:model];
                            }
                        }];
                        weakSelf.model.xcObjectList = [muArray copy];
                    }
                }
                
                actionSheetBlock();
            }else {
                [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
            }
        }];
    }else {
        actionSheetBlock();
    }
}

- (void)clickXcName {
    
}

- (void)clickContent {
    __weak typeof(self) weakSelf = self;
    void(^actionSheetBlock)(void) = ^ {
        NSMutableArray *array = [NSMutableArray new];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.contentList enumerateObjectsUsingBlock:^(OOXCContentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.XCNR];
        }];
        if (titles.count > 0) {
            __weak typeof(self) weakSelf = self;
            Dialog()
            .wTypeSet(DialogTypeSelect)
            .wEventOKFinishSet(^(id anyID, id otherData) {
                if ([anyID isKindOfClass:[NSArray class]]) {
                    [weakSelf.model.selectContentList removeAllObjects];
                    NSArray *array = (NSArray *)anyID;
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSString class]]) {
                            NSString *string = (NSString *)obj;
                            [weakSelf.model.contentList enumerateObjectsUsingBlock:^(OOXCContentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj.XCNR isEqualToString:string]) {
                                    [weakSelf.model.selectContentList addObject:obj];
                                }
                            }];
                        }
                    }];
                }
                [weakSelf updateData];
            })
            .wTitleSet(@"巡查内容")
            .wTitleColorSet([UIColor blackColor])
            .wTitleFontSet(16.0)
            .wMessageSet(@"")
            .wMessageColorSet([UIColor appTextColor])
            .wMessageFontSet(15.0)
            .wMultipleSelectionSet(YES)
            .wSelectShowCheckedSet(YES)
            .wDataSet(titles)
            .wStart();
        }
    };
    
    if (self.model.contentList.count == 0) {
        [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_ReturnXC parameters:param options:nil block:^(BOOL success, id response) {
            if (success) {
                [SVProgressHUD dismiss];
                if ([response isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)response;
                    NSArray *data = [dic xyArrayForKey:@"data"];
                    
                    if (data.count > 0) {
                        NSMutableArray *muArray = [[NSMutableArray alloc] init];
                        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *d = (NSDictionary *)obj;
                                OOXCContentModel *model = [OOXCContentModel yy_modelWithJSON:d];
                                [muArray addObject:model];
                            }
                        }];
                        weakSelf.model.contentList = [muArray copy];
                    }
                }
                
                actionSheetBlock();
            }else {
                [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
            }
        }];
    }else {
        actionSheetBlock();
    }
}

- (void)clickJoinPart {
    __weak typeof(self) weakSelf = self;
    void(^actionSheetBlock)(void) = ^ {
        NSMutableArray *array = [NSMutableArray new];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.joinPartList enumerateObjectsUsingBlock:^(OOXCJoinPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.Dpnm];
        }];
        if (titles.count > 0) {
            __weak typeof(self) weakSelf = self;
            Dialog()
            .wTypeSet(DialogTypeSelect)
            .wEventOKFinishSet(^(id anyID, id otherData) {
                if ([anyID isKindOfClass:[NSArray class]]) {
                    [weakSelf.model.selectjoinPartList removeAllObjects];
                    NSArray *array = (NSArray *)anyID;
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSString class]]) {
                            NSString *string = (NSString *)obj;
                            [weakSelf.model.joinPartList enumerateObjectsUsingBlock:^(OOXCJoinPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj.Dpnm isEqualToString:string]) {
                                    [weakSelf.model.selectjoinPartList addObject:obj];
                                }
                            }];
                        }
                    }];
                }
                [weakSelf updateData];
            })
            .wTitleSet(@"参与单位")
            .wTitleColorSet([UIColor blackColor])
            .wTitleFontSet(16.0)
            .wMessageSet(@"")
            .wMessageColorSet([UIColor appTextColor])
            .wMessageFontSet(15.0)
            .wMultipleSelectionSet(YES)
            .wSelectShowCheckedSet(YES)
            .wDataSet(titles)
            .wStart();
        }
    };
    
    if (self.model.joinPartList.count == 0) {
        [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
        [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xccy parameters:param options:nil block:^(BOOL success, id response) {
            if (success) {
                [SVProgressHUD dismiss];
                if ([response isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)response;
                    NSArray *data = [dic xyArrayForKey:@"data"];
                    
                    if (data.count > 0) {
                        NSMutableArray *muArray = [[NSMutableArray alloc] init];
                        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *d = (NSDictionary *)obj;
                                OOXCJoinPartModel *model = [OOXCJoinPartModel yy_modelWithJSON:d];
                                [muArray addObject:model];
                            }
                        }];
                        weakSelf.model.joinPartList = [muArray copy];
                    }
                }
                
                actionSheetBlock();
            }else {
                [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
            }
        }];
    }else {
        actionSheetBlock();
    }
}

- (void)clickJoinPeople {
    if (self.model.selectjoinPartList.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择参与单位"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void(^actionSheetBlock)(void) = ^ {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.joinPeopleList enumerateObjectsUsingBlock:^(OOXCJoinPeopleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.RealName];
        }];
        if (titles.count > 0) {
            __weak typeof(self) weakSelf = self;
            Dialog()
            .wTypeSet(DialogTypeSelect)
            .wEventOKFinishSet(^(id anyID, id otherData) {
                if ([anyID isKindOfClass:[NSArray class]]) {
                    [weakSelf.model.selectjoinPeopleList removeAllObjects];
                    NSArray *array = (NSArray *)anyID;
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSString class]]) {
                            NSString *string = (NSString *)obj;
                            [weakSelf.model.joinPeopleList enumerateObjectsUsingBlock:^(OOXCJoinPeopleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj.RealName isEqualToString:string]) {
                                    [weakSelf.model.selectjoinPeopleList addObject:obj];
                                }
                            }];
                        }
                    }];
                }
                [weakSelf updateData];
            })
            .wTitleSet(@"参与人员")
            .wTitleColorSet([UIColor blackColor])
            .wTitleFontSet(16.0)
            .wMessageSet(@"")
            .wMessageColorSet([UIColor appTextColor])
            .wMessageFontSet(15.0)
            .wMultipleSelectionSet(YES)
            .wSelectShowCheckedSet(YES)
            .wDataSet(titles)
            .wStart();
        }
    };
    
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    {
        __block NSString *xcdw = @"";
        [self.model.selectjoinPartList enumerateObjectsUsingBlock:^(OOXCJoinPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            xcdw = [xcdw stringByAppendingString:obj.Dpcode];
            if (idx != self.model.selectjoinPartList.count - 1) {
                xcdw = [xcdw stringByAppendingString:@","];
            }
        }];
        [param setValue:xcdw forKey:@"Dpcode"];
    }
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xcuser parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD dismiss];
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                NSArray *data = [dic xyArrayForKey:@"data"];
                
                if (data.count > 0) {
                    NSMutableArray *muArray = [[NSMutableArray alloc] init];
                    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *d = (NSDictionary *)obj;
                            OOXCJoinPeopleModel *model = [OOXCJoinPeopleModel yy_modelWithJSON:d];
                            [muArray addObject:model];
                        }
                    }];
                    weakSelf.model.joinPeopleList = [muArray copy];
                }
            }
            
            actionSheetBlock();
        }else {
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
        }
    }];
}

- (void)updateData {
    if ([NSString xy_isEmpty:self.model.weather]) {
        self.weatherLab.textColor = [UIColor appGrayTextColor];
        self.weatherLab.text = @"请选择";
    }else {
        self.weatherLab.textColor = [UIColor appTextColor];
        self.weatherLab.text = self.model.weather;
    }
    
    if ([NSString xy_isEmpty:self.model.lakeType]) {
        self.lakeTypeLab.textColor = [UIColor appGrayTextColor];
        self.lakeTypeLab.text = @"请选择";
    }else {
        self.lakeTypeLab.textColor = [UIColor appTextColor];
        self.lakeTypeLab.text = self.model.lakeType;
    }
    
    if (!self.model.xcAreaModel) {
        self.xcAreaLab.textColor = [UIColor appGrayTextColor];
        self.xcAreaLab.text = @"请选择";
    }else {
        self.xcAreaLab.textColor = [UIColor appTextColor];
        self.xcAreaLab.text = self.model.xcAreaModel.ADNM;
    }
    
    if (!self.model.xcObject) {
        self.xcObjectLab.textColor = [UIColor appGrayTextColor];
        self.xcObjectLab.text = @"请选择";
    }else {
        self.xcObjectLab.textColor = [UIColor appTextColor];
        self.xcObjectLab.text = self.model.xcObject.SKMC;
    }
    
    if ([NSString xy_isEmpty:self.xcNameTextField.text]) {
        if (self.model.xcAreaModel && self.model.xcObject) {
            NSString *text = [NSString stringWithFormat:@"%@%@",self.model.xcAreaModel.ADNM,self.model.xcObject.SKMC];
            self.xcNameTextField.text = text;
            self.model.xcName = text;
        }
    }
    
    if (self.model.selectContentList.count == 0) {
        self.xcContentLab.textColor = [UIColor appGrayTextColor];
        self.xcContentLab.text = @"请选择";
    }else {
        self.xcContentLab.textColor = [UIColor appTextColor];
        
        __block NSString *text = @"";
        [self.model.selectContentList enumerateObjectsUsingBlock:^(OOXCContentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [text stringByAppendingString:obj.XCNR];
            if (idx != self.model.selectContentList.count - 1) {
                text = [text stringByAppendingString:@","];
            }
        }];
        self.xcContentLab.text = text;
    }
    
    if (self.model.selectjoinPartList.count == 0) {
        self.joinPartLab.textColor = [UIColor appGrayTextColor];
        self.joinPartLab.text = @"请选择";
    }else {
        self.joinPartLab.textColor = [UIColor appTextColor];
        
        __block NSString *text = @"";
        [self.model.selectjoinPartList enumerateObjectsUsingBlock:^(OOXCJoinPartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [text stringByAppendingString:obj.Dpnm];
            if (idx != self.model.selectjoinPartList.count - 1) {
                text = [text stringByAppendingString:@","];
            }
        }];
        self.joinPartLab.text = text;
    }
    
    if (self.model.selectjoinPeopleList.count == 0) {
        self.joinPeopleLab.textColor = [UIColor appGrayTextColor];
        self.joinPeopleLab.text = @"请选择";
    }else {
        self.joinPeopleLab.textColor = [UIColor appTextColor];
        
        __block NSString *text = @"";
        [self.model.selectjoinPeopleList enumerateObjectsUsingBlock:^(OOXCJoinPeopleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [text stringByAppendingString:obj.RealName];
            if (idx != self.model.selectjoinPeopleList.count - 1) {
                text = [text stringByAppendingString:@","];
            }
        }];
        self.joinPeopleLab.text = text;
    }
}

- (void)fetchXcAreaListWithCompeteHandle:(void(^)(BOOL complete))completeHandle {
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].AreaCode forKey:@"AreaCode"];
    __weak typeof(self) weakSelf = self;
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Appqy parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD dismiss];
            
            NSArray *data = [response xyArrayForKey:@"data"];
            if (data.count > 0) {
                NSMutableArray *muArray = [[NSMutableArray alloc] init];
                [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *d = (NSDictionary *)obj;
                        OOXCAreaModel *model = [OOXCAreaModel yy_modelWithJSON:d];
                        [muArray addObject:model];
                    }
                }];
                
                weakSelf.model.xcAreaList = [muArray copy];
            }
            
            if (!weakSelf.model.xcAreaModel) {
                NSArray *udata = [response xyArrayForKey:@"udata"];
                if (udata.count > 0) {
                    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *d = (NSDictionary *)obj;
                                weakSelf.model.xcAreaModel = [OOXCAreaModel yy_modelWithJSON:d];
                            }
                        }
                    }];
                }
            }
            [weakSelf updateData];
        }else {
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
        }
        
        if (completeHandle) {
            completeHandle(success);
        }
    }];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    self.model.xcName = textField.text;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
}

#pragma mark -- lazy
- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SAFE_TOP + 44)];
        
        //back
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [backBtn setImage:[UIImage imageNamed:@"mini_common_arrow_back_white"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
        [backBtn sizeToFit];
        [backBtn setFrame:CGRectMake(15, SAFE_TOP + (44 - backBtn.height) / 2.0,backBtn.width , backBtn.height)];
        [_navBar addSubview:backBtn];
        
        //record
        UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [recordBtn addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
        [recordBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [recordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [recordBtn sizeToFit];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right, SAFE_TOP, recordBtn.left - backBtn.right, 44)];
        titleLab.text = @"创建巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

//- (OOCreateXCTableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[OOCreateXCTableView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - self.navBar.bottom - SAFE_BOTTOM) style:(UITableViewStylePlain) model:self.model];
//    }
//    return _tableView;
//}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - self.navBar.bottom - SAFE_BOTTOM)];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"天气情况*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_weatherView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_weatherView.width - 15 - arrowImageView.width, (_weatherView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_weatherView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.left - 4 - 150, 0, 150, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_weatherView addSubview:rightLab];
        self.weatherLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_weatherView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWeather)];
        [_weatherView addGestureRecognizer:tap];
    }
    return _weatherView;
}

- (UIView *)lakeTypeView {
    if (!_lakeTypeView) {
        _lakeTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.weatherView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"河湖类型*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_lakeTypeView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_lakeTypeView.width - 15 - arrowImageView.width, (_lakeTypeView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_lakeTypeView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.left - 4 - 150, 0, 150, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_lakeTypeView addSubview:rightLab];
        self.lakeTypeLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_lakeTypeView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLakeType)];
        [_lakeTypeView addGestureRecognizer:tap];
    }
    return _lakeTypeView;
}

- (UIView *)xcAreaView {
    if (!_xcAreaView) {
        _xcAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lakeTypeView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"巡查区域*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_xcAreaView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_xcAreaView.width - 15 - arrowImageView.width, (_xcAreaView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_xcAreaView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.left - 4 - 150, 0, 150, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        rightLab.userInteractionEnabled = NO;
        [_xcAreaView addSubview:rightLab];
        self.xcAreaLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_xcAreaView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickXcArea)];
        [_xcAreaView addGestureRecognizer:tap];
    }
    return _xcAreaView;
}

- (UIView *)xcObjectView {
    if (!_xcObjectView) {
        _xcObjectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xcAreaView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"巡查对象*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_xcObjectView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_xcObjectView.width - 15 - arrowImageView.width, (_xcObjectView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_xcObjectView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.left - 4 - 150, 0, 150, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_xcObjectView addSubview:rightLab];
        self.xcObjectLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_xcObjectView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickXcObject)];
        [_xcObjectView addGestureRecognizer:tap];
    }
    return _xcObjectView;
}

- (UIView *)xcNameView {
    if (!_xcNameView) {
        _xcNameView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xcObjectView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"巡查名称*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_xcNameView addSubview:titleLab];
        
//        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
//        [arrowImageView sizeToFit];
//        [arrowImageView setFrame:CGRectMake(_xcNameView.width - 15 - arrowImageView.width, (_xcNameView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
//        arrowImageView.userInteractionEnabled = NO;
//        [_xcNameView addSubview:arrowImageView];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _xcNameView.width - 15 - titleLab.right - 10, Part_height)];
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.placeholder = @"请输入";
        textfield.font = self.contentFont;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_xcNameView addSubview:textfield];
        self.xcNameTextField = textfield;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, textfield.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_xcNameView addSubview:separater];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickXcObject)];
//        [_xcObjectView addGestureRecognizer:tap];
    }
    return _xcNameView;
}

- (UIView *)xcContentView {
    if (!_xcContentView) {
        _xcContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xcNameView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"巡查内容*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_xcContentView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_xcContentView.width - 15 - arrowImageView.width, (_xcContentView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_xcContentView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right+10, 0, arrowImageView.left - 5 - titleLab.right - 10, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_xcContentView addSubview:rightLab];
        self.xcContentLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_xcContentView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContent)];
        [_xcContentView addGestureRecognizer:tap];
    }
    return _xcContentView;
}

- (UIView *)joinPartView {
    if (!_joinPartView) {
        _joinPartView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xcContentView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"参与单位";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_joinPartView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_joinPartView.width - 15 - arrowImageView.width, (_joinPartView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_joinPartView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right+10, 0, arrowImageView.left - 5 - titleLab.right - 10, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_joinPartView addSubview:rightLab];
        self.joinPartLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_joinPartView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickJoinPart)];
        [_joinPartView addGestureRecognizer:tap];
    }
    return _joinPartView;
}

- (UIView *)joinPeopleView {
    if (!_joinPeopleView) {
        _joinPeopleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.joinPartView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"参与人员";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_joinPeopleView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_joinPartView.width - 15 - arrowImageView.width, (_joinPartView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_joinPeopleView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right+10, 0, arrowImageView.left - 5 - titleLab.right - 10, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_joinPeopleView addSubview:rightLab];
        self.joinPeopleLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_joinPeopleView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickJoinPeople)];
        [_joinPeopleView addGestureRecognizer:tap];
    }
    return _joinPeopleView;
}

- (UIView *)xcQTPeopleView {
    if (!_xcQTPeopleView) {
        _xcQTPeopleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.joinPeopleView.bottom, self.scrollView.width, Part_height*2)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"其他人员";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_xcQTPeopleView addSubview:titleLab];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _xcQTPeopleView.width - 11 - titleLab.right - 10, _xcQTPeopleView.height)];
        textView.textAlignment = NSTextAlignmentRight;
        textView.font = self.contentFont;
        textView.delegate = self;
        [_xcQTPeopleView addSubview:textView];
        self.xcQTPeopleTextView = textView;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, _xcQTPeopleView.height - 0.5, textView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_xcQTPeopleView addSubview:separater];
    }
    return _xcQTPeopleView;
}


- (UIView *)startTimeView {
    if (!_startTimeView) {
        _startTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xcQTPeopleView.bottom, self.scrollView.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"开始时间";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_startTimeView addSubview:titleLab];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right + 5, 0, _startTimeView.width - 15 - titleLab.right - 5, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.textColor = [UIColor appGrayTextColor];
        rightLab.userInteractionEnabled = NO;
        rightLab.text = [[OOAPPMgr sharedMgr] getDateString];
        [_startTimeView addSubview:rightLab];
        self.startTimeLab = rightLab;
    }
    return _startTimeView;
}

- (OOCreateXCModel *)model {
    if (!_model) {
        _model = [[OOCreateXCModel alloc] init];
    }
    return _model;
}

@end
