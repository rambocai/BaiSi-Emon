//
//  ZYTitleButton.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/6.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTitleButton.h"

@implementation ZYTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //titleButton.selected = YES;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //titleButton.selected = NO;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}




@end
