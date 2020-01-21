//
//  OOH5VC.m
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOH5VC.h"
#import <WebKit/WebKit.h>

@interface OOH5VC ()

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *titleText;

@end

@implementation OOH5VC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    self.linkUrl = [urlAction stringForKey:@"linkUrl"];
    self.titleText = [urlAction stringForKey:@"titleText"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]]];
}


#pragma mark -- Click
- (void)clickBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
    }
}

- (void)clickCloseButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}


- (void)clickShareButton {
    [self.webView reload];
}


#pragma mark -- lazy
- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SAFE_TOP + 44)];
        
        //back
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [closeBtn setImage:[UIImage imageNamed:@"mini_common_arrow_back_white"] forState:(UIControlStateNormal)];
        [closeBtn addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
        [closeBtn sizeToFit];
        [closeBtn setFrame:CGRectMake(15, SAFE_TOP + (44 - closeBtn.height) / 2.0,closeBtn.width , closeBtn.height)];
        [_navBar addSubview:closeBtn];
        
        //record
        UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [recordBtn addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
        [recordBtn setImage:[UIImage imageNamed:@"oo_h5_reload"] forState:(UIControlStateNormal)];
        [recordBtn setSize:CGSizeMake(23, 23)];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(closeBtn.right, SAFE_TOP, recordBtn.left - closeBtn.right, 44)];
        titleLab.text = self.titleText;
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        //back
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backBtn setImage:[UIImage imageNamed:@"oo_close_icon"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(clickCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
        [backBtn setSize:CGSizeMake(15, 15)];
        [backBtn setFrame:CGRectMake(closeBtn.right + 18, SAFE_TOP + (44 - backBtn.height) / 2.0,backBtn.width , backBtn.height)];
        [_navBar addSubview:backBtn];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, SCREEN_WIDTH, self.view.height - SAFE_BOTTOM - self.navBar.bottom)];
    }
    return _webView;
}

@end
