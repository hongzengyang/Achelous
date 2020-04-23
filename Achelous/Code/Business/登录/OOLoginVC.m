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
#import <WMZDialog/WMZDialog.h>


@interface OOLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *titleLab;


@property (nonatomic, strong) UILabel *countyLab;
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
    
    [self updateCountyLab];
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
    
    [self.view addSubview:self.bgImageView];
//    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.countyLab];
    [self.view addSubview:self.countyLab];
    
    [self.view addSubview:self.loginBtn];
    
    if ([[OOUserMgr sharedMgr] isLogin]) {
        [self.navigationController pushViewController:[[OOTabBarVC alloc] init] animated:NO];
    }else {
        [self.accountTextField becomeFirstResponder];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.accountTextField) {
        self.accountClearBtn.hidden = textField.text.length == 0 ? YES : NO;
    }
    
    if (textField == self.passwordTextField) {
        self.passwordClearBtn.hidden = textField.text.length == 0 ? YES : NO;
    }
}

- (void)updateCountyLab {
    NSString *text;
    if ([OOAPPMgr sharedMgr].county == OOCountyWD) {
        text = @"武定县 >";
    }else if ([OOAPPMgr sharedMgr].county == OOCountyDY) {
        text = @"大姚县 >";
    }else if ([OOAPPMgr sharedMgr].county == OOCountyNH) {
        text = @"南华县 >";
    }else if ([OOAPPMgr sharedMgr].county == OOCountyYA) {
        text = @"姚安县 >";
    }else if ([OOAPPMgr sharedMgr].county == OOCountyDebug) {
        text = @"开发调试 >";
    }else {
        text = @"请选择区县 >";
    }
    self.countyLab.text = text;
}
#pragma mark -- Tap
- (void)tapAction {
    if ([self.accountTextField isFirstResponder] || [self.passwordTextField isFirstResponder]) {
        [self.view endEditing:YES];
    }
}

#pragma mark -- Click
- (void)clickAccountClearButton {
    self.accountTextField.text = @"";
}

- (void)clickPasswordClearButton {
    self.passwordTextField.text = @"";
}

- (void)clickCountyButton {
    
    NSArray <NSString *>*countylist = @[@"武定县",@"大姚县",@"南华县",@"姚安县"];
    __weak typeof(self) weakSelf = self;
    Dialog()
    .wTypeSet(DialogTypeSelect)
    .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
        NSString *str = anyID;
        OOCounty county = (OOCounty)[countylist indexOfObject:str];
        [OOAPPMgr sharedMgr].county = county;
        [weakSelf updateCountyLab];
    })
    .wTitleSet(@"请选择区域")
    .wTitleColorSet([UIColor blackColor])
    .wTitleFontSet(16.0)
    .wMessageSet(@"")
    .wMessageColorSet([UIColor appTextColor])
    .wMessageFontSet(15.0)
    .wDataSet(countylist)
    .wStart();
}

- (void)clickLoginButton {
    if ([OOAPPMgr sharedMgr].county == OOCountyNone) {
        [SVProgressHUD showErrorWithStatus:@"请选择区县"];
        return;
    }
    
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
            [SVProgressHUD showErrorWithStatus:@"登录名或密码错误！"];
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
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"login"];
    }
    return _bgImageView;
}

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
        CGFloat top = self.view.height * 610.0 / 1882.0;
        if (self.view.height > 740) {
            top += 50;
        }
        _accountView = [[UIView alloc] initWithFrame:CGRectMake(30, top, self.view.width - 60, 50)];
        _accountView.backgroundColor = [UIColor whiteColor];
        _accountView.layer.cornerRadius = 8;
        _accountView.layer.masksToBounds = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oo_login_account_icon"]];
        [icon sizeToFit];
        [icon setSize:CGSizeMake(22, 22)];
        [icon setFrame:CGRectMake(10, (_accountView.height - icon.height)/2.0, icon.width, icon.height)];
        [_accountView addSubview:icon];
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        [clearBtn sizeToFit];
        [clearBtn addTarget:self action:@selector(clickAccountClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [clearBtn setFrame:CGRectMake(_accountView.width - clearBtn.width - 10, (_accountView.height - clearBtn.height)/2.0, clearBtn.width, clearBtn.height)];
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
        _passwordView.layer.cornerRadius = 8;
        _passwordView.layer.masksToBounds = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oo_login_mima_icon"]];
        [icon sizeToFit];
        [icon setSize:CGSizeMake(22, 22)];
        [icon setFrame:CGRectMake(10, (_passwordView.height - icon.height)/2.0, icon.width, icon.height)];
        [_passwordView addSubview:icon];
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clearBtn setImage:[UIImage imageNamed:@"mini_searchpage_clear_icon"] forState:(UIControlStateNormal)];
        [clearBtn sizeToFit];
        [clearBtn addTarget:self action:@selector(clickPasswordClearButton) forControlEvents:(UIControlEventTouchUpInside)];
        [clearBtn setFrame:CGRectMake(_passwordView.width - clearBtn.width - 10, (_passwordView.height - clearBtn.height)/2.0, clearBtn.width, clearBtn.height)];
        clearBtn.hidden = YES;
        [_passwordView addSubview:clearBtn];
        self.passwordClearBtn = clearBtn;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(icon.right + 10, 0, clearBtn.left - icon.right - 10, _passwordView.height)];
        textField.delegate = self;
        textField.secureTextEntry = YES;
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
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor appMainColor] forState:(UIControlStateNormal)];
        _loginBtn.layer.cornerRadius = 8;
        _loginBtn.backgroundColor = [UIColor whiteColor];
    }
    return _loginBtn;
}

- (UILabel *)countyLab {
    if (!_countyLab) {
        _countyLab = [[UILabel alloc] initWithFrame:CGRectMake(self.accountView.left, self.accountView.top - 5 - 34, 100, 34)];
        _countyLab.backgroundColor = [UIColor whiteColor];
        _countyLab.layer.cornerRadius = 4;
        _countyLab.layer.masksToBounds = YES;
        _countyLab.textColor = [UIColor blackColor];
        _countyLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _countyLab.textAlignment = NSTextAlignmentCenter;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setFrame:_countyLab.frame];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickCountyButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
    }
    return _countyLab;
}

@end
