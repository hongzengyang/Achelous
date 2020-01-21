//
//  OOLoginVC.m
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOLoginVC.h"
#import "OOUserMgr.h"
#import "OOAPPMgr.h"
#import "MDPageMaster.h"
#import "OOHomeVC.h"
#import <CoreLocation/CoreLocation.h>


@interface OOLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *accountIcon;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIButton *accountClearBtn;
@property (nonatomic, strong) UIView *accountSeparater;

@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *passwordClearBtn;
@property (nonatomic, strong) UIView *passwordSeparater;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) BOOL configedSubviews;

@end

@implementation OOLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat safeTop = 20;
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
        safeBottom = self.view.safeAreaInsets.bottom;
    }
    [OOAPPMgr sharedMgr].safeTopArea = safeTop;
    [OOAPPMgr sharedMgr].safeBottomArea = safeBottom;

    [self configSubView];
}

- (void)configSubView {
    if (self.configedSubviews) {
        return;
    }
    
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.accountIcon];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.accountClearBtn];
    [self.view addSubview:self.accountSeparater];
    [self.view addSubview:self.passwordIcon];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordClearBtn];
    [self.view addSubview:self.passwordSeparater];
    
    [self.view addSubview:self.loginBtn];
    
    if ([[OOUserMgr sharedMgr] isLogin]) {
        [self.navigationController pushViewController:[[OOHomeVC alloc] init] animated:NO];
    }
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.accountTextField) {
        self.accountClearBtn.hidden = textField.text.length == 0 ? YES : NO;
    }
    
    if (textField == self.passwordTextField) {
        self.passwordClearBtn.hidden = textField.text.length == 0 ? YES : NO;
    }
}

#pragma mark -- Click
- (void)clickAccountClearButton {
    
}

- (void)clickPasswordClearButton {
    
}

- (void)clickLoginButton {
    if ([NSString xy_isEmpty:self.accountTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入账号"];
        return;
    }
    
    if ([NSString xy_isEmpty:self.passwordTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"请等待..."];
    
    [[OOUserMgr sharedMgr] loginWithAccount:self.accountTextField.text password:self.passwordTextField.text completeBlock:^(BOOL complete) {
        if (complete) {
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:@"网络故障，请稍候再试"];
        }
        
        if (complete) {
            [[MDPageMaster master] openUrl:@"xiaoying://oo_home_vc" action:^(MDUrlAction * _Nullable action) {
                
            }];
            
            self.accountTextField.text = @"";
            self.passwordTextField.text = @"";
            self.accountClearBtn.hidden = YES;
            self.passwordClearBtn.hidden = YES;
        }
    }];
}

//定位服务状态改变时调用/
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestAlwaysAuthorization];
            }
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark -- Lazy
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, SAFE_TOP + 100, SCREEN_WIDTH - 20, 30)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"河湖长制综合信息管理平台";
    }
    return _titleLab;
}

- (UIImageView *)accountIcon {
    if (!_accountIcon) {
        _accountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.titleLab.bottom + 30, 30, 30)];
        _accountIcon.image = [UIImage imageNamed:@"oo_login_account_icon"];
    }
    return _accountIcon;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.accountIcon.right + 10, self.accountIcon.top, 250, self.accountIcon.height)];
        _accountTextField.delegate = self;
        _accountTextField.font = [UIFont systemFontOfSize:14];
        [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountTextField;
}

- (UIButton *)accountClearBtn {
    if (!_accountClearBtn) {
        _accountClearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_accountClearBtn addTarget:self action:@selector(clickAccountClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_accountClearBtn setFrame:CGRectMake(SCREEN_WIDTH - 30 - 20, 0, 20, 20)];
        _accountClearBtn.centerY = self.accountIcon.centerY;
        [_accountClearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        _accountClearBtn.hidden = YES;
    }
    return _accountClearBtn;
}

- (UIView *)accountSeparater {
    if (!_accountSeparater) {
        _accountSeparater = [[UIView alloc] initWithFrame:CGRectMake(self.accountIcon.left, self.accountIcon.bottom + 2, self.accountClearBtn.right - self.accountIcon.left, 1)];
        _accountSeparater.backgroundColor = [UIColor appMainColor];
    }
    return _accountSeparater;
}

- (UIImageView *)passwordIcon {
    if (!_passwordIcon) {
        _passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(33, self.accountIcon.bottom + 10, 24, 24)];
        _passwordIcon.image = [UIImage imageNamed:@"oo_login_mima_icon"];
    }
    return _passwordIcon;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.passwordIcon.right + 10, self.passwordIcon.top, 250, self.passwordIcon.height)];
        _passwordTextField.delegate = self;
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _passwordTextField;
}

- (UIButton *)passwordClearBtn {
    if (!_passwordClearBtn) {
        _passwordClearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_passwordClearBtn addTarget:self action:@selector(clickPasswordClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_passwordClearBtn setFrame:CGRectMake(SCREEN_WIDTH - 30 - 20, 0, 20, 20)];
        _passwordClearBtn.centerY = self.passwordIcon.centerY;
        [_passwordClearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        _passwordClearBtn.hidden = YES;
    }
    return _passwordClearBtn;
}

- (UIView *)passwordSeparater {
    if (!_passwordSeparater) {
        _passwordSeparater = [[UIView alloc] initWithFrame:CGRectMake(self.passwordIcon.left, self.passwordIcon.bottom + 2, self.passwordClearBtn.right - self.passwordIcon.left, 1)];
        _passwordSeparater.backgroundColor = [UIColor appMainColor];
    }
    return _passwordSeparater;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginBtn addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_loginBtn setFrame:CGRectMake(self.accountIcon.left, self.passwordSeparater.bottom + 30, self.passwordSeparater.width, 44)];
        [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
        _loginBtn.layer.cornerRadius = 8;
        _loginBtn.backgroundColor = [UIColor appMainColor];
    }
    return _loginBtn;
}

@end
