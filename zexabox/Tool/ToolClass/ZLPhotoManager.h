//
//  ZLPhotoManager.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/14.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface ZLPhotoManager : NSObject

@property (nonatomic,strong) NSMutableArray<PHAsset *> *arrayData;


/** 获取高清图 */
- (void) getImageFromPHAsset:(PHAsset *)asset completion:(void(^)(NSString * name,UIImage *res,NSData*data))completion;

/** 根据PHAsset获取缩略图 */
- (void) getImageForomPhAsset:(PHAsset *)asset completion:(void(^)(NSString * name,UIImage *res))completion;


/** 根据PHAsset获取视频 */
- (void)getVideoFromPHAsset:(PHAsset *)asset completion:(void(^)(NSString * name,UIImage *res,NSData*data))completion;

/** 获取相册 */
-(void)GetALLphotosUsingPohotKit:(void(^)(NSArray<PHAsset *> *res))completion;

/** 获取视频 */
-(void)GetALLVideoUsingPohotKit:(void(^)(NSArray<PHAsset *> *res))completion;


/** 获取视频封面 */
- (void) getVideoFaceImage:(PHAsset *)asset complemtion:(void(^)(UIImage *res,NSString *name))completion;

/** 获取视频封面图 */
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL;

@end
