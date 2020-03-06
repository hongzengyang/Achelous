//
//  OOPhotoPickCell.m
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOPhotoPickCell.h"

@interface OOPhotoPickCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation OOPhotoPickCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.closeBtn];
}

- (void)configCellWithAsset:(PHAsset *)asset {
    [self.iconImageView setFrame:CGRectMake(12, 12, self.width - 24, self.height - 24)];
    [self.closeBtn setSize:CGSizeMake(24, 24)];
    [self.closeBtn setCenter:CGPointMake(self.iconImageView.right, self.iconImageView.top)];
    
    __weak typeof(self) weakSelf = self;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(self.width*2, self.height*2)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            weakSelf.iconImageView.image = result;
        }
    }];
}

- (void)clickCloseButton {
    if (self.clickCloseBlock) {
        self.clickCloseBlock();
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn addTarget:self action:@selector(clickCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_closeBtn setImage:[UIImage imageNamed:@"oo_close_photo_icon"] forState:(UIControlStateNormal)];
    }
    return _closeBtn;
}

@end
