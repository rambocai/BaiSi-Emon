//
//  ZYTopWindow.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/17.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTopWindow.h"

@implementation ZYTopWindow

static UIWindow *window_;
+ (void)show{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window_ = [[UIWindow alloc] init];
        window_.frame = [UIApplication sharedApplication].statusBarFrame;
        window_.backgroundColor = [UIColor clearColor];
        // window的级别
        window_.windowLevel = UIWindowLevelAlert;
        [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewClick)]];
        window_.hidden = NO;
    });
}

+ (void)topViewClick {
    ZYLogFunc;
    // 主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 查找主窗口中的所有scrollView
    [self findScrollViewInView:window];
}

// 查找View中的所有ScrollView
+ (void)findScrollViewInView:(UIView *)view {
    // 利用递归查找所有的子控件
    for (UIView *subView in view.subviews) {
        [self findScrollViewInView:subView];
    }
    //ZYLog(@"%@", view.class);
    
    // 判断是否是ScrollView
    if (![view isKindOfClass:[UIScrollView class]]) return;
    // 判断是否与Window有重叠
    //CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
    //CGRect viewRect = [view convertRect:view.bounds toView:nil];
    //if (!CGRectIntersectsRect(windowRect, viewRect)) return;
    if (![view intersectWithView:[UIApplication sharedApplication].keyWindow]) return;
    
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offset = scrollView.contentOffset;
    offset.y = -scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
    
    //[scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}



@end
