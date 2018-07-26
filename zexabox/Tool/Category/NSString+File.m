//
//  NSString+File.m
//  UBaby
//
//  Created by fengei on 16/12/19.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "NSString+File.h"
@implementation NSString (File)

- (NSString *)moveFileName:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createPath = [filePath stringByAppendingPathComponent:filename];
    NSDictionary *fileInfo = [fileManager attributesOfItemAtPath:self error:nil];
    NSDictionary *fileInfo2 = [fileManager attributesOfItemAtPath:[NSString stringWithFormat:@"%@/data.pck",createPath] error:nil];
    if ([fileInfo2[@"NSFileCreationDate"] isEqualToDate:fileInfo[@"NSFileCreationDate"]]) {
        NSLog(@"创建时间相同");
    }else {
        NSLog(@"创建时间不同");
        [fileManager removeItemAtPath:createPath error:nil];
    }
    
    BOOL isDir = YES;
    
    if(![fileManager fileExistsAtPath:createPath isDirectory:&isDir])
    {
        BOOL isSuccess = [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(isSuccess){
            if([fileManager copyItemAtPath:self toPath:[createPath stringByAppendingPathComponent:@"data.pck"] error:nil]){
                NSLog(@"移动成功");
            }
        }else{
            NSLog(@"移动失败");
        }
    }
    return createPath;
}
+(void)removeCache
{
    //===============清除缓存==============
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cache_remove"];
    if([[NSFileManager defaultManager] removeItemAtPath:path error:nil]){
        //        NSLog(@"清除成功");
    }else{
        //        NSLog(@"清除失败");
    }
    //    NSLog(@"文件数 ：%lu",(unsigned long)[files count]);
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            if([[NSFileManager defaultManager] removeItemAtPath:path error:&error]){
                //                NSLog(@"清除成功");
            }else{
                //                NSLog(@"清除失败");
            }
            
        }
    }
}
+ (unsigned long long)folderSizeAtPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];//计算缓存目录的大小
    if (isExist){
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize / (1024.0 * 1024.0);
    } else {
        //        NSLog(@"file is not exist");
        return 0;
    }
}
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist){
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    } else {
        //        NSLog(@"file is not exist");
        return 0;
    }
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo{
    
    if (self) {
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self)) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(self, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
    
}
//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
    
}
@end
