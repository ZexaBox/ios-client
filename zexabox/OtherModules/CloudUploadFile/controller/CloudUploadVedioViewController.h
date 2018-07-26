//
//  CloudUploadVedioViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/11.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ExternalModel.h"
@interface CloudUploadVedioViewController : ZLBaseViewController


/** 是否是上传到共享空间的 */
@property (nonatomic,assign) BOOL isuploadToShare;
/** 如果是外接设备导入文件 */
@property (nonatomic,assign) BOOL isimportTodevice;
/** 是否是上传文件到云 */
@property (nonatomic,assign) BOOL isuploadCound;
/** 文件格式 */
@property (nonatomic,strong) NSString *filetype;

/** 导入文件到外接设备 */
@property (nonatomic,strong) ExternalModel *externalModel;

@property (nonatomic,copy) void (^callbackreload)(void);
@end
