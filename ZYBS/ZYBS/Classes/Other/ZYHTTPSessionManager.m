//
//  ZYHTTPSessionManager.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/7.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYHTTPSessionManager.h"

@implementation ZYHTTPSessionManager

//+ (instancetype)manager {
//    ZYHTTPSessionManager *manager = [];
//}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        
        //self.securityPolicy.validatesDomainName = NO;
        //self.responseSerializer = nil;
        //self.requestSerializer = nil;
    }
    return self;
}

@end
