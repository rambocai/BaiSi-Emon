//
//  ZYLoginRegisterViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYLoginRegisterViewController.h"

@interface ZYLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation ZYLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

// 设置状态栏的文字颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)showLoginOrRegister:(UIButton *)button {
    //退出键盘
    [self.view endEditing:YES];
    if (self.leftMargin.constant) { // 目前显示的是注册界面, 点击按钮后要切换为登录界面
        self.leftMargin.constant = 0;
        button.selected = NO;
        //[button setTitle:@"注册帐号" forState:UIControlStateNormal];
    } else { // 目前显示的是登录界面, 点击按钮后要切换为注册界面
        self.leftMargin.constant = - self.view.zy_width;
        button.selected = YES;
        //[button setTitle:@"已有帐号?" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.25 animations:^{
        // 强制刷新 : 让最新设置的约束值马上应用到UI控件上
        // 会刷新到self.view内部的所有子控件
        [self.view layoutIfNeeded];
    }];
    //成为第一响应者
    //[textfield becomeFirstResponder];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
