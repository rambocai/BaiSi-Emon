//
//  ZYRecommendTagTableViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/13.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYRecommendTagTableViewController.h"
#import "ZYRecommendTagCell.h"
#import "ZYRecommendTag.h"
#import <MJExtension.h>
#import "ZYHTTPSessionManager.h"
#import <SVProgressHUD.h>

@interface ZYRecommendTagTableViewController ()
@property (nonatomic, strong) NSArray<ZYRecommendTag *> *recommendTags;
@property (nonatomic, weak) ZYHTTPSessionManager *manager;
@end

@implementation ZYRecommendTagTableViewController
static NSString * const ZYRecommendTagCellId = @"recommendTag";

- (ZYHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [ZYHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    self.navigationItem.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZYRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:ZYRecommendTagCellId];
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = ZYCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 加载标签数据
    [self loadNewRecommandTags];
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


// 加载标签数据
- (void)loadNewRecommandTags {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    // 发送请求
    [self.manager GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /*
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 字典转模型
            weakSelf.recommendTags = [ZYRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
            [weakSelf.tableView reloadData];
            // 去除HUD
            [SVProgressHUD dismiss];
        });
        */
        // 字典转模型
        weakSelf.recommendTags = [ZYRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [weakSelf.tableView reloadData];
        // 去除HUD
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 如果是取消任务, 就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络繁忙, 请稍后再试"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 隐藏HUD
    [SVProgressHUD dismiss];
    
    // 取消请求
    // [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 关闭URLSession + 取消所有请求
    [self.manager invalidateSessionCancelingTasks:YES];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYRecommendTagCellId];
    cell.recommendTag = self.recommendTags[indexPath.row];
    return cell;
}



@end
