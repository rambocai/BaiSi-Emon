//
//  ZYQuickLoginButton.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/4.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYQuickLoginButton.h"

@implementation ZYQuickLoginButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.backgroundColor = [UIColor orangeColor];
    //self.imageView.backgroundColor = [UIColor redColor];
    //self.titleLabel.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.zy_y = 0;
    self.imageView.zy_centerX = self.zy_width * 0.5;
    
    self.titleLabel.zy_x = 0;
    self.titleLabel.zy_y = self.imageView.zy_bottom;
    self.titleLabel.zy_height = self.zy_height - self.titleLabel.zy_y;
    self.titleLabel.zy_width = self.zy_width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
