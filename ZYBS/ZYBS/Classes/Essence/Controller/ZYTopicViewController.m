//
//  ZYTopicViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/11.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTopicViewController.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "ZYTopic.h"
#import "ZYRefreshHeader.h"
#import "ZYRefreshFooter.h"
#import "ZYHTTPSessionManager.h"
#import "CZYTopicCell.h"
#import "ZYNewViewController.h"
#import "ZYCommentViewController.h"

@interface ZYTopicViewController ()
// 所有帖子的数组
@property (nonatomic, strong) NSMutableArray<ZYTopic *> *topics;
// 用来加载下一页数据
@property (nonatomic, copy) NSString *maxtime;
// 任务管理者
@property (nonatomic, strong) ZYHTTPSessionManager *manager;

// 声明这个方法的目的 : 为了能够使用点语法的智能提示
- (NSString *)aParam;

@end

@implementation ZYTopicViewController

static NSString * const ZYTopicCellId = @"topic";

#pragma mark - 消除编译器发出的警告 : type方法没有实现
- (ZYTopicType)type {
    return 0;
}

- (ZYHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [ZYHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部";
    
    [self setupTable];
    [self setupRefresh];
    
    [self setupNote];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupTable {
    self.tableView.backgroundColor = ZYCommonBgColor;
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CZYTopicCell class]) bundle:nil] forCellReuseIdentifier:ZYTopicCellId];
    //self.tableView.rowHeight = 250;
}
- (void)setupRefresh {
    // 下拉刷新
    self.tableView.mj_header = [ZYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    // 上拉加载
    self.tableView.mj_footer = [ZYRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

/*
 当上拉与下拉请求同时存在的时候，需要先放弃上一次请求操作
 */
- (void)loadNewTopics {
    // 取消网络请求的任务
    //    for (NSURLSessionTask *task in self.manager.tasks) {
    //        [task cancel];
    //    }
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"a"] = @"list";
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    
    [self.manager GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 存储maxtime(方便用来加载下一页数据)
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        self.topics = [ZYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) {
            // 取消了任务
        } else {
            // 是其他错误
        }
        ZYLog(@"请求失败 - %@", error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopics {
    ZYLogFunc;
    // 取消所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"a"] = @"list";
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"maxtime"] = self.maxtime;
    params[@"type"] = @(self.type);
    
    [self.manager GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 存储这页对应的maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray<ZYTopic *> *moreTopics = [ZYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.topics addObjectsFromArray:moreTopics];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZYLog(@"请求失败 - %@", error);
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark ----- UITableViewDelegate -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CZYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYTopicCellId];
    cell.topic = self.topics[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //ZYLog(@"%zd", indexPath.row);
    return self.topics[indexPath.row].cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommentViewController *comment = [[ZYCommentViewController alloc] init];
    comment.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:comment animated:YES];
}


#pragma mark - 如果是新帖部分
- (NSString *)aParam {
    if (self.parentViewController.class == [ZYNewViewController class]) {
        return @"newlist";
    }
    return @"list";
}

#pragma mark - 监听通知
- (void)setupNote {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:ZYTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:ZYTitleButtonDidRepeatClickNotification object:nil];
}
- (void)tabBarButtonDidRepeatClick {
    if (self.view.window == nil) return;
    if (![self.view intersectWithView:self.view.window]) return;
    
    ZYLog(@"tabBar---%@", self.class);
    [self.tableView.mj_header beginRefreshing];
}
- (void)titleButtonDidRepeatClick {
    [self tabBarButtonDidRepeatClick];
    ZYLog(@"title---%@",self.class);
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
