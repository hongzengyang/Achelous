//
//  OOXCTrackPageCell.m
//  Achelous
//
//  Created by hzy on 2020/1/18.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOXCTrackPageCell.h"

@interface OOXCTrackPageCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;
@property (nonatomic, strong) UIView *separater;

@end

@implementation OOXCTrackPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.startLab];
        [self addSubview:self.endLab];
        [self addSubview:self.separater];
    }
    return self;
}

- (void)configCellWithModel:(OOXCTrackPageModel *)model {
    self.titleLab.text = model.XCMC;
    self.startLab.text = [NSString stringWithFormat:@"开始时间:%@",model.SJQ];
    self.endLab.text = [NSString stringWithFormat:@"结束时间:%@",model.SJZ];
    
    [self.titleLab setFrame:CGRectMake(15, 10, self.width - 30, 20)];
    [self.startLab setFrame:CGRectMake(15, self.titleLab.bottom + 5, self.width - 30, 15)];
    [self.endLab setFrame:CGRectMake(15, self.startLab.bottom + 5, self.width - 30, 15)];
    [self.separater setFrame:CGRectMake(15, self.height - 0.5, self.width - 30, 0.5)];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)startLab {
    if (!_startLab) {
        _startLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _startLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
        _startLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _startLab.textAlignment = NSTextAlignmentLeft;
    }
    return _startLab;
}

- (UILabel *)endLab {
    if (!_endLab) {
        _endLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _endLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
        _endLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _endLab.textAlignment = NSTextAlignmentLeft;
    }
    return _endLab;
}

- (UIView *)separater {
    if (!_separater) {
        _separater   = [[UIView alloc] init];
        _separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5];
    }
    return _separater;
}


@end
