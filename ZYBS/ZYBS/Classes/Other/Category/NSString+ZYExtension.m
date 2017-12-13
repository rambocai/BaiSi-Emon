//
//  NSString+ZYExtension.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/6.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "NSString+ZYExtension.h"

@implementation NSString (ZYExtension)

//- (unsigned long long)fileSize {
//    
//    // 总大小
//    unsigned long long size = 0;
//    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    
//    // 文件属性
//    NSDictionary *attrs = [manager attributesOfItemAtPath:self error:nil];
//    // 判断是文件还是文件夹
//    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) {
//        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
//        for (NSString *subpath in enumerator) {
//            // 全路径
//            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
//            // 累加文件大小
//            size += [manager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
//        }
//    } else {
//        size = attrs.fileSize;
//    }
//    
//    // Enumerator: 遍历器\迭代器
//    
//    ZYLog(@"%zd", size);
//    return size;
//}

- (unsigned long long)fileSize {
    
    // 总大小
    unsigned long long size = 0;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断路径存在/不存在
    //[manager fileExistsAtPath:self];
    
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 路径是否存在
    BOOL exists = [manager fileExistsAtPath:self isDirectory:&isDirectory];
    
    
    if (!exists) return size;
    // 判断是文件还是文件夹
    if (isDirectory) {
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [manager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else {
        size = [manager attributesOfItemAtPath:self error:nil].fileSize;
    }
    
    // Enumerator: 遍历器\迭代器
    return size;
}

@end
