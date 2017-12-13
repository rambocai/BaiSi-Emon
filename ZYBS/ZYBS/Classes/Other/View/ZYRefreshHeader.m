//
//  ZYRefreshHeader.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/7.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYRefreshHeader.h"

@interface ZYRefreshHeader ()
// Logo
@property (nonatomic, weak) UIImageView *logoView;
@end

@implementation ZYRefreshHeader

// 初始化
- (void)prepare {
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    self.stateLabel.textColor = [UIColor orangeColor];
    self.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    [self setTitle:@"赶紧下拉吧" forState:MJRefreshStateIdle];
    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoView];
    self.logoView = logoView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.logoView.zy_width = self.zy_width;
    self.logoView.zy_height = 40;
    self.logoView.zy_x = 0;
    self.logoView.zy_y = -40;
    self.logoView.backgroundColor = [UIColor yellowColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
