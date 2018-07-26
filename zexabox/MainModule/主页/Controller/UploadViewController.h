//
//  UploadViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BaseTableViewController.h"

@class UploadViewController;

/** 主页上传文件 和 共享新建文件共用此类 */
@interface UploadViewController : BaseTableViewController


@property (nonatomic,strong) NSArray *arrayData;

@property (nonatomic,strong) NSArray *arrayImg;

@property (nonatomic,copy) void (^callback)(NSString *title,NSInteger row);
@end
