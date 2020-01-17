//
//  OOHomeHeaderView.m
//  Achelous
//
//  Created by hzy on 2020/1/16.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeHeaderView.h"

@interface OOHomeHeaderView ()

@property (nonatomic, strong) OOHomeModel *homeModel;

@end

@implementation OOHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame model:(nonnull OOHomeModel *)model {
    if (self = [super initWithFrame:frame]) {
        self.homeModel = model;
        [self configUI];
        [self fetchData];
    }
    return self;
}

- (void)configUI {
    
}

- (void)fetchData {
    [self.homeModel fetchHomeDataWithCompleteBlock:^(BOOL complete) {
        
    }];
}


@end
