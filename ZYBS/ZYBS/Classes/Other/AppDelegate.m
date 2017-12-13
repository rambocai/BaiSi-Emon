//
//  AppDelegate.m
//  ZYBS
//
//  Created by 竹雨 on 2017/6/30.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYTabBarController.h"
#import "ZYTopWindow.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
// 记录上一次选中的子控制器
//@property (nonatomic, weak) UIViewController *selectedController;
@property (nonatomic, assign) NSUInteger lastSelectedIndex;
@end

@implementation AppDelegate
//UIWindow *window_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    ZYTabBarController *tabBarVC = [[ZYTabBarController alloc] init];
    tabBarVC.delegate = self;
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
//    UIView *topView = [[UIView alloc] init];
//    topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
//    topView.backgroundColor = [UIColor redColor];
//    [topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewClick)]];
//    [self.window addSubview:topView];
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window_ = [[UIWindow alloc] init];
        window_.frame = [UIApplication sharedApplication].statusBarFrame;
        window_.backgroundColor = [UIColor clearColor];
        // window的级别
        window_.windowLevel = UIWindowLevelAlert;
        [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewClick)]];
        window_.hidden = NO;
    });
    */
    
    [ZYTopWindow show];
    return YES;
}

- (void)topViewClick {
    ZYLogFunc;
    // 主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 查找主窗口中的所有scrollView
    [self findScrollViewInView:window];
}

// 查找View中的所有ScrollView
- (void)findScrollViewInView:(UIView *)view {
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (viewController == self.selectedController) {
//        ZYLog(@"%ld按钮", tabBarController.selectedIndex);
//    }
//    self.selectedController = viewController;
    if (tabBarController.selectedIndex == self.lastSelectedIndex) {
        ZYLog(@"%ld按钮", tabBarController.selectedIndex);
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.lastSelectedIndex = tabBarController.selectedIndex;
}


@end
