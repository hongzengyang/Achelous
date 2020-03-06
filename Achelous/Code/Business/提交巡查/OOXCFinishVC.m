//
//  OOXCFinishVC.m
//  Achelous
//
//  Created by hzy on 2020/1/19.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCFinishVC.h"
#import "OOEndTimeView.h"
#import "OOUserInputView.h"

@interface OOXCFinishVC ()

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) OOEndTimeView *endTimeView;
@property (nonatomic, strong) OOUserInputView *firstInputView;
@property (nonatomic, strong) OOUserInputView *secondInputView;

@end

@implementation OOXCFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.endTimeView];
    [self.view addSubview:self.firstInputView];
    [self.view addSubview:self.secondInputView];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    [self.view endEditing:YES];
    
//    if ([NSString xy_isEmpty:self.firstInputView.inputText]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入交办问题"];
//        return;
//    }
//
//    if ([NSString xy_isEmpty:self.secondInputView.inputText]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入河长意见"];
//        return;
//    }
    
    if ([NSString xy_isEmpty:self.firstInputView.inputText]) {
        self.firstInputView.inputText = @"";
    }
    
    if ([NSString xy_isEmpty:self.secondInputView.inputText]) {
        self.secondInputView.inputText = @"";
    }
    
//    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"XCID"];
    [param setValue:self.firstInputView.inputText forKey:@"Xctitle"];
    [param setValue:self.secondInputView.inputText forKey:@"Xcinfo"];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Endxc parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"巡查提交成功"];
            [OOXCMgr sharedMgr].unFinishedXCModel = nil;
            
            [[MDPageMaster master].navigationContorller.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([NSStringFromClass([obj class]) isEqualToString:@"OOHomeVC"]) {
                    [[MDPageMaster master].navigationContorller popToViewController:obj withAnimation:YES];
                    *stop = YES;
                }
            }];
            
            [[OOXCMgr sharedMgr] finishUpdatingLocation];
        }else {
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
        }
    }];
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
        titleLab.text = @"结束巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (OOEndTimeView *)endTimeView {
    if (!_endTimeView) {
        _endTimeView = [[OOEndTimeView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, 50)];
        _endTimeView.backgroundColor = [UIColor whiteColor];
    }
    return _endTimeView;
}

- (OOUserInputView *)firstInputView {
    if (!_firstInputView) {
        _firstInputView = [[OOUserInputView alloc] initWithFrame:CGRectMake(0, self.endTimeView.bottom + 10, self.view.width, Part_height * 2) title:@"交办问题"];
        _firstInputView.backgroundColor = [UIColor whiteColor];
    }
    return _firstInputView;
}

- (OOUserInputView *)secondInputView {
    if (!_secondInputView) {
        _secondInputView = [[OOUserInputView alloc] initWithFrame:CGRectMake(0, self.firstInputView.bottom + 10, self.view.width, Part_height * 2) title:@"河长意见"];
        _secondInputView.backgroundColor = [UIColor whiteColor];
    }
    return _secondInputView;
}

@end
