//
//  ZYRecommendTag.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/13.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYRecommendTag : NSObject

/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;


@end
