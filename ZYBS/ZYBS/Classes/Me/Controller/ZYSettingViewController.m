//
//  ZYSettingViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYSettingViewController.h"
#import <SDImageCache.h>
#import "ZYClearCacheCell.h"

static NSString * const ZYClearCacheCellId = @"ZYClearCacheCell";
@interface ZYSettingViewController ()

@end

@implementation ZYSettingViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZYCommonBgColor;
    self.navigationItem.title = @"设置";
    
    [self.tableView registerClass:[ZYClearCacheCell class] forCellReuseIdentifier:ZYClearCacheCellId];

    // Do any additional setup after loading the view.
}


#pragma mark ----- UITableViewDelegate -----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYClearCacheCellId];
        
    return cell;
}

/*
 tmp(临时文件)
 Documents(备份文件)
 Library:
    Caches(缓存的较大文件)
    Preferences(偏好设置)
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYLogFunc;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        
    }
}


@end
