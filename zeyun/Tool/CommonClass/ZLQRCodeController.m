//
//  ZLQRCodeController.m
//  MyTwoCodeTest
//
//  Created by fengei on 16/7/6.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ZLQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ZLQRCodeController()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) UIImageView *scanRectView;
@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preView;
@property (nonatomic,strong) UIWebView *webView;


@end
