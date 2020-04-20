//
//  OOCheckBox.m
//  Achelous
//
//  Created by hzy on 2020/4/15.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCheckBox.h"
#import "UIViewController+XYVisible.h"
#import "OOCheckBoxCell.h"

#define part_height  50
#define container_width 250

@interface OOCheckBox ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *>*dataList;
@property (nonatomic, strong) NSMutableArray <NSString *>*selectedDataList;
@property (nonatomic, assign) BOOL multiSelect;
@property (nonatomic, copy) NSString *boxTitle;
@property (nonatomic, copy) dismissBlock block;

@end

@implementation OOCheckBox
+ (void)configWithDataList:(NSArray *)dataList multiSelect:(BOOL)multiSelect selectedDataList:(NSArray *)selectedDataList boxTitle:(NSString *)title dismissBlock:(nonnull dismissBlock)dismissBlock {
    OOCheckBox *view = [[OOCheckBox alloc] init];
    view.dataList = dataList;
    view.selectedDataList = [[NSMutableArray alloc] init];
    [view.selectedDataList addObjectsFromArray:selectedDataList];
    view.multiSelect = multiSelect;
    view.boxTitle = title;
    view.block = dismissBlock;
    [view configUI];
    UIViewController *topWindow = [UIViewController xy_topVisibleViewControllerOnKeyWindow];
    [topWindow.view addSubview:view];
    [topWindow.view bringSubviewToFront:view];
}

- (void)configUI {
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backgroundColor = [UIColor xycColorWithHex:0x000000 alpha:0.6];
    
    CGFloat containerHeight = (self.dataList.count + 1 + 1) * part_height;
    if (containerHeight > SCREEN_HEIGHT - SAFE_TOP - SAFE_BOTTOM - 100) {
        containerHeight = SCREEN_HEIGHT - SAFE_TOP - SAFE_BOTTOM - 100;
    }
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - container_width)/2.0, (SCREEN_HEIGHT - containerHeight)/2.0, container_width, containerHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.masksToBounds = YES;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.width, part_height)];
    titleLab.text = self.boxTitle;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, part_height, self.containerView.width, self.containerView.height - part_height - part_height) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[OOCheckBoxCell class] forCellReuseIdentifier:@"OOCheckBoxCell"];
    [self.containerView addSubview:tableView];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"确定" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    [button addTarget:self action:@selector(clickOKButton) forControlEvents:(UIControlEventTouchUpInside)];
    [button setFrame:CGRectMake(0, self.containerView.height - part_height, self.containerView.width, part_height)];
    [self.containerView addSubview:button];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, button.top, self.containerView.width, 0.5)];
    sep.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
    [self.containerView addSubview:sep];
}

- (void)clickOKButton {
    if (self.block) {
        self.block([self.selectedDataList copy]);
    }
    [self removeFromSuperview];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return part_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *curText = [self.dataList objectAtIndex:indexPath.row];
    BOOL selected = [self.selectedDataList containsObject:curText];
    if (selected) {
        [self.selectedDataList removeObject:curText];
    }else {
        [self.selectedDataList addObject:curText];
    }
    [self.tableView reloadData];
    
    if (!self.multiSelect) {
        if (self.block) {
            self.block([self.selectedDataList copy]);
        }
        [self removeFromSuperview];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OOCheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OOCheckBoxCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *curText = [self.dataList objectAtIndex:indexPath.row];
    [cell configCellWithTitle:curText isSelect:[self.selectedDataList containsObject:curText] ? YES : NO];
    return cell;
}

@end
