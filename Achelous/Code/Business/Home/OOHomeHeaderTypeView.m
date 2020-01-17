//
//  OOHomeHeaderTypeView.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeHeaderTypeView.h"

@interface OOHomeHeaderTypeView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, copy) NSString *strTitle;

@end

@implementation OOHomeHeaderTypeView
- (instancetype)initWithFrame:(CGRect)frame title:(nonnull NSString *)strTitle {
    if (self = [super initWithFrame:frame]) {
        self.strTitle = strTitle;
        
        [self addSubview:self.titleLab];
        [self addSubview:self.countLab];
    }
    return self;
}

- (void)updateCount:(NSString *)strCount {
    self.countLab.text = strCount;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.text = self.strTitle;
        _titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    }
    return _titleLab;
}

- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 30, self.width, 30)];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.textColor = [UIColor appTextColor];
        _countLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    }
    return _countLab;
}


@end
