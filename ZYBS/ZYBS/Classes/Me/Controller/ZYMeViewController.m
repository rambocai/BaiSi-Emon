//
//  ZYMeViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYMeViewController.h"
#import "ZYSettingViewController.h"
#import "ZYMeCell.h"
#import "ZYMeFooterView.h"

@interface ZYMeViewController ()

@end

@implementation ZYMeViewController

- (void)setupTable {
    self.tableView.backgroundColor = ZYCommonBgColor;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = ZYMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(ZYMargin - 35, 0, 0, 0);
    
    // 设置footer
    self.tableView.tableFooterView = [[ZYMeFooterView alloc] init];
}
- (void)setupNav {
    self.navigationItem.title = @"我的";
    // 右边-设置
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    // 右边-月亮
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    
}

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZYCommonBgColor;
    
    [self setupNav];
    [self setupTable];
    // Do any additional setup after loading the view.
}


- (void)settingClick {
    ZYSettingViewController *setting = [[ZYSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)moonClick {
    ZYLogFunc;
}

#pragma mark ----- UITableViewDelete -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[ZYMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"publish-audio"];
    } else {
        cell.textLabel.text = @"离线下载";
        // 只要有其他cell设置过imageView.image, 其他不显示图片的cell都需要设置imageView.image = nil
        cell.imageView.image = nil;
    }
    return cell;
}




@end
