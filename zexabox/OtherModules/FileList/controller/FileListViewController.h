//
//  FileListViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/10.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FileCommonController.h"
/** 文件九宫格，可转变浏览方式 */
@interface FileListViewController : FileCommonController

/** 文件类型 */
@property (nonatomic,strong) NSString *stringFileType;
/** 文件ID */
@property (nonatomic,strong) NSString *stringFolderName;
/** 文件夹ID */
@property (nonatomic,strong) NSString *folderID;

/** 是否是上传到云,是否上传到共享空间最后选择都会走回调 */
@property (nonatomic,assign) BOOL iscloundUpload;
/** 是否上传到共享空间 */
@property (nonatomic,assign) BOOL isuploadToShare;
/** 是否是导入文件到外接设备 */
@property (nonatomic,assign) BOOL isimporttoDevice;
@property (nonatomic,copy) void (^callbackChooseUploadToCloud)(PngModel *model,BOOL isAdd);
@end
