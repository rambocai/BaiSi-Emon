//
//  ZYMeFooterView.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/4.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYMeFooterView.h"
#import "ZYHTTPSessionManager.h"
#import <MJExtension.h>
#import "ZYMeSquare.h"
#import <UIButton+WebCache.h>
#import "ZYMeSquareButton.h"
#import "ZYWebViewController.h"
#import <SafariServices/SafariServices.h>

@implementation ZYMeFooterView

// http://api.budejie.com/api/api_open.php?a=square&c=topic

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        // 请求
        [[ZYHTTPSessionManager manager] GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 字典数组 -> 模型数组
            NSArray *squares = [ZYMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 根据模型数据创建对应的控件
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ZYLog(@"请求失败 - %@", error);
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)squares {
    // 方块个数
    NSUInteger count = squares.count;
    // 方块的尺寸
    int maxColsCount = 4; // 一行的最大列数
    CGFloat buttonW = self.zy_width / maxColsCount;
    CGFloat buttonH = buttonW;
    // 创建所有的方块
    for (NSUInteger i = 0; i < count; i++) {
        // i位置对应的模型数据
        ZYMeSquare *square = squares[i];
        
        // 创建按钮
        ZYMeSquareButton *button = [ZYMeSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 设置frame
        button.zy_x = (i % maxColsCount) * buttonW;
        button.zy_y = (i / maxColsCount) * buttonH;
        button.zy_width = buttonW;
        button.zy_height = buttonH;
        // 设置数据
        button.square = square;
        
    }
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
    self.zy_height = self.subviews.lastObject.zy_bottom;
    // 设置tableView的contentSize
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    [tableView reloadData];
}

- (void)buttonClick:(ZYMeSquareButton *)button {
    ZYMeSquare *square = button.square;
    NSString *url = square.url;
    //UITabBarController *tabBarVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *naVC = tabBarVC.selectedViewController;
    if ([square.url hasPrefix:@"http"]) { // 利用webView加载url即可
        ZYLog(@"利用webView加载url");
        
        ZYWebViewController *webView = [[ZYWebViewController alloc] init];
        webView.url = url;
        //SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];

        webView.navigationItem.title = button.currentTitle;
        [naVC pushViewController:webView animated:YES];
        //UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
        //[tabBarVC presentViewController:webView animated:YES completion:nil];
    } else if ([square.url hasPrefix:@"mod"]) { // 另行处理
        if ([square.url hasSuffix:@"BDJ_To_Check"]) {
            ZYLog(@"跳转到[审帖]界面");
        } else if ([square.url hasSuffix:@"BDJ_To_RecentHot"]) {
            ZYLog(@"跳转到[每日排行]界面");
        } else {
            ZYLog(@"跳转到其他界面");
        }
    } else {
        ZYLog(@"不是http或者mod协议的");
    }
}



@end
