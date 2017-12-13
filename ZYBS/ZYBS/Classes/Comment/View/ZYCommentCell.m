//
//  ZYCommentCell.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/14.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYCommentCell.h"
#import "ZYComment.h"
#import "ZYUser.h"

@interface ZYCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation ZYCommentCell

- (void)setComment:(ZYComment *)comment {
    _comment = comment;
    
    self.usernameLabel.text = comment.user.username;
    self.contentLabel.text = comment.content;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    [self.profileImageView setHeader:comment.user.profile_image];
    
    NSString *sexImageName = [comment.user.sex isEqualToString:ZYUserSexMale] ? @"Profile_manIcon" : @"Profile_womanIcon";
    self.sexView.image =  [UIImage imageNamed:sexImageName];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
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

@end
