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

@interface OOReportVC ()

@property (nonatomic, strong) OOReportModel *model;
@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) OOTypeView *typeView;
@property (nonatomic, strong) OOTypeView *categoryView;
@property (nonatomic, strong) OOTypeView *nameView;
@property (nonatomic, strong) OOTypeView *placeView;
@property (nonatomic, strong) OOTypeView *photoView;

@end

@implementation OOReportVC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    self.model.typeText = [urlAction stringForKey:@"typeText"];
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
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
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
        titleLab.text = self.model.typeText;
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
        _categoryView = [[OOTypeView alloc] initWithFrame:CGRectMake(0, self.typeView.bottom, self.view.width, 50) type:(OOTypeViewType_category) model:self.model];
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

- (OOReportModel *)model {
    if (!_model) {
        _model = [[OOReportModel alloc] init];
    }
    return _model;
}

@end
