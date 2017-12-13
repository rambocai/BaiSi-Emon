//
//  ZYTopic.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/7.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYTopic.h"
//#import <MJExtension.h>
//#import "ZYComment.h"
#import "ZYComment.h"
#import "ZYUser.h"

@implementation ZYTopic
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

// 在第一次使用ZYTopic类时调用一次
+ (void)initialize {
    fmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar calendar];
}

// 重写get方法, 设置时间字符串
- (NSString *)created_at {
    
    //_created_at = @"2016-07-09 10:19:00";
    // 获取NSCalendar
    
    fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt_ dateFromString:_created_at];
    // 当前时间
    NSDate *nowDate = [NSDate date];
    //ZYLog(@"%@ --- %@", createdAtDate, nowDate);
    if (createdAtDate.isThisYear) {  // 今年
        if (/*[calendar_ isDateInToday:createdAtDate]*/ createdAtDate.isToday) {
            //今天
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar_ components:unit fromDate:createdAtDate toDate:nowDate options:0];
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (/*[calendar_ isDateInYesterday:createAtDate]*/ createdAtDate.isYesterday) {
            //昨天
            fmt_.dateFormat = @"昨天 HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        } else {
            //其他
            fmt_.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        }
    } else {    // 非今年
        return _created_at;
    }
    
    
    return _created_at;
}


/*
今年
 今天
    时间间隔 >= 1小时         @"5小时前"
    1小时 > 时间间隔 >= 1分钟  @"10分钟前"
    1分钟 > 时间间隔          @"刚刚"
 昨天 - @"昨天 09:10:05"
 其他 - @"11-20 09:10:05"


非今年 - @"2015-11-20 09:10:05"
*/

#pragma mark ----- MJExtension -----

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"top_cmt" : [ZYComment class]};
//}

#pragma mark ----- 计算高度 -----

- (CGFloat)cellHeight {
    if (_cellHeight) return _cellHeight;
    //ZYLogFunc;
    // 1.头像
    _cellHeight = 55;
    // 2.文字
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * ZYMargin;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    //CGSize textSize = [self.text sizeWithFont:<#(UIFont *)#>]
    //CGSize textSize = [self.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:textMaxSize];
    CGSize textSize = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    _cellHeight += textSize.height + ZYMargin;
    // 3.中间的内容
    if (self.type != ZYTopicTypeWord) { // 如果是图片\声音\视频帖子, 才需要计算中间内容的高度
        // 中间内容的高度 == 中间内容的宽度 * 图片的真实高度 / 图片的真实宽度
        CGFloat contentH = textMaxW * self.height / self.width;
        if (contentH >= [UIScreen mainScreen].bounds.size.height) { // 超长图片
            // 将超长图片的高度变为200
            contentH = 200;
            self.bigPicture = YES;
        }
        self.contentF = CGRectMake(ZYMargin, _cellHeight, textMaxW, contentH);
        _cellHeight += contentH + ZYMargin;
    }
    // 4.最热评论
    if (self.top_cmt) { // 如果有最热评论
        // 最热评论-标题
        _cellHeight += 20;
        // 最热评论-内容
        NSString *content = self.top_cmt.content;
        if (self.top_cmt.voiceuri.length) {
            content = @"[语音评论]";
        }
        NSString *topCmtContent = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, content];
        //CGSize topCmtContentSize = [topCmtContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:textMaxSize];
        
        CGSize topCmtContentSize = [topCmtContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        _cellHeight += topCmtContentSize.height + ZYMargin;
    }
    // 5.底部 - 工具条
    _cellHeight += 35 + ZYMargin;
    return _cellHeight;
}


@end
