//
//  ZYEssenceViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/3.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYEssenceViewController.h"
#import "ZYTitleButton.h"

#import "ZYAllViewController.h"
#import "ZYVideoViewController.h"
#import "ZYVoiceViewController.h"
#import "ZYPictureViewController.h"
#import "ZYWordViewController.h"
#import "ZYRecommendTagTableViewController.h"

@interface ZYEssenceViewController ()<UIScrollViewDelegate>
// 当前选中的标题按钮
@property (nonatomic, weak) ZYTitleButton *selectedTitleButton;
// 标题按钮底部的指示器
@property (nonatomic, weak) UIView *indicatorView;
// 底部UIScrollView
@property (nonatomic, weak) UIScrollView *scrollView;
// 标题栏
@property (nonatomic, weak) UIView *titlesView;

@end

@implementation ZYEssenceViewController

- (void)setupNav {
    // 标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}
- (void)setupTitlesView {
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titlesView.frame = CGRectMake(0, 64, self.view.zy_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.zy_width / count;
    CGFloat titleButtonH = titlesView.zy_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建UIButton
        ZYTitleButton *titleButton = [ZYTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
    }
    // 按钮的选中颜色
    ZYTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.zy_height = 1;
    indicatorView.zy_y = titlesView.zy_height - indicatorView.zy_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    //根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    self.indicatorView.zy_width = firstTitleButton.titleLabel.zy_width;
    self.indicatorView.zy_centerX = firstTitleButton.zy_centerX;
    //默认选中
    //[self titleClick:firstTitleButton];
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
}
- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = ZYCommonBgColor;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.zy_width, 0);
    scrollView.delegate = self;
    self.scrollView = scrollView;
}
- (void)setupChildViewControllers {
    ZYAllViewController *all = [[ZYAllViewController alloc] init];
    //all.type = ZYTopicTypeAll;
    [self addChildViewController:all];
    
    ZYVideoViewController *video = [[ZYVideoViewController alloc] init];
    //video.type = ZYTopicTypeVideo;
    [self addChildViewController:video];
    
    ZYVoiceViewController *voice = [[ZYVoiceViewController alloc] init];
    //voice.type = ZYTopicTypeVoice;
    [self addChildViewController:voice];
    
    ZYPictureViewController *picture = [[ZYPictureViewController alloc] init];
    //picture.type = ZYTopicTypePicture;
    [self addChildViewController:picture];
    
    ZYWordViewController *word = [[ZYWordViewController alloc] init];
    //word.type = ZYTopicTypeWord;
    [self addChildViewController:word];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZYCommonBgColor;
    
    [self setupNav];
    [self setupChildViewControllers];
    [self setupScrollView];
    
    [self setupTitlesView];
    [self addChildVcView];
    // Do any additional setup after loading the view.
}
- (void)addChildVcView {
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.zy_width;
    UIViewController *childVc = self.childViewControllers[index];
    // 判断是否已经加载过
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}
- (void)tagClick {
    ZYLogFunc;
    ZYRecommendTagTableViewController *tag = [[ZYRecommendTagTableViewController alloc] init];
    [self.navigationController pushViewController:tag animated:YES];
}
- (void)titleClick:(ZYTitleButton *)titleButton {
    ZYLogFunc;
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.zy_width = titleButton.titleLabel.zy_width;
        self.indicatorView.zy_centerX = titleButton.zy_centerX;
    }];
    
    //让ScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.zy_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark ----- UIScrollViewDelegate -----
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self addChildVcView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / scrollView.zy_width;
    ZYTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    [self addChildVcView];
}






@end
