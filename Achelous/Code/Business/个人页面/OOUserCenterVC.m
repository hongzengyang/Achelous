//
//  OOUserCenterVC.m
//  Achelous
//
//  Created by hzy on 2020/4/1.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOUserCenterVC.h"
#import "LNActionSheet.h"
#import "MDPageMaster.h"
#import "JXTAlertManagerHeader.h"
#import "OOUserHeaderView.h"

@interface OOUserCenterVC ()
@property (nonatomic, strong) OOUserHeaderView *headerView;
@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) UIView *editSecretView;
@property (nonatomic, strong) UIView *versionView;

@property (nonatomic, strong) UIButton *logoutBtn;

@property (nonatomic, strong) UILabel *notificationLab;
@end

@implementation OOUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor xycColorWithHex:0xe6e6e6 alpha:0.4];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SAFE_TOP)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.notificationView];
    [self.view addSubview:self.editSecretView];
    [self.view addSubview:self.versionView];
    [self.view addSubview:self.logoutBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)clickNotification {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *titles = @[@"每隔30分钟",@"每隔45分钟",@"每隔1小时",@"自定义",@"无"];
    for (int i = 0; i < titles.count; i++) {
        LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
        model.title = titles[i];
        model.sheetId = i;
        model.itemType = LNActionSheetItemNoraml;
        
        __weak typeof(self) weakSelf = self;
        model.actionBlock = ^{
            if (i == 0) {
                [OOLocalNotificationMgr sharedMgr].notificationInterval = 30;
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }else if (i == 1) {
                [OOLocalNotificationMgr sharedMgr].notificationInterval = 45;
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }else if (i == 2) {
                [OOLocalNotificationMgr sharedMgr].notificationInterval = 60;
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }else if (i == 3) {
                [weakSelf jxt_showAlertWithTitle:@"设置巡查提醒时间" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.
                    addActionCancelTitle(@"取消").
                    addActionDefaultTitle(@"确定");
                    
                    [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"请输入数字";
                    }];
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    if (buttonIndex == 1) {
                        UITextField *textField = alertSelf.textFields.firstObject;
                        NSString *text = textField.text;
                        if (![weakSelf isALLNumBER:text]) {
                            [SVProgressHUD showErrorWithStatus:@"只能输入数字"];
                            return;
                        }
                        
                        if (text.length == 0) {
                            [SVProgressHUD showErrorWithStatus:@"请输入数字"];
                            return;
                        }
                        
                        [OOLocalNotificationMgr sharedMgr].notificationInterval = [text integerValue];
                        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                    }
                }];
            }else {
                [OOLocalNotificationMgr sharedMgr].notificationInterval = 0;
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }
        };
        [array addObject:model];
    }
    [LNActionSheet showWithDesc:@"设置巡查提醒时间" actionModels:[NSArray arrayWithArray:array] action:nil];
}

- (void)clickEditSecret {
    [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_secret_vc" action:^(MDUrlAction * _Nullable action) {
        
    }];
}

- (void)clickVersion {
    [SVProgressHUD showImage:nil status:@"已是最新版本"];
}

- (void)clickLogoutButton {
//    __weak typeof(self) weakSelf = self;
    jxt_showAlertTwoButton(@"提示",@"是否确定退出？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[OOUserMgr sharedMgr] logout];
        
        [[MDPageMaster master].navigationContorller.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSStringFromClass([obj class]) isEqualToString:@"OOLoginVC"]) {
                [[MDPageMaster master].navigationContorller popToViewController:obj withAnimation:YES];
                *stop = YES;
            }
        }];
    });
}

#pragma mark -- lazy
- (OOUserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[OOUserHeaderView alloc] initWithFrame:CGRectMake(0, SAFE_TOP, SCREEN_WIDTH, 200)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIView *)notificationView {
    if (!_notificationView) {
        _notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, SCREEN_WIDTH, 50)];
        _notificationView.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        leftLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        leftLab.textColor = [UIColor appTextColor];
        leftLab.text = @"提醒设置";
        [leftLab sizeToFit];
        [leftLab setFrame:CGRectMake(15, (_notificationView.height - leftLab.height)/2.0, leftLab.width, leftLab.height)];
        [_notificationView addSubview:leftLab];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [imageView setFrame:CGRectMake(SCREEN_WIDTH - 15 - imageView.width, (_notificationView.height - imageView.height)/2.0, imageView.width, imageView.height)];
        [_notificationView addSubview:imageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.left - 5 - 100, 100, _notificationView.height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
        [_notificationView addSubview:rightLab];
        self.notificationLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, _notificationView.height - 0.5, SCREEN_WIDTH, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_notificationView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNotification)];
        [_notificationView addGestureRecognizer:tap];
    }
    return _notificationView;
}

- (UIView *)editSecretView {
    if (!_editSecretView) {
        _editSecretView = [[UIView alloc] initWithFrame:CGRectMake(0, self.notificationView.bottom, SCREEN_WIDTH, 50)];
        _editSecretView.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        leftLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        leftLab.textColor = [UIColor appTextColor];
        leftLab.text = @"修改密码";
        [leftLab sizeToFit];
        [leftLab setFrame:CGRectMake(15, (_editSecretView.height - leftLab.height)/2.0, leftLab.width, leftLab.height)];
        [_editSecretView addSubview:leftLab];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [imageView setFrame:CGRectMake(SCREEN_WIDTH - 15 - imageView.width, (_editSecretView.height - imageView.height)/2.0, imageView.width, imageView.height)];
        [_editSecretView addSubview:imageView];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, _editSecretView.height - 0.5, SCREEN_WIDTH, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_editSecretView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEditSecret)];
        [_editSecretView addGestureRecognizer:tap];
    }
    return _editSecretView;
}

- (UIView *)versionView {
    if (!_versionView) {
        _versionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.editSecretView.bottom, SCREEN_WIDTH, 50)];
        _versionView.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        leftLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        leftLab.textColor = [UIColor appTextColor];
        leftLab.text = @"版本更新";
        [leftLab sizeToFit];
        [leftLab setFrame:CGRectMake(15, (_versionView.height - leftLab.height)/2.0, leftLab.width, leftLab.height)];
        [_versionView addSubview:leftLab];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [imageView setFrame:CGRectMake(SCREEN_WIDTH - 15 - imageView.width, (_versionView.height - imageView.height)/2.0, imageView.width, imageView.height)];
        [_versionView addSubview:imageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left - 5 - 100, 0, 100, _versionView.height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
        rightLab.font = [UIFont systemFontOfSize:15];
        rightLab.text = @"V1.0.0";
        [_versionView addSubview:rightLab];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, _versionView.height - 0.5, SCREEN_WIDTH, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_versionView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVersion)];
        [_versionView addGestureRecognizer:tap];
    }
    return _versionView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_logoutBtn setTitle:@"退出" forState:(UIControlStateNormal)];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        [_logoutBtn addTarget:self action:@selector(clickLogoutButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_logoutBtn setFrame:CGRectMake((SCREEN_WIDTH - 200)/2, self.versionView.bottom + 30, 200, 44)];
        _logoutBtn.layer.cornerRadius = 8;
        _logoutBtn.backgroundColor = [UIColor appMainColor];
    }
    return _logoutBtn;
}

- (BOOL)isALLNumBER:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

@end
