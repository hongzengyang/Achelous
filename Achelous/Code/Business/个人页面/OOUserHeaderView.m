//
//  OOUserHeaderView.m
//  Achelous
//
//  Created by hzy on 2020/4/1.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOUserHeaderView.h"

@interface OOUserHeaderView ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *accountLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *zwLab;
@property (nonatomic, strong) UIImageView *headerImageView;
@end

@implementation OOUserHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        [self refresh];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.titleLab];
    [self addSubview:self.headerImageView];
    [self addSubview:self.accountLab];
    [self addSubview:self.nameLab];
    [self addSubview:self.zwLab];
}

- (void)refresh {
    [[OOUserMgr sharedMgr] refreshUserInfoWithCompleteHandle:^(BOOL complete) {
        NSString *account = @"";
        if ([OOUserMgr sharedMgr].loginUserInfo.UserName.length > 0) {
            account = [OOUserMgr sharedMgr].loginUserInfo.UserName;
        }
        self.accountLab.text = [NSString stringWithFormat:@"登录账户:%@",account];
        NSString *name = @"";
        if ([OOUserMgr sharedMgr].loginUserInfo.RealName.length > 0) {
            name = [OOUserMgr sharedMgr].loginUserInfo.RealName;
        }
        self.nameLab.text = [NSString stringWithFormat:@"姓名:%@",name];
        NSString *zw = @"";
        if ([OOUserMgr sharedMgr].loginUserInfo.Uzw.length > 0) {
            zw = [OOUserMgr sharedMgr].loginUserInfo.Uzw;
        }
        self.zwLab.text = [NSString stringWithFormat:@"职务:%@",zw];
    }];
}

- (void)viewWillAppear {
    [self refresh];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 30)];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.text = @"我的";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 60)/2.0, self.titleLab.bottom + 10, 60, 60)];
        _headerImageView.layer.cornerRadius = 30;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.image = [UIImage imageNamed:@"head-portrait"];
    }
    return _headerImageView;
}

- (UILabel *)accountLab {
    if (!_accountLab) {
        _accountLab = [[UILabel alloc] initWithFrame:CGRectMake(15 + 30, self.headerImageView.bottom + 10, 150, 30)];
        _accountLab.font = [UIFont systemFontOfSize:15];
        _accountLab.textColor = [UIColor appTextColor];
        _accountLab.textAlignment = NSTextAlignmentLeft;
    }
    return _accountLab;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2.0 + 30, self.headerImageView.bottom + 10, 150, 30)];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor appTextColor];
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}

- (UILabel *)zwLab {
    if (!_zwLab) {
        _zwLab = [[UILabel alloc] initWithFrame:CGRectMake(self.accountLab.left, self.accountLab.bottom + 8, 150, 30)];
        _zwLab.font = [UIFont systemFontOfSize:15];
        _zwLab.textColor = [UIColor appTextColor];
        _zwLab.textAlignment = NSTextAlignmentLeft;
    }
    return _zwLab;
}


@end
