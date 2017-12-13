//
//  ZYCommentViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/14.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYCommentViewController.h"
#import "ZYHTTPSessionManager.h"
#import <MJExtension.h>
#import "ZYRefreshHeader.h"
#import "ZYRefreshFooter.h"
#import "ZYTopic.h"
#import "ZYComment.h"
#import "ZYCommentCell.h"
#import "ZYCommentSectionHeader.h"
#import "CZYTopicCell.h"

@interface ZYCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
/** 任务管理者 */
@property (nonatomic, strong) ZYHTTPSessionManager *manager;
/** 最热评论数据 */
@property (nonatomic, strong) NSArray<ZYComment *> *hotestComments;
/** 最新评论数据 */
@property (nonatomic, strong) NSMutableArray<ZYComment *> *latestComments;
// 对象属性名不能以new开头
// @property (nonatomic, strong) NSMutableArray<XMGComment *> *newComments;
/** 最热评论 */
@property (nonatomic, strong) ZYComment *savedTopCmt;
@end

@implementation ZYCommentViewController
static NSString * const ZYCommentCellId = @"comment";
static NSString * const ZYSectionHeaderlId = @"header";

- (ZYHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [ZYHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBase];
    [self setupTable];
    [self setupRefresh];
    [self setupHeader];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupHeader {
    // 处理模型数据
    self.savedTopCmt = self.topic.top_cmt;
    self.topic.top_cmt = nil;
    self.topic.cellHeight = 0;
    // 创建header
    UIView *header = [[UIView alloc] init];
    CZYTopicCell *cell = [CZYTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeight);
    
    [header addSubview:cell];
    // 设置header的高度
    header.zy_height = cell.zy_height + ZYMargin * 2;
    
    // 设置header
    self.tableView.tableHeaderView = header;
}
- (void)setupBase {
    self.navigationItem.title = @"评论";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)setupTable {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZYCommentCell class]) bundle:nil] forCellReuseIdentifier:ZYCommentCellId];
    [self.tableView registerClass:[ZYCommentSectionHeader class] forHeaderFooterViewReuseIdentifier:ZYSectionHeaderlId];
    
    self.tableView.backgroundColor = ZYCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = ZYCommentSectionHeaderFont.lineHeight + 2;
    
    // 设置cell的高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}
- (void)setupRefresh {
    self.tableView.mj_header = [ZYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [ZYRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

#pragma mark - 数据加载
- (void)loadNewComments {
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1;
    __weak typeof(self) weakSelf = self;
    
    [self.manager GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 没有任何评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
        // 字典 -> 模型
        weakSelf.latestComments = [ZYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        weakSelf.hotestComments = [ZYComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        int total = [responseObject[@"total"] intValue];
        if (weakSelf.latestComments.count == total) { // 全部加载完毕
            // 提示用户:没有更多数据
            // [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
- (void)loadMoreComments {
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = self.latestComments.lastObject.ID;
    __weak typeof(self) weakSelf = self;
    // 发送请求
    [self.manager GET:ZYCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        NSArray *moreComments = [ZYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.latestComments addObjectsFromArray:moreComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        int total = [responseObject[@"total"] intValue];
        
        NSLog(@"%d, %ld", total, self.latestComments.count);
        
        if (weakSelf.latestComments.count == total) { // 全部加载完毕
            // 提示用户:没有更多数据
            // [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 监听键盘
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
//    if (弹出) {
//        self.bottomMargin.constant = 键盘高度;
//    } else {
//        self.bottomMargin.constant = 0;
//    }
    
    // 修改约束
    CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    self.bottomMargin.constant = screenH - keyboardY;
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.topic.top_cmt = self.savedTopCmt;
    self.topic.cellHeight = 0;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 有最热评论 + 最新评论数据
    if (self.hotestComments.count) return 2;
    // 没有最热评论数据, 有最新评论数据
    if (self.latestComments.count) return 1;
    // 没有最热评论数据, 没有最新评论数据
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        return self.hotestComments.count;
    }
    // 其他情况
    return self.latestComments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommentCellId];
    
    if (indexPath.section == 0 && self.hotestComments.count) {
        cell.comment = self.hotestComments[indexPath.row];
    } else {
        cell.comment = self.latestComments[indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZYCommentSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ZYSectionHeaderlId];
    
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        header.textLabel.text = @"最热评论";
    } else { // 其他情况
        header.textLabel.text = @"最新评论";
    }
    return header;
}


@end
