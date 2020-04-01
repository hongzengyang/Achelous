//
//  OOTabBar.m
//  Achelous
//
//  Created by hzy on 2020/4/1.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOTabBar.h"
#import "UIButton+Layout.h"
#import "UIImage+XYResize.h"

@interface OOTabBar ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *userBtn;
@property (nonatomic, copy) ClickTabBarBlock block;

@end

@implementation OOTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.userBtn];
        
        self.leftBtn.selected = YES;
        self.userBtn.selected = NO;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)handleTabBarClickBlock:(ClickTabBarBlock)clickBlock {
    self.block = clickBlock;
}

- (void)clickleftBtn {
    if (self.leftBtn.selected) {
        return;
    }
    self.leftBtn.selected = YES;
    self.userBtn.selected = NO;
    
    if (self.block) {
        self.block(0);
    }
}

- (void)clickUserBtn {
    if (self.userBtn.selected) {
        return;
    }
    self.leftBtn.selected = NO;
    self.userBtn.selected = YES;
    
    if (self.block) {
        self.block(1);
    }
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn addTarget:self action:@selector(clickleftBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_leftBtn setTitle:@"首页" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:[UIColor xycColorWithHex:0xAAAAB3] forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:[UIColor appMainColor] forState:(UIControlStateSelected)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightRegular)];
        
        UIImage *norImage = [[UIImage imageNamed:@"shouye-2"] xy_resizeImageToSize:CGSizeMake(22, 22)];
        UIImage *selImage = [[UIImage imageNamed:@"shouye"] xy_resizeImageToSize:CGSizeMake(22, 22)];
        [_leftBtn setImage:norImage forState:(UIControlStateNormal)];
        [_leftBtn setImage:selImage forState:(UIControlStateSelected)];
        
        [_leftBtn sizeToFit];
        [_leftBtn layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyleTop) imageTitleSpace:3];
        [_leftBtn setFrame:CGRectMake(((self.width - 0)/2.0 - _leftBtn.width)/2.0, (TABBAR_HEIGHT - _leftBtn.height)/2.0, _leftBtn.width, _leftBtn.height)];
    }
    
    return _leftBtn;
}

- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_userBtn addTarget:self action:@selector(clickUserBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_userBtn setTitle:@"我的" forState:(UIControlStateNormal)];
        [_userBtn setTitleColor:[UIColor xycColorWithHex:0xAAAAB3] forState:(UIControlStateNormal)];
        [_userBtn setTitleColor:[UIColor appMainColor] forState:(UIControlStateSelected)];
        _userBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightRegular)];
        
        UIImage *norImage = [[UIImage imageNamed:@"yonghu"] xy_resizeImageToSize:CGSizeMake(22, 22)];
        UIImage *selImage = [[UIImage imageNamed:@"yonghu-2"] xy_resizeImageToSize:CGSizeMake(22, 22)];
        
        [_userBtn setImage:norImage forState:(UIControlStateNormal)];
        [_userBtn setImage:selImage forState:(UIControlStateSelected)];
        
        [_userBtn sizeToFit];
        [_userBtn layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyleTop) imageTitleSpace:3];
        
        [_userBtn setFrame:CGRectMake(self.width - self.leftBtn.left - _userBtn.width, (TABBAR_HEIGHT - _userBtn.height)/2.0, _userBtn.width, _userBtn.height)];
    }
    
    return _userBtn;
}


@end
