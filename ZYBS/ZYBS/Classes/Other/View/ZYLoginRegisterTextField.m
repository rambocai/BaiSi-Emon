//
//  ZYLoginRegisterTextField.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/5.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYLoginRegisterTextField.h"

@implementation ZYLoginRegisterTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置光标颜色
    self.tintColor = [UIColor whiteColor];
    
    self.placeholderColor = [UIColor grayColor];
}


#pragma mark ---- 响应者 -----
- (BOOL)becomeFirstResponder {
    self.placeholderColor = [UIColor whiteColor];
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    self.placeholderColor = [UIColor grayColor];
    return [super resignFirstResponder];
}


@end
