//
//  OOPatrolVC.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOPatrolVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <YYModel/YYModel.h>
#import "LNActionSheet.h"
#import "JXTAlertManagerHeader.h"

@interface OOPatrolVC ()<BMKMapViewDelegate>

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *sportNodes; // 轨迹点

@property (nonatomic, strong) UIButton *beginBtn;
@property (nonatomic, strong) UIButton *endBtn;

@property (nonatomic, strong) UITextView *debugTextView;

@end

@implementation OOPatrolVC
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    [self updateButtonUI];
    [[OOXCMgr sharedMgr] startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidUpdateHeading) name:pref_key_notification_didUpdateHeading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidUpdateLocation) name:pref_key_notification_didUpdateLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerUploadLocationSuccess) name:pref_key_notification_upload_location_success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerUploadLocationBegin:) name:pref_key_notification_upload_location_begin object:nil];
    
    [self.view addSubview:self.debugTextView];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.baseIndoorMapEnabled = YES;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)initViews {
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.beginBtn];
    [self.view addSubview:self.endBtn];
}

#pragma mark -- 前期数据准备
- (void)prepareData {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)[OOXCMgr sharedMgr].unFinishedXCModel.xc_id] forKey:@"Xcid"];
    __weak typeof(self) weakSelf = self;
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xczblist parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                NSArray *data = [dic xyArrayForKey:@"data"];
                if (data.count > 0) {
                    [weakSelf.sportNodes removeAllObjects];
                    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *d = (NSDictionary *)obj;
                            OOSportNode *node = [OOSportNode yy_modelWithJSON:d];
                            [weakSelf.sportNodes addObject:node];
                        }
                    }];
                    [weakSelf updateButtonUI];
                }
            }
        }
        [weakSelf drawTrackMap];
    }];
}

#pragma mark - 通知
- (void)locationManagerDidUpdateHeading {
    [self.mapView updateLocationData:[OOXCMgr sharedMgr].userLocation];
}

- (void)locationManagerDidUpdateLocation {
    CGFloat distance = [[OOXCMgr sharedMgr] distanceFrompreUploadLocation];
    
    if (distance > 10) {
        [self.mapView updateLocationData:[OOXCMgr sharedMgr].userLocation];
    }
    
    self.debugTextView.text = [self.debugTextView.text stringByAppendingFormat:@"\n----%lf",distance];
}

- (void)locationManagerUploadLocationSuccess {
    [self updateButtonUI];
    self.debugTextView.text = [self.debugTextView.text stringByAppendingString:@"\n成功上报服务器"];
}

- (void)locationManagerUploadLocationBegin:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    OOSportNode *sportNode = [userInfo valueForKey:@"sportNode"];
    
    if (sportNode) {
        [self.sportNodes addObject:sportNode];
    }
    [self drawTrackMap];
    
    self.debugTextView.text = [self.debugTextView.text stringByAppendingFormat:@"\n开始上报服务器-当前上报点总数:%ld",self.sportNodes.count];
}

#pragma mark -- 绘制地图
- (void)drawTrackMap {
    CLLocation *firstLocation;
    CLLocationCoordinate2D coors[self.sportNodes.count];
    for (NSInteger i = 0; i < self.sportNodes.count; i++) {
        OOSportNode *info = [self.sportNodes objectAtIndex:i];
        NSString *location = info.location;
        NSArray *coordinate = [location componentsSeparatedByString:@","];
        if (coordinate.count == 2) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[coordinate firstObject] floatValue], [[coordinate lastObject] floatValue]);
            coors[i] = location;
        }
        
        if (i == 0) {
            firstLocation = [[CLLocation alloc] initWithLatitude:[[coordinate firstObject] floatValue] longitude:[[coordinate lastObject] floatValue]];
        }
    }
    
    [self.mapView removeOverlays:[_mapView overlays]];
    //轨迹
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:self.sportNodes.count];
    [self.mapView addOverlay:polyline];
    
    //起点
    BMKPointAnnotation *beginAnnotation = [[BMKPointAnnotation alloc]init];
    beginAnnotation.coordinate = coors[0];
    beginAnnotation.title = @"起点";
    [self.mapView addAnnotation:beginAnnotation];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"OOHomeVC"]) {
            [[MDPageMaster master].navigationContorller popToViewController:obj withAnimation:YES];
            *stop = YES;
        }
    }];
}

- (void)clickShareButton {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *titles = [[OOXCMgr sharedMgr] reportTypeArray];
    for (int i = 0; i < titles.count; i++) {
        LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
        model.title = titles[i];
        model.sheetId = i;
        model.itemType = LNActionSheetItemNoraml;
        
        model.actionBlock = ^{
            [[MDPageMaster master] openUrl:@"xiaoying://oo_report_vc" action:^(MDUrlAction * _Nullable action) {
                [action setInteger:i forKey:@"typeIndex"];
            }];
        };
        [array addObject:model];
    }
    [LNActionSheet showWithDesc:@"上报类型" actionModels:[NSArray arrayWithArray:array] action:nil];
}

