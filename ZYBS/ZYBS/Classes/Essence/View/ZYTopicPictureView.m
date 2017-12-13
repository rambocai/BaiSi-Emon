//
//  ZYTopicPictureView.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/10.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "ZYTopic.h"
#import <AFNetworking.h>
#import <DALabeledCircularProgressView.h>
#import "ZYSeeBigViewController.h"

@interface ZYTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;


@end

@implementation ZYTopicPictureView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 从xib中加载进来的控件autoresizingMask默认是UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ZYLog(@"%zd", self.autoresizingMask);
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBig)]];
}

- (void)setTopic:(ZYTopic *)topic {
    _topic = topic;
    
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // receivedSize : 已经接收的图片大小
        // expectedSize : 图片的总大小
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = progress;
        self.progressView.hidden = NO;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.progressView.hidden = YES;
    }];
    
    
    // 是否是gif图片
    //if ([topic.large_image.lowercaseString hasSuffix:@"gif"])
    //if ([topic.large_image.pathExtension.lowercaseString isEqualToString:@"gif"])
//    if (topic.is_gif) {
//        self.gifView.hidden = NO;
//    } else {
//        self.gifView.hidden = YES;
//    }
    self.gifView.hidden = !topic.is_gif;
    
    // 查看大图
    if (topic.isBigPicture) { // 超长图片
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
}

- (void)seeBig {
    ZYSeeBigViewController *seeBig = [[ZYSeeBigViewController alloc] init];
    seeBig.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBig animated:YES completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
