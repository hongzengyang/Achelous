//
//  OOHomeCollectionCell.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOHomeCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OOHomeCollectionCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation OOHomeCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLab];
}

- (void)updateCellWithModel:(OOHomeDataMenuModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.titleLab.text = model.name;
    
    [self.iconImageView setFrame:CGRectMake((self.width - 60)/2.0, 10, 60, 60)];
    [self.titleLab setFrame:CGRectMake(0, self.height - 26, self.width, 26)];
    
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    }
    return _titleLab;
}

@end