- (void)clickBeginButton {
    __weak typeof(self) weakSelf = self;
    
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_notBegin) {
        jxt_showAlertTwoButton(@"提示",@"是否开始巡查", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:@(OOXCStatus_ing) forKey:@"Status"];
            [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"Xcid"];
            [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_updateXcStatus parameters:param options:nil block:^(BOOL success, id response) {
                if (success) {
                    [OOXCMgr sharedMgr].unFinishedXCModel.status = OOXCStatus_ing;
                    
                    [[OOXCMgr sharedMgr] startUpdatingLocation];
                    [weakSelf updateButtonUI];
                    [[OOXCMgr sharedMgr] uploadCurrentLoactionToServer];
                }
                
                [SVProgressHUD dismiss];
            }];
        });
    }
    
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_pause) {
        jxt_showAlertTwoButton(@"提示",@"是否继续巡查", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:@(OOXCStatus_ing) forKey:@"Status"];
            [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"Xcid"];
            [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_updateXcStatus parameters:param options:nil block:^(BOOL success, id response) {
                if (success) {
                    [OOXCMgr sharedMgr].unFinishedXCModel.status = OOXCStatus_ing;
                    
                    [[OOXCMgr sharedMgr] startUpdatingLocation];
                    [weakSelf updateButtonUI];
                }
                
                [SVProgressHUD dismiss];
            }];
        });
    }
    
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_ing) {
        jxt_showAlertTwoButton(@"提示",@"是否暂停巡查", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:@(OOXCStatus_pause) forKey:@"Status"];
            [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"Xcid"];
            [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_updateXcStatus parameters:param options:nil block:^(BOOL success, id response) {
                if (success) {
                    [OOXCMgr sharedMgr].unFinishedXCModel.status = OOXCStatus_pause;
                    
                    [[OOXCMgr sharedMgr] finishUpdatingLocation];
                    [weakSelf updateButtonUI];
                }
                
                [SVProgressHUD dismiss];
            }];
        });
    }
}

- (void)clickEndButton {
    jxt_showAlertTwoButton(@"提示",@"是否结束巡查", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_finish_vc" action:^(MDUrlAction * _Nullable action) {
            
        }];
        
        [[OOXCMgr sharedMgr] uploadCurrentLoactionToServer];
    });
}


#pragma mark -- 百度Map
/** 地图加载完成 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_ing || [OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_pause) {
        [self prepareData];
    }
    
    [self.mapView updateLocationData:[OOXCMgr sharedMgr].userLocation];
}

/** 根据overlay生成对应的View */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if (![overlay isKindOfClass:[BMKPolyline class]]) return nil;
    
    BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    polylineView.strokeColor = [UIColor xycColorWithHex:0x3978EB];
    polylineView.lineWidth = 3.0;
    polylineView.lineDashType = kBMKLineDashTypeSquare;
    
    return polylineView;
}

/** 根据anntation生成对应的View */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if ([annotation.title isEqualToString:@"起点"]) {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier_begin";
            BMKAnnotationView *beginAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (beginAnnotationView == nil)
            {
                beginAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:reuseIndetifier];
            }

            beginAnnotationView.image = [UIImage imageNamed:@"oo_ditu_start_icon"];
            return beginAnnotationView;
        }
    }
    
    return nil;
}

#pragma mark -- 更新按钮UI
- (void)updateButtonUI {
    if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_notBegin) {
        [self.beginBtn setTitle:@"开始" forState:(UIControlStateNormal)];
        self.beginBtn.backgroundColor = [UIColor appMainColor];
        [self.endBtn setTitle:@"结束" forState:(UIControlStateNormal)];
        self.endBtn.backgroundColor = [UIColor xycColorWithHex:0xBDBDBD];
    }else if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_ing) {
        [self.beginBtn setTitle:@"暂停" forState:(UIControlStateNormal)];
        self.beginBtn.backgroundColor = [UIColor xycColorWithHex:0xE9512B];
        [self.endBtn setTitle:@"结束" forState:(UIControlStateNormal)];
        self.endBtn.backgroundColor = [UIColor redColor];
    }else if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_pause) {
        [self.beginBtn setTitle:@"继续" forState:(UIControlStateNormal)];
        self.beginBtn.backgroundColor = [UIColor xycColorWithHex:0x569268];
        [self.endBtn setTitle:@"结束" forState:(UIControlStateNormal)];
        self.endBtn.backgroundColor = [UIColor redColor];
    }else if ([OOXCMgr sharedMgr].unFinishedXCModel.status == OOXCStatus_end) {
        
    }
    
    self.endBtn.userInteractionEnabled = self.sportNodes.count > 0 ? YES : NO;
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
        [recordBtn setTitle:@"上报" forState:(UIControlStateNormal)];
        [recordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [recordBtn sizeToFit];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right, SAFE_TOP, recordBtn.left - backBtn.right, 44)];
        titleLab.text = @"河湖巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - SAFE_BOTTOM - self.navBar.bottom)];
        //设置undersideMapView的缩放等级
        [_mapView setZoomLevel:17];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        
        BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
        param.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:param];
    }
    return _mapView;
}

- (UIButton *)beginBtn {
    if (!_beginBtn) {
        _beginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_beginBtn addTarget:self action:@selector(clickBeginButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_beginBtn setFrame:CGRectMake(self.view.width / 2 - 20 - 80, self.view.height - SAFE_BOTTOM - 60 - 80, 80, 80)];
        _beginBtn.layer.cornerRadius = 40;
        _beginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _beginBtn.layer.borderWidth = 3.0;
    }
    return _beginBtn;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_endBtn addTarget:self action:@selector(clickEndButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_endBtn setFrame:CGRectMake(self.view.width / 2 + 20, self.view.height - SAFE_BOTTOM - 60 - 80, 80, 80)];
        _endBtn.layer.cornerRadius = 40;
        _endBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _endBtn.layer.borderWidth = 3.0;
    }
    return _endBtn;
}

- (NSMutableArray *)sportNodes {
    if (!_sportNodes) {
        _sportNodes = [[NSMutableArray alloc] init];
    }
    return _sportNodes;
}


- (UITextView *)debugTextView {
    if (!_debugTextView) {
        _debugTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 100)];
        _debugTextView.font = [UIFont systemFontOfSize:14];
        _debugTextView.backgroundColor = [UIColor whiteColor];
        _debugTextView.editable = NO;
    }
    return _debugTextView;
}

@end
