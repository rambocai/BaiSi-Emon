//
//  ZYTopicViewController.h
//  ZYBS
//
//  Created by 竹雨 on 2017/7/11.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYTopic.h"

@interface ZYTopicViewController : UITableViewController

// 帖子类型
//@property (nonatomic, assign) ZYTopicType type;

// 父类中的某个内容, 只允许由子类来修改\提供, 不能由外界来修改\提供
- (ZYTopicType)type;

@end
