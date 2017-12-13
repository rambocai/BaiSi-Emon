//
//  ZYTabBar.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTabBar.h"

@interface ZYTabBar ()
@property (nonatomic, weak) UIButton *publishBtn;
@end

@implementation ZYTabBar

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        _publishBtn = publishBtn;
    }
    return _publishBtn;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnW = self.zy_width / 5;
    CGFloat btnH = self.zy_height;
    
    CGFloat tabBarBtnY = 0;
    int tabBarBtnIndex = 0;
    for (UIView *subview in self.subviews) {
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        CGFloat tabBarBtnX = tabBarBtnIndex * btnW;
        if (tabBarBtnIndex >= 2) {
            tabBarBtnX += btnW;
        }
        subview.frame = CGRectMake(tabBarBtnX, tabBarBtnY, btnW, btnH);
        tabBarBtnIndex++;
        
        //UIControl *tabBarBtn = (UIControl *)subview;
        //[tabBarBtn addTarget:self action:@selector(tabBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    // 发布按钮
    self.publishBtn.zy_width = btnW;
    self.publishBtn.zy_height = btnH;
    self.publishBtn.zy_centerX = self.zy_width * 0.5;
    self.publishBtn.zy_centerY = self.zy_height * 0.5;
}

#pragma mark - 点击事件
//UIWindow *window_;
- (void)publishBtnClick {
    ZYLogFunc;
    /*
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.backgroundColor = ZYRandomColor;
    // window的级别
    // UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    window_.windowLevel = UIWindowLevelAlert;
    window_.hidden = NO;
    */
}

//- (void)tabBarBtnClick {
//    ZYLogFunc;
//}

@end
