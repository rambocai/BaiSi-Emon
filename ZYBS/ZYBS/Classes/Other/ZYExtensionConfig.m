//
//  ZYExtensionConfig.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/10.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYExtensionConfig.h"
#import <MJExtension.h>
#import "ZYTopic.h"
#import "ZYComment.h"

@implementation ZYExtensionConfig

+ (void)load {
//    [ZYTopic mj_setupObjectClassInArray:^NSDictionary *{
//        return @{@"top_cmt" : [ZYComment class]};
//    }];
    [ZYTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"top_cmt" : @"top_cmt[0]",
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1"};
    }];
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
