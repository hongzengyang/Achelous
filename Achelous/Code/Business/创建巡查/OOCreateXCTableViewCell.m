//
//  OOCreateXCTableViewCell.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCTableViewCell.h"

@interface OOCreateXCTableViewCell ()

@property (nonatomic, assign) OOCreateXCType type;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *separater;

@end

@implementation OOCreateXCTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleLab];
    [self addSubview:self.rightLab];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.separater];
}

- (void)configCellWithType:(OOCreateXCType)type {
    if (type == OOCreateXCType_type) {
        self.titleLab.text = @"巡查类型";
        
        if (self.model.xc_type == OOCreateTypeSubType_none) {
            self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
            self.rightLab.text = @"请选择";
        }else {
            self.rightLab.textColor = [UIColor appTextColor];
            if (self.model.xc_type == OOCreateTypeSubType_huku) {
                self.rightLab.text = @"湖库";
            }else if (self.model.xc_type == OOCreateTypeSubType_qudao) {
                self.rightLab.text = @"渠道";
            }else if (self.model.xc_type == OOCreateTypeSubType_heduan) {
                self.rightLab.text = @"河段";
            }
        }
        
        self.arrowImageView.hidden = NO;
    }else if (type == OOCreateXCType_object) {
        self.titleLab.text = @"巡查对象";
        
        if (!self.model.xc_object) {
            self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
            self.rightLab.text = @"请选择";
        }else {
            self.rightLab.textColor = [UIColor appTextColor];
            self.rightLab.text = self.model.xc_object.SKMC;
        }
        
        self.arrowImageView.hidden = NO;
    }else if (type == OOCreateXCType_name) {
        self.titleLab.text = @"巡查名称(可输入)";
        if ([NSString xy_isEmpty:self.model.xc_name]) {
            self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
            self.rightLab.text = @"请输入";
        }else {
            self.rightLab.text = self.model.xc_name;
            self.rightLab.textColor = [UIColor appTextColor];
        }
        
        self.arrowImageView.hidden = YES;
    }else if (type == OOCreateXCType_people) {
        self.titleLab.text = @"巡查人员(可输入)";
        if ([NSString xy_isEmpty:self.model.xc_people]) {
            self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
            self.rightLab.text = @"请输入";
        }else {
            self.rightLab.text = self.model.xc_people;
            self.rightLab.textColor = [UIColor appTextColor];
        }
        
        self.arrowImageView.hidden = YES;
    }else if (type == OOCreateXCType_startTime) {
        self.titleLab.text = @"开始时间";
        
        NSString *time = [self getDateStringWithTimeStr:[self currentTimeStr]];
        self.rightLab.text = time;
        self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
        
        self.arrowImageView.hidden = YES;
    }else if (type == OOCreateXCType_owner) {
        self.titleLab.text = @"负责人(可输入)";
        if ([NSString xy_isEmpty:self.model.xc_owner]) {
            self.rightLab.textColor = [UIColor xycColorWithHex:0x45454D alpha:0.6];
            self.rightLab.text = @"请输入";
        }else {
            self.rightLab.text = self.model.xc_owner;
            self.rightLab.textColor = [UIColor appTextColor];
        }
        
        self.arrowImageView.hidden = YES;
    }
    
    [self.titleLab sizeToFit];
    [self.titleLab setFrame:CGRectMake(15, 0, self.titleLab.width, self.height)];
    
    [self.arrowImageView setFrame:CGRectMake(self.width - 15 - self.arrowImageView.width, (self.height - self.arrowImageView.height)/2, self.arrowImageView.width, self.arrowImageView.height)];
    [self.rightLab sizeToFit];
    [self.rightLab setFrame:CGRectMake(self.arrowImageView.left - 4 - self.rightLab.width, 0, self.rightLab.width, self.height)];
}

//获取当前时间戳
- (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    }
    return _titleLab;
}

- (UILabel *)rightLab {
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _rightLab.textAlignment = NSTextAlignmentLeft;
        _rightLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    }
    return _rightLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

- (UIView *)separater {
    if (!_separater) {
        _separater = [[UIView alloc] init];
        _separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
    }
    return _separater;
}

@end
