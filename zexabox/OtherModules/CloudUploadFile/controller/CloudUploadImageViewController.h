//
//  CloudUploadImageViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/11.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ExternalModel.h"
@interface CloudUploadImageViewController : ZLBaseViewController

@property (nonatomic,strong) NSString *filetype;
/** 是否是上传文件到共享中心 */
@property (nonatomic,assign) BOOL isuploadShare;
/** 是否是上传文件到外接设备 */
@property (nonatomic,assign) BOOL isimportToDevice;
/** 是否是上传到云 */
@property (nonatomic,assign) BOOL isuploadToClound;

/** 导入到外接设备 */
@property (nonatomic,strong) ExternalModel *externalModel;

@property (nonatomic,copy) void (^callbackreload)(void);
@end
