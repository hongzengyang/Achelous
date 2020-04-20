//
//  OOCheckBoxCell.m
//  Achelous
//
//  Created by hzy on 2020/4/15.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCheckBoxCell.h"

@interface OOCheckBoxCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *separater;

@end

@implementation OOCheckBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.selectImageView];
        [self addSubview:self.separater];
    }
    return self;
}

- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect {
    self.titleLab.text = title;
    if (isSelect) {
        self.titleLab.textColor = [UIColor appMainColor];
        self.titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        self.selectImageView.hidden = NO;
    }else {
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        self.selectImageView.hidden = YES;
    }
    
    [self.titleLab setFrame:self.bounds];
    [self.selectImageView setSize:CGSizeMake(20, 20)];
    [self.selectImageView setFrame:CGRectMake(self.width - 10 - self.selectImageView.width, (self.height - self.selectImageView.height)/2.0, self.selectImageView.width, self.selectImageView.height)];
    [self.separater setFrame:CGRectMake(0, 0, self.width, 0.5)];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
        _titleLab.font = [UIFont systemFontOfSize:15 ];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouxuan-3"]];
        [_selectImageView sizeToFit];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

- (UIView *)separater {
    if (!_separater) {
        _separater  = [[UIView alloc] init];
        _separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
    }
    return _separater;
}

@end
