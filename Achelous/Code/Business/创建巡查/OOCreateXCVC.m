//
//  OOCreateXCVC.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCVC.h"
#import "OOCreateXCTableView.h"
#import "OOCreateXCModel.h"
#import "OOPatrolVC.h"

@interface OOCreateXCVC ()

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) OOCreateXCTableView *tableView;
@property (nonatomic, strong) OOCreateXCModel *model;

@end

@implementation OOCreateXCVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.tableView];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
//    [[MDPageMaster master] openUrl:@"xiaoying://oo_patrol_vc" action:^(MDUrlAction * _Nullable action) {
//
//    }];
//    [self.navigationController pushViewController:[OOXCVC new] animated:YES];
//    
//    return;
    
    if (self.model.xc_type == OOCreateTypeSubType_none) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查类型"];
        return;
    }
    if (!self.model.xc_object) {
        [SVProgressHUD showErrorWithStatus:@"请选择巡查对象"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.xc_name]) {
        [SVProgressHUD showErrorWithStatus:@"请输入巡查名称"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.xc_people]) {
        [SVProgressHUD showErrorWithStatus:@"请输入巡查人员"];
        return;
    }
    if ([NSString xy_isEmpty:self.model.xc_owner]) {
        [SVProgressHUD showErrorWithStatus:@"请输入负责人"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@(self.model.xc_type) forKey:@"Xclx"];
    [param setValue:@(self.model.xc_object.objectID) forKey:@"ID"];
    [param setValue:self.model.xc_object.SKMC forKey:@"Hkname"];
    [param setValue:self.model.xc_name forKey:@"XCname"];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].AreaCode forKey:@"AreaCode"];
    
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_createXC parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD dismiss];
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                NSDictionary *data = [dic xyDictionaryForKey:@"data"];
                [OOAPPMgr sharedMgr].currentXCID = [data valueForKey:@"id"];
            }
            
            [[MDPageMaster master] openUrl:@"xiaoying://oo_patrol_vc" action:^(MDUrlAction * _Nullable action) {
                
            }];
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
        titleLab.text = @"创建巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (OOCreateXCTableView *)tableView {
    if (!_tableView) {
        _tableView = [[OOCreateXCTableView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - self.navBar.bottom - SAFE_BOTTOM) style:(UITableViewStylePlain) model:self.model];
    }
    return _tableView;
}

- (OOCreateXCModel *)model {
    if (!_model) {
        _model = [[OOCreateXCModel alloc] init];
    }
    return _model;
}

@end
