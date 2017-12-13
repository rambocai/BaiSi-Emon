//
//  NSCalendar+ZYExtension.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/10.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "NSCalendar+ZYExtension.h"

@implementation NSCalendar (ZYExtension)

+ (instancetype)calendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [NSCalendar currentCalendar];
    }
}


@end
