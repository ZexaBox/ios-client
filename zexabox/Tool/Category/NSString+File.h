//
//  NSString+File.h
//  UBaby
//
//  Created by fengei on 16/12/19.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

- (NSString *)moveFileName:(NSString *)filename;

//清除缓存文件
+(void)removeCache;

//计算缓存目录的大小
+ (unsigned long long)folderSizeAtPath;


/** 保存视频到本地 */
- (void)saveVideo;
@end
