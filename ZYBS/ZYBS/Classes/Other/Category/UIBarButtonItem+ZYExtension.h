//
//  UIBarButtonItem+ZYExtension.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZYExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
