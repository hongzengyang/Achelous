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

- (void)configCellWithAsset:(OOAssetModel *)model {
    [self.iconImageView setFrame:CGRectMake(12, 12, self.width - 24, self.height - 24)];
    [self.closeBtn setSize:CGSizeMake(24, 24)];
    [self.closeBtn setCenter:CGPointMake(self.iconImageView.right, self.iconImageView.top)];
    
    if (model.assetType == PHAssetMediaTypeImage) {
        self.iconImageView.image = [UIImage imageWithContentsOfFile:model.localCopyPath];
    }else {
        self.iconImageView.image = [self thumbnailImageForVideoPath:model.localCopyPath atTime:0.1];
    }
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


//videoURL:本地视频路径(如果想获取网络图片，只要替换NSURL方式即可)    time：用来控制视频播放的时间点图片截取
- (UIImage *)thumbnailImageForVideoPath:(NSString *)videoPath atTime:(NSTimeInterval)time {
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    if (!asset) {
        return nil;
    };
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;

    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];

    if(!thumbnailImageRef) {
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }

    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;

    return thumbnailImage;
}

@end
