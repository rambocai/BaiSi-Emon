//
//  ZYRefreshFooter.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/7.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYRefreshFooter.h"

@implementation ZYRefreshFooter

- (void)prepare {
    [super prepare];
    self.stateLabel.textColor = [UIColor redColor];
    //[self addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    [self setTitle:@"没有数据啦,不要再上拉了" forState:MJRefreshStateNoMoreData];
    
    // 刷新控件出现一半就会进入刷新状态
    //self.triggerAutomaticallyRefreshPercent = 0.5;
    // 不要自动刷新
    //self.automaticallyRefresh = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
