//
//  OOEndTimeView.m
//  Achelous
//
//  Created by hzy on 2020/1/19.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOEndTimeView.h"

@interface OOEndTimeView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rightLab;


@end

@implementation OOEndTimeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.rightLab];
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _titleLab.text = @"结束时间";
        _titleLab.userInteractionEnabled = NO;
    }
    return _titleLab;
}

- (UILabel *)rightLab {
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 15 - 200, 0, 200, self.height)];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        _rightLab.userInteractionEnabled = NO;
        _rightLab.textColor = [UIColor appGrayTextColor];
        _rightLab.text = [[OOAPPMgr sharedMgr] getDateString];
    }
    return _rightLab;
}

@end
