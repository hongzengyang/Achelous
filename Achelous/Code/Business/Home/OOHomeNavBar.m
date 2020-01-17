//
//  OOHomeNavBar.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeNavBar.h"

@interface OOHomeNavBar ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *settingBtn;

@end

@implementation OOHomeNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.titleLab];
    [self addSubview:self.settingBtn];
}

- (void)clickSettingButton {
    
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 150, self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = @"河湖长制综合信息管理平台";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
    }
    return _titleLab;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_settingBtn addTarget:self action:@selector(clickSettingButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_settingBtn setFrame:CGRectMake(self.width - 15 - 26, 9, 26, 26)];
        [_settingBtn setImage:[UIImage imageNamed:@"oo_setting_icon"] forState:(UIControlStateNormal)];
    }
    return _settingBtn;
}

@end
