//
//  OORefreshFooter.m
//  XYVivaMiniTemplate
//
//  Created by hzy on 2019/8/15.
//


#import "OORefreshFooter.h"
//#import <Masonry/Masonry.h>

@interface OORefreshFooter ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation OORefreshFooter


- (void)prepare {
    [super prepare];
    self.backgroundColor = [UIColor clearColor];
    
    // 设置控件的高度
    self.mj_h = 44;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"没有更多内容了";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1.0];
    [self.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:self.titleLabel];
    
    self.activityIndicator = [UIActivityIndicatorView new];
    self.activityIndicator.hidesWhenStopped = NO;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:self.activityIndicator];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    switch (self.state) {
        case MJRefreshStateIdle:
        case MJRefreshStatePulling:
        case MJRefreshStateRefreshing:
            [self.activityIndicator startAnimating];
            self.activityIndicator.hidden = NO;
            self.titleLabel.hidden = NO;
            
            self.titleLabel.text = @"加载中...";
            [self.titleLabel sizeToFit];
            CGFloat indicatorWidth = self.activityIndicator.width;
            CGFloat titleWidth = self.titleLabel.width;
            CGFloat separater = 10;
            CGFloat totalWidth = indicatorWidth + titleWidth + separater;
            
            [self.activityIndicator setFrame:CGRectMake((self.mj_w - totalWidth)/2.0, (self.mj_h - self.activityIndicator.height)/2.0, self.activityIndicator.width, self.activityIndicator.height)];
            [self.titleLabel setFrame:CGRectMake(self.activityIndicator.right + separater, (self.mj_h - self.titleLabel.height)/2.0, self.titleLabel.width, self.titleLabel.height)];
            
            
            break;
        case MJRefreshStateNoMoreData:
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            self.titleLabel.hidden = NO;
            self.titleLabel.text = @"没有更多内容了";
            [self.titleLabel sizeToFit];
            self.titleLabel.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
        default:
            break;
    }
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

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            break;
        case MJRefreshStateNoMoreData:
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

@end

