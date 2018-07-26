//
//  PngModel.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/8.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 谨慎修改此类，所以文件，下载，上传，共享空间文件，云空间，都用到此类 */
@interface PngModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *time;
/** 用户标示 */
@property (nonatomic,assign) NSInteger tag_id;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *file_type;
@property (nonatomic,assign) long size;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSString *download;
/** 自己使用的属性 */
@property (nonatomic,strong) UIImage *currentImage;
/** 是否是从云下载文件 */
@property (nonatomic,assign) BOOL isdownloadFromCloud;
@end
