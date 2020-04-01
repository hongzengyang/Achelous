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
#import "OOTabBarVC.h"
#import <CoreLocation/CoreLocation.h>


@interface OOLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLab;


@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIButton *accountClearBtn;

@property (nonatomic, strong) UIView *passwordView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *passwordClearBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) BOOL configedSubviews;

@end

@implementation OOLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OOLocalNotificationMgr sharedMgr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self.accountTextField) {
        if (![[OOUserMgr sharedMgr] isLogin]) {
            [self.accountTextField becomeFirstResponder];
        }
    }
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
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.passwordView];
    
    [self.view addSubview:self.loginBtn];
    
    if ([[OOUserMgr sharedMgr] isLogin]) {
        [self.navigationController pushViewController:[[OOTabBarVC alloc] init] animated:NO];
    }else {
        [self.accountTextField becomeFirstResponder];
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
    self.accountTextField.text = @"";
}

- (void)clickPasswordClearButton {
    self.passwordTextField.text = @"";
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
    
    if (![OOTools checkPassword:self.passwordTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式错误"];
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
            [self.navigationController pushViewController:[[OOTabBarVC alloc] init] animated:NO];
            
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
        _titleLab.textColor = [UIColor appMainColor];
        _titleLab.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightMedium)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"河湖长制综合信息管理平台";
    }
    return _titleLab;
}

- (UIView *)accountView {
    if (!_accountView) {
        _accountView = [[UIView alloc] initWithFrame:CGRectMake(30, self.titleLab.bottom + 50, self.view.width - 60, 50)];
        _accountView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oo_login_account_icon"]];
        [icon sizeToFit];
        [icon setSize:CGSizeMake(22, 22)];
        [icon setFrame:CGRectMake(0, (_accountView.height - icon.height)/2.0, icon.width, icon.height)];
        [_accountView addSubview:icon];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, _accountView.height - 0.5, _accountView.width, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_accountView addSubview:separater];
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        [clearBtn sizeToFit];
        [clearBtn addTarget:self action:@selector(clickAccountClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [clearBtn setFrame:CGRectMake(_accountView.width - clearBtn.width, (_accountView.height - clearBtn.height)/2.0, clearBtn.width, clearBtn.height)];
        clearBtn.hidden = YES;
        [_accountView addSubview:clearBtn];
        self.accountClearBtn = clearBtn;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(icon.right + 10, 0, clearBtn.left - icon.right - 10, _accountView.height)];
        textField.delegate = self;
        textField.placeholder = @"请输入账号";
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [_accountView addSubview:textField];
        self.accountTextField = textField;
    }
    return _accountView;
}


- (UIView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[UIView alloc] initWithFrame:CGRectMake(30, self.accountView.bottom + 10, self.view.width - 60, 50)];
        _passwordView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oo_login_mima_icon"]];
        [icon sizeToFit];
        [icon setSize:CGSizeMake(22, 22)];
        [icon setFrame:CGRectMake(0, (_passwordView.height - icon.height)/2.0, icon.width, icon.height)];
        [_passwordView addSubview:icon];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, _passwordView.height - 0.5, _passwordView.width, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_passwordView addSubview:separater];
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        [clearBtn sizeToFit];
        [clearBtn addTarget:self action:@selector(clickPasswordClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [clearBtn setFrame:CGRectMake(_passwordView.width - clearBtn.width, (_passwordView.height - clearBtn.height)/2.0, clearBtn.width, clearBtn.height)];
        clearBtn.hidden = YES;
        [_passwordView addSubview:clearBtn];
        self.passwordClearBtn = clearBtn;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(icon.right + 10, 0, clearBtn.left - icon.right - 10, _passwordView.height)];
        textField.delegate = self;
        textField.placeholder = @"请输入密码";
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_passwordView addSubview:textField];
        self.passwordTextField = textField;
    }
    return _passwordView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginBtn addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_loginBtn setFrame:CGRectMake((self.view.width - 200)/2.0, self.passwordView.bottom + 30, 200, 44)];
        [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
        _loginBtn.layer.cornerRadius = 8;
        _loginBtn.backgroundColor = [UIColor appMainColor];
    }
    return _loginBtn;
}

@end
