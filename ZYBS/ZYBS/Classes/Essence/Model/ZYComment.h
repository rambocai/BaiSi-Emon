//
//  ZYComment.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/10.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYUser;

@interface ZYComment : NSObject

// top_cmt -> user -> comment


/** id */
@property (nonatomic, copy) NSString *ID;

/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 用户(发表评论的人) */
@property (nonatomic, strong) ZYUser *user;

/** 被点赞数 */
@property (nonatomic, assign) NSInteger like_count;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;


@end
