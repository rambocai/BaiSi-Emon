//
//  ZYFollowViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYFollowViewController.h"
#import "ZYRecommendFollowViewController.h"
#import "ZYLoginRegisterViewController.h"

@interface ZYFollowViewController ()

@end

@implementation ZYFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZYCommonBgColor;
    self.navigationItem.title = @"我的关注";
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(followClick)];
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)loginAndRegister:(id)sender {
    ZYLoginRegisterViewController *loginVC = [[ZYLoginRegisterViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)followClick {
    ZYRecommendFollowViewController *follow = [[ZYRecommendFollowViewController alloc] init];
    [self.navigationController pushViewController:follow animated:YES];
}

@end
