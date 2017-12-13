//
//  ZYTabBarController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYEssenceViewController.h"
#import "ZYNewViewController.h"
#import "ZYFollowViewController.h"
#import "ZYMeViewController.h"
#import "ZYTabBar.h"
#import "ZYNavigationController.h"

@interface ZYTabBarController ()

@end

@implementation ZYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItemTitleTextAttributes];
    [self setupChildViewControllers];
    [self setupTabBar];
    
    // Do any additional setup after loading the view.
}


- (void)setupItemTitleTextAttributes {
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateSelected];
}

- (void)setupChildViewControllers {
    [self setupOneChildViewController:[[ZYNavigationController alloc] initWithRootViewController:[[ZYEssenceViewController alloc] init]] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupOneChildViewController:[[ZYNavigationController alloc] initWithRootViewController:[[ZYNewViewController alloc] init]] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupOneChildViewController:[[ZYNavigationController alloc] initWithRootViewController:[[ZYFollowViewController alloc] init]] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupOneChildViewController:[[ZYNavigationController alloc] initWithRootViewController:[[ZYMeViewController alloc] init]] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem.title = title;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self addChildViewController:vc];
}

- (void)setupTabBar {
    [self setValue:[[ZYTabBar alloc] init] forKeyPath:@"tabBar"];
}

@end
