//
//  UITextField+ZYExtension.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/5.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "UITextField+ZYExtension.h"

static NSString * const ZYPlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (ZYExtension)

//- (void)setPlaceholderColor:(UIColor *)placeholderColor {
//    //提前设置占位文字, 目的: 让它提前创建placeholderLabel
//    if (self.placeholder.length == 0) {
//        self.placeholder = @" ";
//     }
//    [self setValue:placeholderColor forKeyPath:ZYPlaceholderColorKey];
//}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    // 提前设置占位文字, 目的: 让它提前创建placeholderLabel
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = oldPlaceholder;
    // 恢复到默认的占位文字颜色
    if (placeholderColor == nil) {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    [self setValue:placeholderColor forKeyPath:ZYPlaceholderColorKey];
}

- (UIColor *)placeholderColor {
    return [self valueForKeyPath:ZYPlaceholderColorKey];
}


@end
