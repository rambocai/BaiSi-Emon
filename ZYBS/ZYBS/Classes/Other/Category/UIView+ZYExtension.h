//
//  UIView+ZYExtension.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYExtension)

@property (nonatomic, assign) CGSize zy_size;
@property (nonatomic, assign) CGFloat zy_width;
@property (nonatomic, assign) CGFloat zy_height;
@property (nonatomic, assign) CGFloat zy_x;
@property (nonatomic, assign) CGFloat zy_y;
@property (nonatomic, assign) CGFloat zy_centerX;
@property (nonatomic, assign) CGFloat zy_centerY;

@property (nonatomic, assign) CGFloat zy_right;
@property (nonatomic, assign) CGFloat zy_bottom;

+ (instancetype)viewFromXib;

- (BOOL)intersectWithView:(UIView *)view;

@end
