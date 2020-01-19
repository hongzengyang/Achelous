//
//  OOUserInputView.m
//  Achelous
//
//  Created by hzy on 2020/1/19.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOUserInputView.h"

@interface OOUserInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation OOUserInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.inputText = textView.text;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _titleLab.text = @"情况描述";
        [_titleLab sizeToFit];
        [_titleLab setFrame:CGRectMake(15, 15, _titleLab.width, _titleLab.height)];
        _titleLab.textColor = [UIColor appTextColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    }
    return _titleLab;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleLab.right + 5, self.titleLab.top - 5, self.width - 15 - self.titleLab.right - 5, self.height - self.titleLab.top - 10)];
        _textView.textColor = [UIColor appTextColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
    }
    return _textView;
}

@end
