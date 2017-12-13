//
//  UIView+ZYExtension.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "UIView+ZYExtension.h"

@implementation UIView (ZYExtension)


- (CGSize)zy_size {
    return self.frame.size;
}

- (void)setZy_size:(CGSize)zy_size {
    CGRect frame = self.frame;
    frame.size = zy_size;
    self.frame = frame;
}

- (CGFloat)zy_width {
    return self.frame.size.width;
}

- (CGFloat)zy_height {
    return self.frame.size.height;
}

- (void)setZy_width:(CGFloat)zy_width {
    CGRect frame = self.frame;
    frame.size.width = zy_width;
    self.frame = frame;
}

- (void)setZy_height:(CGFloat)zy_height {
    CGRect frame = self.frame;
    frame.size.height = zy_height;
    self.frame = frame;
}

- (CGFloat)zy_x {
    return self.frame.origin.x;
}

- (void)setZy_x:(CGFloat)zy_x {
    CGRect frame = self.frame;
    frame.origin.x = zy_x;
    self.frame = frame;
}

- (CGFloat)zy_y {
    return self.frame.origin.y;
}

- (void)setZy_y:(CGFloat)zy_y {
    CGRect frame = self.frame;
    frame.origin.y = zy_y;
    self.frame = frame;
}

- (CGFloat)zy_centerX {
    return self.center.x;
}

- (void)setZy_centerX:(CGFloat)zy_centerX {
    CGPoint center = self.center;
    center.x = zy_centerX;
    self.center = center;
}

- (CGFloat)zy_centerY {
    return self.center.y;
}

- (void)setZy_centerY:(CGFloat)zy_centerY {
    CGPoint center = self.center;
    center.y = zy_centerY;
    self.center = center;
}

- (CGFloat)zy_right {
    //    return self.xmg_x + self.xmg_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zy_bottom {
    //    return self.xmg_y + self.xmg_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setZy_right:(CGFloat)zy_right {
    self.zy_x = zy_right - self.zy_width;
}

- (void)setZy_bottom:(CGFloat)zy_bottom {
    self.zy_y = zy_bottom - self.zy_height;
}

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (BOOL)intersectWithView:(UIView *)view {
    //CGRect selfRect = [self convertRect:self.bounds toView:nil];
    //CGRect viewRect = [view convertRect:view.bounds toView:nil];
    //return CGRectIntersectsRect(selfRect, viewRect);
    
    // 当两个View不在同一个Window上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}


@end
