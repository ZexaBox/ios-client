//
//  ImagePickerViewController.m
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "YFKit.h"
#import "FaceAlertTool.h"
@import AVFoundation;
@import Photos;
@interface ImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *ImageCut;
//
@property (nonatomic,strong) UIViewController *MyControl;
@end

@implementation ImagePickerViewController
- (void) alertView:(UIViewController *)control arraytitle:(NSArray *)arr{
    self.MyControl = control;
    [FaceAlertTool createSheetAlertWithTitle:nil MessageArray:arr inViewController:control titleColor:[UIColor blueColor] SheetAction:^(NSInteger index) {
        switch (index) {
            case 0:
                [self optimalPhotoBtnPressed:control];
                break;
            case 1:
//                if(self.btnheadImageClick) self.btnheadImageClick();
                [self optimalCameraBtnPressed:control];
                break;
            default:
                break;
        }
    }];
}
- (void)optimalCameraBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 应用第一次申请权限调用这里
        if ([YFKit isCameraNotDetermined])
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted)
                    {
                        // 用户授权
                        [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
                    }
                    else
                    {
                        // 用户拒绝授权
                        [self showAlertController:@"提示" message:@"授权失败"];
                    }
                });
            }];
        }
        // 用户已经拒绝访问摄像头
        else if ([YFKit isCameraDenied])
        {
            [self showAlertController:@"提示" message:@"拒绝访问摄像头，可去设置隐私里开启"];
        }
        
        // 用户允许访问摄像头
        else
        {
            [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else
    {
        // 当前设备不支持摄像头，比如模拟器
        [self showAlertController:@"提示" message:@"当前设备不支持拍照"];
    }
}

- (void)optimalPhotoBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // 第一次安装App，还未确定权限，调用这里
        if ([YFKit isPhotoAlbumNotDetermined])
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                // 该API从iOS8.0开始支持
                // 系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                        {
                            // 用户拒绝授权
                            [self showAlertController:@"提示" message:@"授权失败"];
                        }
                        else if (status == PHAuthorizationStatusAuthorized)
                        {
                            // 用户授权，弹出相册对话框
                            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                        }
                    });
                }];
            }
            else
            {
                // 以上requestAuthorization接口只支持8.0以上，如果App支持7.0及以下，就只能调用这里。
//                NSLog(@"// 以上requestAuthorization接口只支持8.0以上，如果App支持7.0及以下，就只能调用这里。");
                [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }
        else if ([YFKit isPhotoAlbumDenied])
        {
            // 如果已经拒绝，则弹出对话框
            [self showAlertController:@"提示" message:@"拒绝访问相册，可去设置隐私里开启"];
        }
        else
        {
            // 已经授权，跳转到相册页面
            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    else
    {
        // 当前设备不支持打开相册
        [self showAlertController:@"提示" message:@"当前设备不支持相册"];
    }
}
- (void)showAlertController:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.MyControl presentViewController:ac animated:YES completion:nil];
}
- (void)presentToImagePickerController:(UIImagePickerControllerSourceType)type
{
    self.picker.sourceType = type;
    [self.MyControl presentViewController:self.picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.image = self.isAllowdedEditor ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    if(!self.isAllowdedEditor) self.isAllowdedEditor = YES;
    [self.picker dismissViewControllerAnimated:YES completion:^{
        if(self.back)
        {
            self.back(self.image);
        }
    }];
}
+ (ImagePickerViewController *) shareImage
{
    static ImagePickerViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImagePickerViewController alloc]init];
    });
    
    return instance;
}

- (void)setIsAllowdedEditor:(BOOL)isAllowdedEditor{
    _isAllowdedEditor = isAllowdedEditor;
    self.picker.allowsEditing = isAllowdedEditor;
}

#pragma  mark -- getter
- (UIImagePickerController *)picker{
    if(!_picker){
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.navigationBar.tintColor = MainColor;
    }
    return _picker;
}
@end
