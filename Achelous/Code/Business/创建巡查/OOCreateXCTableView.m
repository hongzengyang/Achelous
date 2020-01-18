//
//  OOCreateXCTableView.m
//  Achelous
//
//  Created by hzy on 2020/1/17.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOCreateXCTableView.h"
#import "OOCreateXCTableViewCell.h"
#import "LNActionSheet.h"
#import <YYModel/YYModel.h>

@interface OOCreateXCTableView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) OOCreateXCModel *model;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *peopleField;
@property (nonatomic, strong) UITextField *ownerField;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation OOCreateXCTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style model:(nonnull OOCreateXCModel *)model {
    if (self = [super initWithFrame:frame style:style]) {
        self.model = model;
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[OOCreateXCTableViewCell class] forCellReuseIdentifier:@"OOCreateXCTableViewCell"];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = footer;
        
        self.dataList = @[@(OOCreateXCType_type),@(OOCreateXCType_object),@(OOCreateXCType_name),@(OOCreateXCType_people),@(OOCreateXCType_startTime),@(OOCreateXCType_owner)];
    
        [self reloadData];
        
        [self addSubview:self.peopleField];
        [self addSubview:self.nameField];
        [self addSubview:self.ownerField];
    }
    return self;
}

#pragma mark -- UITextField
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.model.currentSelectType == OOCreateXCType_name) {
        self.model.xc_name = textField.text;
    }
    if (self.model.currentSelectType == OOCreateXCType_people) {
        self.model.xc_people = textField.text;
    }
    if (self.model.currentSelectType == OOCreateXCType_owner) {
        self.model.xc_owner = textField.text;
    }
    
    [self reloadData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OOCreateXCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OOCreateXCTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preTableView = self;
    cell.model = self.model;
    NSNumber *number = [self.dataList objectAtIndex:indexPath.row];
    [cell configCellWithType:[number integerValue]];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.model.currentSelectType = indexPath.row + 1;
    
    NSNumber *number = [self.dataList objectAtIndex:indexPath.row];
    OOCreateXCType type = (OOCreateXCType)[number integerValue];
    if (type == OOCreateXCType_type) {
        [self endEditing:YES];
        [self handleXCType];
    }
    
    if (type == OOCreateXCType_object) {
        [self endEditing:YES];
        if (self.model.xc_type == OOCreateTypeSubType_none) {
            [SVProgressHUD showErrorWithStatus:@"请选择巡查类型"];
            return;
        }
        [self handleXCObject];
    }
    
    if (type == OOCreateXCType_name) {
        [self.nameField becomeFirstResponder];
    }
    if (type == OOCreateXCType_people) {
        [self.peopleField becomeFirstResponder];
    }
    if (type == OOCreateXCType_owner) {
        [self.ownerField becomeFirstResponder];
    }
}

- (void)handleXCType {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *titles = @[@"湖库",@"渠道",@"河段"];
    for (int i = 0; i < titles.count; i++) {
        LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
        model.title = titles[i];
        model.sheetId = i;
        model.itemType = LNActionSheetItemNoraml;
        
        __weak typeof(self) weakSelf = self;
        model.actionBlock = ^{
            if (weakSelf.model.xc_type == i) {
                return;
            }
            weakSelf.model.xc_type = i;
            weakSelf.model.xc_object = nil;
            [weakSelf reloadData];
        };
        [array addObject:model];
    }
    [LNActionSheet showWithDesc:@"巡查类型" actionModels:[NSArray arrayWithArray:array] action:nil];
}

- (void)handleXCObject {
    __weak typeof(self) weakSelf = self;
    void(^actionSheetBlock)(void) = ^ {
        NSMutableArray *array = [NSMutableArray new];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [weakSelf.model.xc_objectList enumerateObjectsUsingBlock:^(OOXCObjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.SKMC];
        }];
        if (titles.count > 0) {
            for (int i = 0; i < titles.count; i++) {
                LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
                model.title = titles[i];
                model.sheetId = i;
                model.itemType = LNActionSheetItemNoraml;
                
                __weak typeof(self) weakSelf = self;
                model.actionBlock = ^{
                    weakSelf.model.xc_object = [weakSelf.model.xc_objectList objectAtIndex:i];
                    weakSelf.model.xc_name = [NSString stringWithFormat:@"%@巡查",weakSelf.model.xc_object.SKMC];
                    [weakSelf reloadData];
                };
                [array addObject:model];
            }
            [LNActionSheet showWithDesc:@"巡查对象" actionModels:[NSArray arrayWithArray:array] action:nil];
        }
    };
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[OOUserMgr sharedMgr] loginUserInfo].UserId forKey:@"UserId"];
    [param setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.model.xc_type] forKey:@"Xclx"];
    [[OOServerService sharedInstance] postWithUrlKey:kApi_patrol_returnhk parameters:param options:nil block:^(BOOL success, id response) {
        if (success) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                NSArray *data = [dic xyArrayForKey:@"data"];
                
                if (data.count > 0) {
                    [weakSelf.model.xc_objectList removeAllObjects];
                    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *d = (NSDictionary *)obj;
                            OOXCObjectModel *model = [OOXCObjectModel yy_modelWithJSON:d];
                            [weakSelf.model.xc_objectList addObject:model];
                        }
                    }];
                }
            }
            
            actionSheetBlock();
        }
    }];
}

#pragma mark -- Lazy
- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _nameField.delegate = self;
        [_nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nameField.hidden = YES;
    }
    return _nameField;
}

- (UITextField *)peopleField {
    if (!_peopleField) {
        _peopleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _peopleField.delegate = self;
        [_peopleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _peopleField.hidden = YES;
    }
    return _peopleField;
}

- (UITextField *)ownerField {
    if (!_ownerField) {
        _ownerField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _ownerField.delegate = self;
        [_ownerField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _ownerField.hidden = YES;
    }
    return _ownerField;
}

@end
