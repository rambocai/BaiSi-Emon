//
//  UIImageView+ZYExtension.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/14.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "UIImageView+ZYExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (ZYExtension)

- (void)setHeader:(NSString *)url {
    [self setCircleHeader:url];
}


// 方形头像
- (void)setRectHeader:(NSString *)url {
    
    UIImage *placeholder = [UIImage imageNamed:@"defaultUserIcon"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

// 圆形头像
- (void)setCircleHeader:(NSString *)url {
    
    // 先把占位图切成圆形
    UIImage *placeholder = [UIImage circleImage:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 下载失败直接返回
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}


@end
