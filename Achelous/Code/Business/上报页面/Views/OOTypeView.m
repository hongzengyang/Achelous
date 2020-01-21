//
//  OOTypeView.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOTypeView.h"
#import "LNActionSheet.h"

@interface OOTypeView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *separater;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) OOTypeViewType type;
@property (nonatomic, strong) OOReportModel *model;

@end

@implementation OOTypeView

- (instancetype)initWithFrame:(CGRect)frame type:(OOTypeViewType)type model:(nonnull OOReportModel *)model {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.model = model;
        [self configUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.titleLab];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.rightLab];
    [self addSubview:self.textField];
    [self addSubview:self.separater];
}

- (void)update {
    if (self.type == OOTypeViewType_photo) {
        self.rightLab.text = [NSString stringWithFormat:@"已选择%ld张照片",self.model.photoPathArray.count - 1];
    }
}

- (void)tap {
    if (self.type == OOTypeViewType_category) {
        if (self.model.typeIndex == 3) {
            return;
        }
        NSMutableArray *array = [NSMutableArray new];
        NSArray *titles;
        if (self.model.typeIndex == 0) {
            titles = [[OOXCMgr sharedMgr] SLCategoryArray];
        }else if (self.model.typeIndex == 1) {
            titles = [[OOXCMgr sharedMgr] WRCategoryArray];
        }else if (self.model.typeIndex == 2) {
            titles = [[OOXCMgr sharedMgr] XQCategoryArray];
        }
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < titles.count; i++) {
            LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
            model.title = titles[i];
            model.sheetId = i;
            model.itemType = LNActionSheetItemNoraml;
            
            model.actionBlock = ^{
                weakSelf.rightLab.text = titles[i];
                weakSelf.model.categoryText = titles[i];
            };
            [array addObject:model];
        }
        [LNActionSheet showWithDesc:@"事件分类" actionModels:[NSArray arrayWithArray:array] action:nil];
    }
    
    if (self.type == OOTypeViewType_photo) {
        [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_photo_vc" action:^(MDUrlAction * _Nullable action) {
            [action setAnyObject:self.model forKey:@"reportModel"];
        }];
    }
}

#pragma mark -- UITextField
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.type == OOTypeViewType_name) {
        self.model.nameText = textField.text;
    }
    
    if (self.type == OOTypeViewType_place) {
        self.model.placeText = textField.text;
    }
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        if (self.type == OOTypeViewType_type) {
            _titleLab.text = @"事件类型";
        }else if (self.type == OOTypeViewType_category) {
            _titleLab.text = @"事件分类";
        }else if (self.type == OOTypeViewType_name) {
            _titleLab.text = @"事件名称";
        }else if (self.type == OOTypeViewType_place) {
            _titleLab.text = @"事件地点";
        }else if (self.type == OOTypeViewType_photo) {
            _titleLab.text = @"事件照片";
        }
        _titleLab.userInteractionEnabled = NO;
    }
    return _titleLab;
}

- (UILabel *)rightLab {
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(self.arrowImageView.left - 4 - 150, 0, 150, self.height)];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        _rightLab.userInteractionEnabled = NO;
        
        if (self.type == OOTypeViewType_type) {
            _rightLab.text = [[[OOXCMgr sharedMgr] reportTypeArray] objectAtIndex:self.model.typeIndex];
        }else if (self.type == OOTypeViewType_category) {
            _rightLab.text = @"请选择";
        }else if (self.type == OOTypeViewType_name) {
            _rightLab.hidden = YES;
        }else if (self.type == OOTypeViewType_place) {
            _rightLab.hidden = YES;
        }else if (self.type == OOTypeViewType_photo) {
            _rightLab.text = [NSString stringWithFormat:@"已选择%ld张照片",self.model.photoPathArray.count - 1];
        }
    }
    return _rightLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        _arrowImageView.hidden = YES;
        [_arrowImageView sizeToFit];
        [_arrowImageView setFrame:CGRectMake(self.width - 15 - _arrowImageView.width, (self.height - _arrowImageView.height) / 2.0, _arrowImageView.width, _arrowImageView.height)];
        _arrowImageView.userInteractionEnabled = NO;
        
        if (self.type == OOTypeViewType_type) {
            _arrowImageView.hidden = YES;
        }else if (self.type == OOTypeViewType_category) {
            _arrowImageView.hidden = NO;
        }else if (self.type == OOTypeViewType_name) {
            _arrowImageView.hidden = YES;
        }else if (self.type == OOTypeViewType_place) {
            _arrowImageView.hidden = YES;
        }else if (self.type == OOTypeViewType_photo) {
            _arrowImageView.hidden = NO;
        }
    }
    return _arrowImageView;
}

- (UIView *)separater {
    if (!_separater) {
        _separater = [[UIView alloc] initWithFrame:CGRectMake(15, self.height - 0.5, self.width - 15, 0.5)];
        _separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
    }
    return _separater;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 15 - 160, 0, 160, self.height)];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholder = @"请输入";
        _textField.font = [UIFont systemFontOfSize:15];
        if (self.type == OOTypeViewType_type) {
            _textField.hidden = YES;
        }else if (self.type == OOTypeViewType_category) {
            _textField.hidden = YES;
        }else if (self.type == OOTypeViewType_name) {
            _textField.hidden = NO;
        }else if (self.type == OOTypeViewType_place) {
            _textField.hidden = NO;
        }else if (self.type == OOTypeViewType_photo) {
            _textField.hidden = YES;
        }
    }
    return _textField;
}


@end
