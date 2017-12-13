//
//  CZYTopicCell.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/7.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "CZYTopicCell.h"
#import <UIImageView+WebCache.h>
#import "ZYTopic.h"
#import "ZYComment.h"
#import "ZYUser.h"
#import "ZYTopicPictureView.h"
#import "ZYTopicVideoView.h"
#import "ZYTopicVoiceView.h"

@interface CZYTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

// 最热评论
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;


/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) ZYTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) ZYTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) ZYTopicVideoView *videoView;

@end

@implementation CZYTopicCell

- (IBAction)more:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZYLog(@"点击了[收藏]按钮");
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ZYLog(@"点击了[举报]按钮");
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ZYLog(@"点击了[取消]按钮");
    }]];
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

// 时间处理: @"刚刚" \ @"10分钟前" \ @"5小时前" \ @"昨天 09:10:05" \ @"11-20 09:10:05" \ @"2015-11-20 09:10:05"


- (void)setTopic:(ZYTopic *)topic {
    _topic = topic;
    
    //[self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.profileImageView setHeader:topic.profile_image];
    
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    //[self.dingButton setTitle:[NSString stringWithFormat:@"%zd", topic.ding] forState:UIControlStateNormal];
    
    //topic.ding = 8000 + arc4random_uniform(5000);
    //topic.cai = 0;
    
    [self setupButton:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButton:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButton:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButton:self.commentButton number:topic.comment placeholder:@"评论"];
    
    //NSDictionary *comment = topic.top_cmt.firstObject;
    //ZYLog(@"%@", [comment class]);
    /*
    ZYComment *comment = topic.top_cmt.firstObject;
    
    if (comment) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        //NSString *username = comment[@"user"][@"username"]; // 用户名
        //NSString *content = comment[@"content"]; // 评论内容
        NSString *username = comment.user.username;
        NSString *content = comment.content;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    */
    
    if (topic.top_cmt) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        NSString *username = topic.top_cmt.user.username;
        NSString *content = topic.top_cmt.content;
        if (topic.top_cmt.voiceuri.length) {
            content = @"[语音评论]";
        }
        
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
#pragma mark - 中间的内容
    //ZYLog(@"%zd", topic.type);
    /*
    if (topic.type == 41) { // 视频
        
    } else if (topic.type == 31) { // 音频
        
    } else if (topic.type == 29) { // 段子
        
    } else if (topic.type == 10) { // 图片
        
    }
    */
    if (topic.type == ZYTopicTypeVideo) { // 视频
        //[self.contentView addSubview:[ZYTopicPictureView viewFromXib]];
        self.videoView.hidden = NO;
        self.videoView.frame = topic.contentF;
        self.videoView.topic = topic;
        
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (topic.type == ZYTopicTypeVoice) { // 音频
        //[self.contentView addSubview:[ZYTopicVoiceView viewFromXib]];
        self.voiceView.hidden = NO;
        self.voiceView.frame = topic.contentF;
        self.voiceView.topic = topic;
        
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (topic.type == ZYTopicTypeWord) { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (topic.type == ZYTopicTypePicture) { // 图片
        //[self.contentView addSubview:[ZYTopicVideoView viewFromXib]];
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.contentF;
        self.pictureView.topic = topic;
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
}


// 设置按钮的数字 (placeholder是一个中文参数, 故意留到最后, 前面的参数就可以使用点语法等智能提示)
- (void)setupButton:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame {
    
    //ZYLog(@"%@", NSStringFromCGRect(frame));
    frame.size.height -= ZYMargin;
    frame.origin.y += ZYMargin;
    //frame.origin.x += ZYMargin;
    //frame.size.width -= 2 * ZYMargin;
    //ZYLog(@"%@", NSStringFromCGRect(frame));
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (ZYTopicPictureView *)pictureView {
    if (!_pictureView) {
        ZYTopicPictureView *pictureView = [ZYTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (ZYTopicVoiceView *)voiceView {
    if (!_voiceView) {
        ZYTopicVoiceView *voiceView = [ZYTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
- (ZYTopicVideoView *)videoView {
    if (!_videoView) {
        ZYTopicVideoView *videoView = [ZYTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}


@end
