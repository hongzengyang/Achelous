//
//  MDPhotoPickVC.m
//  Achelous
//
//  Created by hzy on 2020/1/20.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "MDPhotoPickVC.h"
#import "OOPhotoPickModel.h"
#import "OOPhotoPickCell.h"
#import "OOPhotoPickEnterCell.h"
#import "LNActionSheet.h"
#import <AFNetworking/AFNetworking.h>
#import "NSFileManager+XYProperty.h"

@interface MDPhotoPickVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) OOPhotoPickModel *model;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MDPhotoPickVC

- (void)handleWithURLAction:(MDUrlAction *)urlAction {
    self.model = [urlAction anyObjectForKey:@"photoPickModel"];
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
    NSArray <OOAssetModel *>*phototArray = [self.model.assetsArray subarrayWithRange:NSMakeRange(0, self.model.assetsArray.count - 1)];
    [phototArray enumerateObjectsUsingBlock:^(OOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![NSString xy_isEmpty:obj.remoteUrl]) {
            index++;
            if (index == phototArray.count) {
                [SVProgressHUD dismiss];
                [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
            }
        }else {
            [weakSelf uploadAssetModel:obj completeBlock:^(BOOL success, id response) {
                index++;
                if (index == phototArray.count) {
                    [SVProgressHUD dismiss];
                    [[MDPageMaster master].navigationContorller popViewControllerAnimated:YES];
                    
                    [self.model.assetsArray enumerateObjectsUsingBlock:^(OOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx != self.model.assetsArray.count - 1) {
                            if ([NSString xy_isEmpty:obj.remoteUrl]) {
                                [SVProgressHUD showErrorWithStatus:@"图片/视频 未全部上传"];
                                *stop = YES;
                            }
                        }
                    }];
                }
            }];
        }
    }];
}


- (void)uploadAssetModel:(OOAssetModel *)assetModel completeBlock:(OO_SERVER_BLOCK)completeBlock {
    NSString *fileName = [NSFileManager xy_getFileNameFromPath:assetModel.localCopyPath];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"video/mp4",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    //http://119.148.161.111:8008   http://wd.km363.com
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://119.148.161.111:8008/api/api/ImgUpload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //给定数据流的数据名，文件名，文件类型（以图片为例）
        NSData *data = [NSData dataWithContentsOfFile:assetModel.localCopyPath];
        if (assetModel.asset.mediaType == PHAssetMediaTypeImage) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        if (assetModel.asset.mediaType == PHAssetMediaTypeVideo) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"video/quicktime"];
        }
        
        /*常用数据流类型：
         @"image/png" 图片
         @“video/quicktime” 视频流
         */

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([resDict isKindOfClass:[NSDictionary class]]) {
            BOOL success = [[resDict xyStringForKey:@"Succeed"] boolValue];
            if (success) {
                NSDictionary *d = (NSDictionary *)resDict;
                NSDictionary *data = [d xyDictionaryForKey:@"data"];
                NSString *remoteUrl = [data valueForKey:@"Url"];
                assetModel.remoteUrl = remoteUrl;
                if (completeBlock) {
                    completeBlock(YES,resDict);
                }
            }else {
                if (completeBlock) {
                    completeBlock(NO,nil);
                }
            }
        }else {
            if (completeBlock) {
                completeBlock(NO,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completeBlock) {
            completeBlock(NO,nil);
        }
    }];

}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.assetsArray.count - 1) {
        [self pickPhoto];
    }
}

#pragma mark -- 相机 相册
- (void)pickPhoto {
    //创建ImagePickController
    UIImagePickerController *myPicker = [[UIImagePickerController alloc] init];
    //创建源类型
    UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    myPicker.sourceType = mySourceType;
    myPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:mySourceType];
    //设置代理
    myPicker.delegate = self;
    //设置可编辑
    myPicker.allowsEditing = NO;
    //通过模态的方式推出系统相册
    [self presentViewController:myPicker animated:YES completion:^{
        
    }];
}

- (void)enterCamera {
    
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    OOAssetModel *assetModel = [[OOAssetModel alloc] init];
    
    NSURL *imageAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetUrl] options:nil];
    PHAsset *asset = [result firstObject];
    assetModel.asset = asset;
    
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imgData = UIImageJPEGRepresentation(selectImage, 0.3);
        NSString * path = NSTemporaryDirectory();
        NSString *timeString = [[OOAPPMgr sharedMgr] currentTimeStr];
        NSString * Pathimg = [path stringByAppendingFormat:@"%@.png",timeString];
        BOOL success = [imgData writeToFile:Pathimg atomically:YES];
        if (success) {
            assetModel.localCopyPath = Pathimg;
            [self.model.assetsArray insertObject:assetModel atIndex:0];
        }
    }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSString *mediaPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSData *vedioData = [NSData dataWithContentsOfFile:mediaPath];
        NSString * path = NSTemporaryDirectory();
        NSString *timeString = [[OOAPPMgr sharedMgr] currentTimeStr];
        NSString * Pathimg = [path stringByAppendingFormat:@"%@.mp4",timeString];
        BOOL success = [vedioData writeToFile:Pathimg atomically:YES];
        if (success) {
          assetModel.localCopyPath = Pathimg;
          [self.model.assetsArray insertObject:assetModel atIndex:0];
        }
    }
//    //设置图片进相框
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.assetsArray.count - 1) {
        OOPhotoPickEnterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OOPhotoPickEnterCell" forIndexPath:indexPath];
        return cell;
    }else {
        OOPhotoPickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OOPhotoPickCell" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        cell.clickCloseBlock = ^{
            [weakSelf.model.assetsArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        OOAssetModel *model = [self.model.assetsArray objectAtIndex:indexPath.row];
        [cell configCellWithAsset:model.asset];
        
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
