//
//  OOEditSecretVC.m
//  Achelous
//
//  Created by hzy on 2020/3/3.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOEditSecretVC.h"

@interface OOEditSecretVC ()
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIView *originalSecretView;
@property (nonatomic, strong) UIView *secretView;
@property (nonatomic, strong) UIView *confirmSecretView;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UITextField *originalTextField;
@property (nonatomic, strong) UITextField *secretTextField;
@property (nonatomic, strong) UITextField *confirmTextField;
@end

@implementation OOEditSecretVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.originalSecretView];
    [self.view addSubview:self.secretView];
    [self.view addSubview:self.confirmSecretView];
    [self.view addSubview:self.okBtn];
    
    [self.originalTextField becomeFirstResponder];
}

- (void)clickBackButton {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOKButton {
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
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
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 200)/2.0, SAFE_TOP, 200, 44)];
        titleLab.text = @"修改密码";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.navBar.bottom + 10, SCREEN_WIDTH - 30, 25)];
        _tipLab.font = [UIFont systemFontOfSize:14];
        _tipLab.textColor = [UIColor appGrayTextColor];
        _tipLab.text = @"密码为6-15个字母，可由英文字母，数字，下划线组成";
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLab;
}

- (UIView *)originalSecretView {
    if (!_originalSecretView) {
        _originalSecretView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tipLab.bottom + 10, SCREEN_WIDTH, 50)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, _originalSecretView.height)];
        titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        titleLab.text = @"原密码:";
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor appTextColor];
        [_originalSecretView addSubview:titleLab];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, SCREEN_WIDTH - 15 - titleLab.right - 10, 50)];
//        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.placeholder = @"请输入原密码";
        [_originalSecretView addSubview:textField];
        self.originalTextField = textField;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, _originalSecretView.height - 0.5, SCREEN_WIDTH - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_originalSecretView addSubview:separater];
    }
    return _originalSecretView;
}

- (UIView *)secretView {
    if (!_secretView) {
        _secretView = [[UIView alloc] initWithFrame:CGRectMake(0, self.originalSecretView.bottom + 10, SCREEN_WIDTH, 50)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, _originalSecretView.height)];
        titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        titleLab.text = @"新密码:";
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor appTextColor];
        [_secretView addSubview:titleLab];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, SCREEN_WIDTH - 15 - titleLab.right - 10, 50)];
//        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.placeholder = @"请输入新密码";
        [_secretView addSubview:textField];
        self.secretTextField = textField;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, _secretView.height - 0.5, SCREEN_WIDTH - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_secretView addSubview:separater];
    }
    return _secretView;
}

- (UIView *)confirmSecretView {
    if (!_confirmSecretView) {
        _confirmSecretView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secretView.bottom + 10, SCREEN_WIDTH, 50)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, _originalSecretView.height)];
        titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        titleLab.text = @"确认新密码:";
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor appTextColor];
        [_confirmSecretView addSubview:titleLab];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, SCREEN_WIDTH - 15 - titleLab.right - 10, 50)];
//        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.placeholder = @"请再次输入新密码";
        [_confirmSecretView addSubview:textField];
        self.confirmTextField = textField;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, _confirmSecretView.height - 0.5, SCREEN_WIDTH - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_confirmSecretView addSubview:separater];
    }
    return _confirmSecretView;
}


- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_okBtn addTarget:self action:@selector(clickOKButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_okBtn setFrame:CGRectMake(30, self.confirmSecretView.bottom + 50, self.view.width - 60, 44)];
        [_okBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _okBtn.layer.cornerRadius = 8;
        _okBtn.backgroundColor = [UIColor appMainColor];
    }
    return _okBtn;
}

@end
