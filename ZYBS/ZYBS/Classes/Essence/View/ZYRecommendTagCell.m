//
//  ZYRecommendTagCell.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/13.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYRecommendTagCell.h"
#import "ZYRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface ZYRecommendTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation ZYRecommendTagCell

- (void)setRecommendTag:(ZYRecommendTag *)recommendTag {
    _recommendTag = recommendTag;
    
    /*
    // 先把占位图切成圆形
    //UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    UIImage *placeholder = [UIImage circleImage:@"defaultUserIcon"];
    
    [self.imageListView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // 下载失败直接返回
        if (image == nil) return;
        
        self.imageListView.image = [image circleImage];        
    }];
    */
    
    [self.imageListView setHeader:recommendTag.image_list];
    
    // 名字
    self.themeNameLabel.text = recommendTag.theme_name;
    
    // 订阅数
    if (recommendTag.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅", recommendTag.sub_number];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.imageListView.layer.cornerRadius = self.imageListView.zy_width * 0.5;
    //self.imageListView.layer.masksToBounds = YES;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
