//
//  OOHomeHeaderView.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeHeaderView.h"
#import "OOHomeHeaderTypeView.h"
#import <UIKit/UIKit.h>

@interface OOHomeHeaderView ()

@property (nonatomic, strong) OOHomeModel *homeModel;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) OOHomeHeaderTypeView *SLTypeView;
@property (nonatomic, strong) OOHomeHeaderTypeView *WRTypeView;
@property (nonatomic, strong) OOHomeHeaderTypeView *XQTypeView;
@property (nonatomic, strong) OOHomeHeaderTypeView *JBTypeView;

@property (nonatomic, assign) CGFloat type_width;
@property (nonatomic, assign) CGFloat type_height;
@property (nonatomic, assign) CGFloat type_interval;

@end

@implementation OOHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame model:(nonnull OOHomeModel *)model {
    if (self = [super initWithFrame:frame]) {
        self.homeModel = model;
        self.type_interval = 25;
        self.type_width = ([UIScreen mainScreen].bounds.size.width - 30 - self.type_interval * 3) / 4;
        self.type_height = 60;
        [self configUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDataRefreshFinished) name:PREF_KEY_HOME_DATA_FRESH_FINISH object:nil];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.bgImageView];
    [self addSubview:self.SLTypeView];
    [self addSubview:self.WRTypeView];
    [self addSubview:self.XQTypeView];
    [self addSubview:self.JBTypeView];
}

#pragma mark -- 通知
- (void)homeDataRefreshFinished {
    [self.SLTypeView updateCount:self.homeModel.dataModel.SLinfo];
    [self.WRTypeView updateCount:self.homeModel.dataModel.WRinfo];
    [self.XQTypeView updateCount:self.homeModel.dataModel.XQinfo];
    [self.JBTypeView updateCount:self.homeModel.dataModel.JBinfo];
}

#pragma mark -- Lazy
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"20190815085153249eljilb"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
- (OOHomeHeaderTypeView *)SLTypeView {
    if (!_SLTypeView) {
        _SLTypeView = [[OOHomeHeaderTypeView alloc] initWithFrame:CGRectMake(15, self.height - 20 - self.type_height, self.type_width, self.type_height) title:@"四乱现象"];
    }
    return _SLTypeView;
}

- (OOHomeHeaderTypeView *)WRTypeView {
    if (!_WRTypeView) {
        _WRTypeView = [[OOHomeHeaderTypeView alloc] initWithFrame:CGRectMake(self.SLTypeView.right + self.type_interval, self.SLTypeView.top, self.type_width, self.type_height) title:@"污染现象"];
    }
    return _WRTypeView;
}

- (OOHomeHeaderTypeView *)XQTypeView {
    if (!_XQTypeView) {
        _XQTypeView = [[OOHomeHeaderTypeView alloc] initWithFrame:CGRectMake(self.WRTypeView.right + self.type_interval, self.SLTypeView.top, self.type_width, self.type_height) title:@"险情现象"];
    }
    return _XQTypeView;
}

- (OOHomeHeaderTypeView *)JBTypeView {
    if (!_JBTypeView) {
        _JBTypeView = [[OOHomeHeaderTypeView alloc] initWithFrame:CGRectMake(self.XQTypeView.right + self.type_interval, self.SLTypeView.top, self.type_width, self.type_height) title:@"上报现象"];
    }
    return _JBTypeView;
}


@end
