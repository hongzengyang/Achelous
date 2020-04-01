//
//  OOFindQuestionVC.m
//  Achelous
//
//  Created by hzy on 2020/3/4.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOFindQuestionVC.h"
#import "OOFindQuestionModel.h"

@interface OOFindQuestionVC ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) UIView *nameView;         //问题名称
@property (nonatomic, strong) UITextField *nameTextfield;
@property (nonatomic, strong) UIView *placeView;        //发现地点
@property (nonatomic, strong) UITextField *placeTextfield;
@property (nonatomic, strong) UIView *assetsView;       //照片 视频
@property (nonatomic, strong) UILabel *assetsLab;
@property (nonatomic, strong) UIView *descView;         //问题描述
@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UIView *analyzeView;      //情况分析
@property (nonatomic, strong) UITextView *analyzeTextView;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *contentFont;

@property (nonatomic, strong) OOFindQuestionModel *model;
@end

@implementation OOFindQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor xycColorWithHex:0xF6F6F6];
    
    self.model = [[OOFindQuestionModel alloc] init];
    
    self.titleFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    self.contentFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.placeView];
    [self.view addSubview:self.assetsView];
    [self.view addSubview:self.descView];
    [self.view addSubview:self.analyzeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    __block NSInteger count = 0;
    [self.model.photoPickModel.assetsArray enumerateObjectsUsingBlock:^(OOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![NSString xy_isEmpty:obj.remoteUrl]) {
            count++;
        }
    }];
    if (count == 0) {
        self.assetsLab.textColor = [UIColor appGrayTextColor];
        self.assetsLab.text = @"已选择0张照片/视频";
    }else {
        self.assetsLab.textColor = [UIColor appTextColor];
        self.assetsLab.text = [NSString stringWithFormat:@"已选择%lu张照片/视频",count];
    }
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickRightButton {
    if ([NSString xy_isEmpty:self.model.name]) {
        [SVProgressHUD showErrorWithStatus:@"请输入问题名称"];
        return;
    }
    
    if ([NSString xy_isEmpty:self.model.place]) {
        [SVProgressHUD showErrorWithStatus:@"请输入发现地点"];
        return;
    }
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:self.model.analyze forKey:@"QKFX"];
    [param setValue:self.model.place forKey:@"SJDD"];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].AreaCode forKey:@"QYMC"];
    [param setValue:@([OOXCMgr sharedMgr].unFinishedXCModel.xc_id) forKey:@"XCID"];
    {
        CGFloat latitude = [OOXCMgr sharedMgr].userLocation.location.coordinate.latitude;
        CGFloat longitude = [OOXCMgr sharedMgr].userLocation.location.coordinate.longitude;
        NSString *location = [NSString stringWithFormat:@"%lf",latitude];
        location = [location stringByAppendingString:@","];
        location = [location stringByAppendingFormat:@"%lf",longitude];
        [param setValue:location forKey:@"SJJD"];
    }
    [param setValue:@(1) forKey:@"SJLX"];
    [param setValue:self.model.name forKey:@"SJMC"];
    [param setValue:self.model.desc forKey:@"SJMS"];
    
    __block NSString *sjzp = @"";
    {
        [self.model.photoPickModel.assetsArray enumerateObjectsUsingBlock:^(OOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![NSString xy_isEmpty:obj.remoteUrl]) {
                sjzp = [sjzp stringByAppendingString:obj.remoteUrl];
                sjzp = [sjzp stringByAppendingString:@","];
            }
        }];
        sjzp = [sjzp stringByReplacingCharactersInRange:NSMakeRange(sjzp.length - 1, 1) withString:@""];
    }
    [param setValue:sjzp forKey:@"SJZP"];
    
    
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_Upsjinfo parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }
    }];
}

#pragma mark -- Tap
- (void)clickAssets {
    [[MDPageMaster master] openUrl:@"xiaoying://oo_xc_photo_vc" action:^(MDUrlAction * _Nullable action) {
        [action setAnyObject:self.model.photoPickModel forKey:@"photoPickModel"];
    }];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.nameTextfield) {
        self.model.name = textField.text;
    }
    
    if (textField == self.placeTextfield) {
        self.model.place = textField.text;
    }
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.descTextView) {
        self.model.desc = textView.text;
    }
    
    if (textView == self.analyzeTextView) {
        self.model.analyze = textView.text;
    }
}

