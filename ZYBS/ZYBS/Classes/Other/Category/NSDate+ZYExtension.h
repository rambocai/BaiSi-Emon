//
//  NSDate+ZYExtension.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/10.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZYExtension)

// 是否为今年
- (BOOL)isThisYear;
// 是否为今天
- (BOOL)isToday;
// 是否为昨天
- (BOOL)isYesterday;
// 是否为明天
- (BOOL)isTomorrow;


@end
