//
//  ZYMeSquareButton.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/4.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYMeSquareButton.h"
#import <UIButton+WebCache.h>
#import "ZYMeSquare.h"

@implementation ZYMeSquareButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.zy_y = self.zy_height * 0.15;
    self.imageView.zy_height = self.zy_height * 0.5;
    self.imageView.zy_width = self.imageView.zy_height;
    self.imageView.zy_centerX = self.zy_width * 0.5;
    
    self.titleLabel.zy_x = 0;
    self.titleLabel.zy_y = self.imageView.zy_bottom;
    self.titleLabel.zy_width = self.zy_width;
    self.titleLabel.zy_height = self.zy_height - self.titleLabel.zy_y;
}

- (void)setSquare:(ZYMeSquare *)square {
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
}



@end