#pragma mark -- lazy
- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SAFE_TOP + 44)];
        
        //back
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [backBtn setImage:[UIImage imageNamed:@"mini_common_arrow_back_white"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
        [backBtn sizeToFit];
        [backBtn setFrame:CGRectMake(15, SAFE_TOP + (44 - backBtn.height) / 2.0,backBtn.width , backBtn.height)];
        [_navBar addSubview:backBtn];
        
        //record
        UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [recordBtn addTarget:self action:@selector(clickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
        [recordBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [recordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [recordBtn sizeToFit];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right, SAFE_TOP, recordBtn.left - backBtn.right, 44)];
        titleLab.text = @"发现问题";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor whiteColor];
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, self.view.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"问题名称*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_nameView addSubview:titleLab];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _nameView.width - 15 - titleLab.right - 10, Part_height)];
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.placeholder = @"请输入";
        textfield.font = self.contentFont;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_nameView addSubview:textfield];
        self.nameTextfield = textfield;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, textfield.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_nameView addSubview:separater];
        
        _nameView.backgroundColor = [UIColor whiteColor];
    }
    return _nameView;
}

- (UIView *)placeView {
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.nameView.bottom, self.view.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"发现地点*";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_placeView addSubview:titleLab];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _placeView.width - 15 - titleLab.right - 10, Part_height)];
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.placeholder = @"请输入";
        textfield.font = self.contentFont;
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_placeView addSubview:textfield];
        self.placeTextfield = textfield;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, textfield.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_placeView addSubview:separater];
        
        _placeView.backgroundColor = [UIColor whiteColor];
    }
    return _placeView;
}

- (UIView *)assetsView {
    if (!_assetsView) {
        _assetsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.placeView.bottom, self.view.width, Part_height)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, Part_height)];
        NSString *string = @"问题照片/视频";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        titleLab.userInteractionEnabled = NO;
        [_assetsView addSubview:titleLab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_common_arrow_right_n"]];
        [arrowImageView sizeToFit];
        [arrowImageView setFrame:CGRectMake(_assetsView.width - 15 - arrowImageView.width, (_assetsView.height - arrowImageView.height) / 2.0, arrowImageView.width, arrowImageView.height)];
        arrowImageView.userInteractionEnabled = NO;
        [_assetsView addSubview:arrowImageView];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right + 2, 0, arrowImageView.left - 2 - titleLab.right - 2, Part_height)];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = self.contentFont;
        rightLab.userInteractionEnabled = NO;
        [_assetsView addSubview:rightLab];
        self.assetsLab = rightLab;
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, Part_height - 0.5, arrowImageView.right - titleLab.left, 0.5)];
        separater.backgroundColor = [UIColor xycColorWithHex:0xF0F1F5 alpha:0.7];
        [_assetsView addSubview:separater];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAssets)];
        [_assetsView addGestureRecognizer:tap];
        
        _assetsView.backgroundColor = [UIColor whiteColor];
    }
    return _assetsView;
}

- (UIView *)descView {
    if (!_descView) {
        _descView = [[UIView alloc] initWithFrame:CGRectMake(0, self.assetsView.bottom + 10, self.view.width, Part_height*2)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"问题描述";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_descView addSubview:titleLab];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _descView.width - 15 - titleLab.right - 10, _descView.height)];
        textView.textAlignment = NSTextAlignmentRight;
        textView.font = self.contentFont;
        textView.delegate = self;
        [_descView addSubview:textView];
        self.descTextView = textView;
        
        _descView.backgroundColor = [UIColor whiteColor];
    }
    return _descView;
}
- (UIView *)analyzeView {
    if (!_analyzeView) {
        _analyzeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.descView.bottom + 10, self.view.width, Part_height*2)];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, Part_height)];
        NSString *string = @"情况分析";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor appTextColor] range:NSMakeRange(0, [string length])];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"*"]];
        titleLab.attributedText = attr;
        [_analyzeView addSubview:titleLab];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLab.right + 10, 0, _descView.width - 15 - titleLab.right - 10, _analyzeView.height)];
        textView.textAlignment = NSTextAlignmentRight;
        textView.font = self.contentFont;
        textView.delegate = self;
        [_analyzeView addSubview:textView];
        self.analyzeTextView = textView;
        
        _analyzeView.backgroundColor = [UIColor whiteColor];
    }
    return _analyzeView;
}


@end
