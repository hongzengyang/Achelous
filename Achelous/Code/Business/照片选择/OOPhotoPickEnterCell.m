//
//  OOPhotoPickEnterCell.m
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOPhotoPickEnterCell.h"

@interface OOPhotoPickEnterCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation OOPhotoPickEnterCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.iconImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake((self.width - 60)/2, (self.height - 60)/2, 60, 60);
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oo_addphoto_icon"]];
    }
    return _iconImageView;
}

@end
