//
//  OOXCTrackPageVC.m
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCTrackPageVC.h"
#import "OOXCTrackPageCell.h"
#import "OORefreshHeader.h"
#import "OORefreshFooter.h"
#import "OOXCTrackPageModel.h"
#import <YYModel/YYModel.h>


@interface OOXCTrackPageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation OOXCTrackPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.tableView];
    
    [self fetchFirstPage];
}

#pragma mark -- Data
- (void)fetchFirstPage {
    self.currentPage = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@(self.currentPage) forKey:@"page"];
    __weak typeof(self) weakSelf = self;
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xclist parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [weakSelf handleResponse:response isFirst:YES];
            
            [weakSelf.tableView.mj_header endRefreshing];
            
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)loadMore {
    self.currentPage += 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@(self.currentPage) forKey:@"page"];
    __weak typeof(self) weakSelf = self;
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xclist parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [weakSelf handleResponse:response isFirst:NO];
            
            if (self.totalCount < 10) {
                self.tableView.mj_footer = nil;
            }
            
            if (self.totalCount > self.dataList.count) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)handleResponse:(id)response isFirst:(BOOL)isFirst {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary *data = [dic xyDictionaryForKey:@"data"];
        self.totalCount = [[data valueForKey:@"total"] integerValue];
        NSArray *rows = [data xyArrayForKey:@"rows"];
        if (rows.count > 0) {
            if (isFirst) {
                [self.dataList removeAllObjects];
            }
            [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *d = (NSDictionary *)obj;
                    OOXCTrackPageModel *model = [OOXCTrackPageModel yy_modelWithJSON:d];
                    [self.dataList addObject:model];
                }
            }];
        }
    }
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OOXCTrackPageModel *model = [self.dataList objectAtIndex:indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:@(model.modelID) forKey:@"Xcid"];
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Xczblist parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD dismiss];
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_track_vc" action:^(MDUrlAction * _Nullable action) {
                    [action setAnyObject:dic forKey:@"responce"];
                }];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:TIP_TEXT_NETWORK_ERRROE];
        }
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OOXCTrackPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OOXCTrackPageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OOXCTrackPageModel *model = [self.dataList objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
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
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 200)/2, SAFE_TOP, 200, 44)];
        titleLab.text = @"历史巡查";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height - SAFE_BOTTOM - self.navBar.bottom) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[OOXCTrackPageCell class] forCellReuseIdentifier:@"OOXCTrackPageCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [OORefreshHeader headerWithRefreshingBlock:^{
            [weakSelf fetchFirstPage];
        }];
        
        _tableView.mj_footer = [OORefreshFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
