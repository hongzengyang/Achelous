//
//  OOReportVC.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOReportVC.h"
#import "OOReportModel.h"
#import "OOTypeView.h"
#import "OOUserInputView.h"

@interface OOReportVC ()

@property (nonatomic, strong) OOReportModel *model;
@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) OOTypeView *typeView;
@property (nonatomic, strong) OOTypeView *categoryView;
@property (nonatomic, strong) OOTypeView *nameView;
@property (nonatomic, strong) OOTypeView *placeView;
@property (nonatomic, strong) OOTypeView *photoView;

@property (nonatomic, strong) OOUserInputView *sjmsInputView;
@property (nonatomic, strong) OOUserInputView *qkfxInputView;

@end

@implementation OOReportVC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    self.model.typeIndex = [urlAction integerForKey:@"typeIndex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.placeView];
    [self.view addSubview:self.photoView];
    
    [self.view addSubview:self.sjmsInputView];
    [self.view addSubview:self.qkfxInputView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.photoView update];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    if (self.model.typeIndex != 3) {
        if ([NSString xy_isEmpty:self.model.categoryText]) {
            [SVProgressHUD showErrorWithStatus:@"请输入事件分类"];
            return;
        }
    }
    
    if ([NSString xy_isEmpty:self.model.nameText]) {
        [SVProgressHUD showErrorWithStatus:@"请输入事件名称"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.placeText]) {
        [SVProgressHUD showErrorWithStatus:@"请输入事件地点"];
        return;
    }
    
    if (self.model.photoPathArray.count <= 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择照片"];
        return;
    }
    
    if ([NSString xy_isEmpty:self.sjmsInputView.inputText]) {
        [SVProgressHUD showErrorWithStatus:@"请输入事件描述"];
        return;
    }
    
    if ([NSString xy_isEmpty:self.qkfxInputView.inputText]) {
        [SVProgressHUD showErrorWithStatus:@"请输入情况分析"];
        return;
    }
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].AreaCode forKey:@"QYMC"];
    [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"XCID"];
    {
        CGFloat latitude = [OOXCMgr sharedMgr].userLocation.location.coordinate.latitude;
        CGFloat longitude = [OOXCMgr sharedMgr].userLocation.location.coordinate.longitude;
        NSString *location = [NSString stringWithFormat:@"%lf",latitude];
        location = [location stringByAppendingString:@","];
        location = [location stringByAppendingFormat:@"%lf",longitude];
        [param setValue:location forKey:@"SJJD"];
    }
    [param setValue:@(self.model.typeIndex + 1) forKey:@"SJLX"];
    {
        if (self.model.typeIndex == 0) {
            [param setValue:@([[[OOXCMgr sharedMgr] SLCategoryArray] indexOfObject:self.model.categoryText]) forKey:@"XCLX"];
        }
        if (self.model.typeIndex == 1) {
            [param setValue:@([[[OOXCMgr sharedMgr] WRCategoryArray] indexOfObject:self.model.categoryText]) forKey:@"XCLX"];
        }
        if (self.model.typeIndex == 2) {
            [param setValue:@([[[OOXCMgr sharedMgr] XQCategoryArray] indexOfObject:self.model.categoryText]) forKey:@"XCLX"];
        }
        if (self.model.typeIndex == 3) {
            [param setValue:@(100) forKey:@"XCLX"];
        }
    }
    [param setValue:self.model.nameText forKey:@"SJMC"];
    [param setValue:self.model.placeText forKey:@"SJDD"];
    
    
    [param setValue:self.sjmsInputView.inputText forKey:@"SJMS"];
    [param setValue:self.qkfxInputView.inputText forKey:@"QKFX"];
    
    __block NSString *sjzp = @"";
    {
        [self.model.serverReturnPhotoPathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sjzp = [sjzp stringByAppendingString:obj];
            if (idx != self.model.serverReturnPhotoPathArray.count - 1) {
                sjzp = [sjzp stringByAppendingString:@","];
            }
        }];
    }
    [param setValue:sjzp forKey:@"SJZP"];
    
    
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Upsjinfo parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }
    }];
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
        titleLab.text = [[[OOXCMgr sharedMgr] reportTypeArray] objectAtIndex:self.model.typeIndex];
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (OOTypeView *)typeView {
    if (!_typeView) {
        _typeView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, 50) type:(OOTypeViewType_type) model:self.model];
    }
    return _typeView;
}

- (OOTypeView *)categoryView {
    if (!_categoryView) {
        CGFloat height = 50;
        if (self.model.typeIndex == 3) {
            height = 0.1;
        }
        _categoryView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.typeView.bottom, self.view.width, height) type:(OOTypeViewType_category) model:self.model];
        if (self.model.typeIndex == 3) {
            _categoryView.hidden = YES;
        }
    }
    return _categoryView;
}

- (OOTypeView *)nameView {
    if (!_nameView) {
        _nameView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.categoryView.bottom, self.view.width, 50) type:(OOTypeViewType_name) model:self.model];
    }
    return _nameView;
}

- (OOTypeView *)placeView {
    if (!_placeView) {
        _placeView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.nameView.bottom, self.view.width, 50) type:(OOTypeViewType_place) model:self.model];
    }
    return _placeView;
}

- (OOTypeView *)photoView {
    if (!_photoView) {
        _photoView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.placeView.bottom, self.view.width, 50) type:(OOTypeViewType_photo) model:self.model];
    }
    return _photoView;
}

- (OOUserInputView *)sjmsInputView {
    if (!_sjmsInputView) {
        _sjmsInputView = [[OOUserInputView alloc] initWithFrame:CGRectMake(0, self.photoView.bottom + 10, self.view.width, 100) title:@"事件描述"];
    }
    return _sjmsInputView;
}

- (OOUserInputView *)qkfxInputView {
    if (!_qkfxInputView) {
        _qkfxInputView = [[OOUserInputView alloc] initWithFrame:CGRectMake(0, self.sjmsInputView.bottom + 10, self.view.width, 100) title:@"情况分析"];
    }
    return _qkfxInputView;
}

- (OOReportModel *)model {
    if (!_model) {
        _model = [[OOReportModel alloc] init];
    }
    return _model;
}

@end
