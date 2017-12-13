//
//  ZYCommentSectionHeader.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/14.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYCommentSectionHeader.h"

@implementation ZYCommentSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.font = ZYCommentSectionHeaderFont;
    // 设置label的x值
    self.textLabel.zy_x = ZYSmallMargin;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
