//
//  ZLPhotoManager.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/14.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLPhotoManager.h"

@interface ZLPhotoManager()

@property (nonatomic,strong) PHCachingImageManager *imageManager;
@end

@implementation ZLPhotoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)GetALLphotosUsingPohotKit:(void (^)(NSArray<PHAsset *> *))completion
{
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSLog(@" 相册名称 == %@（%ld）",collection.localizedTitle,fetchResult.count);
            NSArray *assets;
            if (fetchResult.count > 0) {
                // 某个相册里面的所有PHAsset对象
                assets = [self getAllPhotosAssetInAblumCollection:assetCollection type:PHAssetMediaTypeImage ascending:YES ];
                [self.arrayData addObjectsFromArray:assets];
            }
        }
    }
    if(completion) completion(self.arrayData);
}


/** 获取视频 */
- (void)GetALLVideoUsingPohotKit:(void (^)(NSArray<PHAsset *> *))completion
{
    // 所有视频
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        PHCollection *collection = smartAlbums[i];
        //遍历获取视频
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                NSArray *assets;
                if (fetchResult.count > 0) {
                    // 某个视频里面的所有PHAsset对象
                    assets = [self getAllPhotosAssetInAblumCollection:assetCollection type:PHAssetMediaTypeVideo ascending:YES ];
                    [self.arrayData addObjectsFromArray:assets];
                }
        }
    }
    
    
    if(completion) completion(self.arrayData);
}


/** 获取视频 */
- (void)getVideoFromPHAsset:(PHAsset *)asset completion:(void(^)(NSString * name,UIImage *res,NSData*data))completion{
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (@available(iOS 9.1, *)) {
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        } else {
            // Fallback on earlier versions
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (@available(iOS 9.1, *)) {
        if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
            
            NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            
            [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
                
                NSMutableData *data = [NSMutableData dataWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]]];
                if(completion) completion(fileName,nil,data);
                [data setLength:0];
                [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                
                
            }];
        }
    } else {
        // Fallback on earlier versions
    }
}


/** 获取视频封面图 */
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}


#pragma mark - <  获取相册里的所有图片的PHAsset对象  >
- (NSArray *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection type:(PHAssetMediaType)type ascending:(BOOL)ascending
{
    // 存放所有图片对象
    NSMutableArray *assets = [NSMutableArray array];
    
    // 是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", type];
    
    // 获取所有图片对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    for(NSInteger i = 0; i < result.count; i++){
        [assets addObject:result[i]];
    }
    return assets;
}

/** 获取标准图片数据 */
- (void)getImageFromPHAsset:(PHAsset *)asset completion:(void (^)(NSString *, UIImage *, NSData *))completion{
    __block NSData *data;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             if ([resource.originalFilename containsString:@"HEIC"]) {
                 CIImage *ciImage = [CIImage imageWithData:imageData];
                 CIContext *context = [CIContext context];
                 if (@available(iOS 10.0, *)) {
                     data =  [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
                 } else {
                     // Fallback on earlier versions
                 }
             } else {
                 data = [NSData dataWithData:imageData];
             }
         }];
    }
    
    if(completion) completion(resource.originalFilename,[UIImage imageWithData:data scale:0.5],data);
}

- (void) getImageForomPhAsset:(PHAsset *)asset completion:(void(^)(NSString * name,UIImage *res))completion{
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(108, 99) contentMode:(PHImageContentModeAspectFit) options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if(completion) completion(resource.originalFilename,result);
        }];
    }
}


- (void) getVideoFaceImage:(PHAsset *)asset complemtion:(void(^)(UIImage *res,NSString *name))completion{
    
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(108, 90) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        UIImage *temp = [self get_not_nil:result];
        NSData *data = UIImageJPEGRepresentation(temp, 0.5);
        UIImage *resultImage = [UIImage imageWithData:data];
        if(completion)completion(resultImage,resource.originalFilename);
    }];
    
//    [self.imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        NSData *data = UIImageJPEGRepresentation(imageData, 0.5);
//        UIImage *resultImage = [UIImage imageWithData:data];
//        if(completion)completion(resultImage,resource.originalFilename);
//    }];
}

- (UIImage *) get_not_nil:(UIImage *)image{
    //确定压缩后的size
    CGFloat scaleWidth = image.size.width;
    CGFloat scaleHeight = image.size.height;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文
    UIGraphicsBeginImageContext(scaleSize);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) scaleVideo:(NSURL *)inputURL completion:(void(^)(NSURL *url))completion{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    NSString *outputpath = [[inputURL path] stringByReplacingOccurrencesOfString:@".MOV" withString:@".MP4"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputpath];
    NSLog(@"%@",outputpath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         if(exportSession.status == AVAssetExportSessionStatusCompleted){
             if(completion) completion(outputURL);
         }
     }];
}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

- (NSMutableArray<PHAsset *> *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
@end
