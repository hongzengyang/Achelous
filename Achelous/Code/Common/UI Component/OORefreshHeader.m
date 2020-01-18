//
//  OORefreshHeader.m
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OORefreshHeader.h"

@interface OORefreshHeader ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation OORefreshHeader

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    self.backgroundColor = [UIColor clearColor];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor xycColorWithHex:0x999999];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"加载中...";
    self.label.hidden = YES;
    [self addSubview:self.label];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self addSubview:self.loadingView];
    
    self.mj_h = 64;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    [self.loadingView setFrame:CGRectMake((self.mj_w - 30) / 2.0, 10, 30, 30)];
    
    [self.label sizeToFit];
    [self.label setFrame:CGRectMake((self.mj_w - self.label.width)/2.0, self.loadingView.bottom + 5, self.label.width, self.label.height)];
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.loadingView.hidden = NO;
            [self.loadingView stopAnimating];
            
            self.label.hidden = YES;
            break;
        case MJRefreshStatePulling:
            self.loadingView.hidden = NO;
            [self.loadingView stopAnimating];
            
            self.label.hidden = YES;
            break;
        case MJRefreshStateWillRefresh:
            self.loadingView.hidden = NO;
            [self.loadingView stopAnimating];
            
            self.label.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
            
            self.label.hidden = NO;
            break;
        default:
            self.loadingView.hidden = NO;
            [self.loadingView stopAnimating];
            
            self.label.hidden = YES;
            break;
    }
}
@end
