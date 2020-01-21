//
//  MDPhotoPickVC.m
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "MDPhotoPickVC.h"
#import "OOReportModel.h"
#import "OOPhotoPickCell.h"
#import "OOPhotoPickEnterCell.h"
#import "LNActionSheet.h"
#import <AFNetworking/AFNetworking.h>
#import "NSFileManager+XYProperty.h"

@interface MDPhotoPickVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate>

@property (nonatomic, strong) OOReportModel *reportModel;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MDPhotoPickVC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    self.reportModel = [urlAction anyObjectForKey:@"reportModel"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];
}

#pragma mark -- Click
- (void)clickBackButton {
    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
}

- (void)clickShareButton {
    [SVProgressHUD showWithStatus:TIP_TEXT_WATING];
    __block NSInteger index = 0;
    __weak typeof(self) weakSelf = self;
    NSArray *phtotArray = [self.reportModel.photoPathArray subarrayWithRange:NSMakeRange(0, self.reportModel.photoPathArray.count - 1)];
    [phtotArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakSelf.reportModel.uploadPhotoPathArray containsObject:obj]) {
            index++;
            if (index == phtotArray.count) {
                [SVProgressHUD dismiss];
                [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
            }
        }else {
            [self uploadPhoto:obj completeBlock:^(BOOL success, id response) {
                if (success) {
                    [weakSelf.reportModel.uploadPhotoPathArray addObject:obj];
                    
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *d = (NSDictionary *)response;
                        NSDictionary *data = [d xyDictionaryForKey:@"data"];
                        NSString *uploadImageUrl = [data valueForKey:@"Url"];
                        if (![weakSelf.reportModel.serverReturnPhotoPathArray containsObject:uploadImageUrl]) {
                            [weakSelf.reportModel.serverReturnPhotoPathArray addObject:uploadImageUrl];
                        }
                    }
                }
                index++;
                if (index == phtotArray.count) {
                    [SVProgressHUD dismiss];
                    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
                }
            }];
        }
    }];
}


- (void)uploadPhoto:(NSString *)photoPath completeBlock:(OO_SERVER_BLOCK)completeBlock {
    NSDictionary *params = @{
                             @"file" : photoPath,
                             @"UserId":[[OOUserMgr sharedMgr] loginUserInfo].UserId
                             };
    NSString *fileName = [NSFileManager xy_getFileNameFromPath:photoPath];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"http://wd.km363.com/api/api/ImgUpload" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //给定数据流的数据名，文件名，文件类型（以图片为例）
        NSData *data = [NSData dataWithContentsOfFile:photoPath];
        [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
        
        /*常用数据流类型：
         @"image/png" 图片
         @“video/quicktime” 视频流
         */

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (completeBlock) {
            completeBlock(YES,resDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completeBlock) {
            completeBlock(NO,nil);
        }
    }];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.reportModel.photoPathArray.count - 1) {
        [self pickPhoto];
        return;
        
        NSMutableArray *array = [NSMutableArray new];
        NSArray *titles = @[@"相册",@"相机"];
        for (int i = 0; i < titles.count; i++) {
            LNActionSheetModel *model = [[LNActionSheetModel alloc]init];
            model.title = titles[i];
            model.sheetId = i;
            model.itemType = LNActionSheetItemNoraml;
            
            __weak typeof(self) weakSelf = self;
            model.actionBlock = ^{
                if (i == 0) {
                    [weakSelf pickPhoto];
                }
                if (i == 1) {
                    [weakSelf enterCamera];
                }
            };
            [array addObject:model];
        }
        [LNActionSheet showWithDesc:@"请选择" actionModels:[NSArray arrayWithArray:array] action:nil];
        return;
    }
}

#pragma mark -- 相机 相册
- (void)pickPhoto {
    //创建ImagePickController
    UIImagePickerController *myPicker = [[UIImagePickerController alloc]init];
    //创建源类型
    UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    myPicker.sourceType = mySourceType;
    //设置代理
    myPicker.delegate = self;
    //设置可编辑
    myPicker.allowsEditing = NO;
    //通过模态的方式推出系统相册
    [self presentViewController:myPicker animated:YES completion:^{
        NSLog(@"进入相册");
    }];
}

- (void)enterCamera {
    
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //取得所选取的图片,原大小,可编辑等，info是选取的图片的信息字典
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(selectImage, 0.3);

    NSString * path = NSTemporaryDirectory();

    NSString *timeString = [[OOAPPMgr sharedMgr] currentTimeStr];
    NSString * Pathimg = [path stringByAppendingFormat:@"%@.png",timeString];
    
//    Pathimg = [path stringByAppendingPathComponent:@"RZUserData.png"];;
//    [path stringByAppendingPathComponent:@"RZUserData.data"];

    BOOL success = [imgData writeToFile:Pathimg atomically:YES];
    if (success) {
        [self.reportModel.photoPathArray insertObject:Pathimg atIndex:0];
        [self.collectionView reloadData];
    }
    //设置图片进相框
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.reportModel.photoPathArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.reportModel.photoPathArray.count - 1) {
        OOPhotoPickEnterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OOPhotoPickEnterCell" forIndexPath:indexPath];
        return cell;
    }else {
        OOPhotoPickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OOPhotoPickCell" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        cell.clickCloseBlock = ^{
            [weakSelf.reportModel.photoPathArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        NSString *path = [self.reportModel.photoPathArray objectAtIndex:indexPath.row];
        [cell configCellWithPath:path];
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
        [recordBtn addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
        [recordBtn setTitle:@"上传" forState:(UIControlStateNormal)];
        [recordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [recordBtn sizeToFit];
        [recordBtn setFrame:CGRectMake(self.view.width - 15 - recordBtn.width, SAFE_TOP + (44 - recordBtn.height) / 2.0,recordBtn.width , recordBtn.height)];
        [_navBar addSubview:recordBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right, SAFE_TOP, recordBtn.left - backBtn.right, 44)];
        titleLab.text = @"上传照片";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:titleLab];
        
        _navBar.backgroundColor = [UIColor appMainColor];
    }
    return _navBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom + 10, self.view.width, self.view.height - SAFE_BOTTOM - self.navBar.bottom - 10) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[OOPhotoPickCell class] forCellWithReuseIdentifier:@"OOPhotoPickCell"];
        [_collectionView registerClass:[OOPhotoPickEnterCell class] forCellWithReuseIdentifier:@"OOPhotoPickEnterCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


@end
