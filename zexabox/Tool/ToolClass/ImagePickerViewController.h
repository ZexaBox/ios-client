//
//  ImagePickerViewController.h
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//



// <key>NSPhotoLibraryUsageDescription</key>
// <string>确认访问相册</string>
#import <UIKit/UIKit.h>
typedef void (^callBack)(UIImage *res);
typedef void (^btnheadImageClick)(void);
@interface ImagePickerViewController : UIViewController
+ (ImagePickerViewController *) shareImage;//获取相机实列
@property (nonatomic,assign) BOOL isAllowdedEditor;
@property (nonatomic,copy) callBack back;//返回照片
@property (nonatomic,copy) btnheadImageClick btnheadImageClick;
/** @[@"从相册选择",@"拍照"] */
- (void) alertView:(UIViewController *)control arraytitle:(NSArray *)arr;
@end
