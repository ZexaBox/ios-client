//
//  SocketSendFileViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SocketReceiveFileViewController.h"
#import <GCDAsyncSocket.h>
#import "ZLQRCodeController.h"
#import "UIImage+Save.h"
#import "ZLPhotoManager.h"
#import "NSString+File.h"
#import "URLRequest.h"
#import "NSDate+TimeInterval.h"
@interface SocketReceiveFileViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *socket;
@property (nonatomic,strong) NSString *stringIP;

@property (nonatomic,strong) NSMutableData *filedata;
@property (nonatomic,strong) NSString *fileName;
/** 传输文件的总大小 */
@property (nonatomic,assign) long datalength;
@property (nonatomic,assign) NSInteger port;
@end

@implementation SocketReceiveFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ZLQRCodeController *qr_vc = [ZLQRCodeController shareZLQRCode];
    self.labelTitle.text = [@"扫码接收文件" language];
    qr_vc.labelTitle.text = [@"二维码扫描" language];
    qr_vc.view.frame = self.view.bounds;
    [self addChildViewController:qr_vc];
    [self.view addSubview:qr_vc.view];
    
    [qr_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    __weak typeof(qr_vc) weakvc = qr_vc;
    qr_vc.resBack = ^(NSString *res) {
        NSArray *array = [res componentsSeparatedByString:@","];
        self.port = [array[1] integerValue];
        self.stringIP = array[0];
        [weakvc.view removeFromSuperview];
        [weakvc removeFromParentViewController];
        /** 连接服务端 */
        [self connect2Server];
    };
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.socket disconnect];
}

- (void) connect2Server{
    //1.主机与端口号
    
    //初始化socket，这里有两种方式。分别为是主/子线程中运行socket。根据项目不同而定
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//这种是在主线程中运行
    
    //开始连接
    NSError *error = nil;
    [FaceAlertTool svpShowWithState:@"正在连接..."];
    [self.socket connectToHost:self.stringIP onPort:self.port error:&error];
    if(error) {
        NSLog(@"error:%@", error);
        [FaceAlertTool svpShowSuccessInfo:[NSString stringWithFormat:@"连接失败%@",error]];
        return;
    }
    
    [self.socket writeData:[@"begin" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功
    NSLog(@"%s",__func__);
    NSLog(@"链接成功");
    [FaceAlertTool svpShowSuccessInfo:@"连接成功"];
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
//    if (err) {
//        NSLog(@"连接失败");
//        [FaceAlertTool svpShowErrorWithMsg:[NSString stringWithFormat:@"连接失败，请确定设备之间是否在同一网络%@",err]];
//    }else{
        NSLog(@"正常断开");
        [FaceAlertTool svpShowErrorWithMsg:@"连接已断开"];
//    }
    
}

#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 读取数据

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    }
    
    /** 让服务端不停的发送数据 */
    [sock readDataWithTimeout:-1 tag:0];
}

- (void) request{
    long time = [[NSDate timestamp] longLongValue];
    [URLRequest requestJSON:POST urlString:url_faceToface_mark param:@{@"name":self.fileName,@"size":@(self.filedata.length),@"timestamp":@(time),@"action":@"get"} finish:^(id response, NSError *error) {
        NSLog(@"对面快传接收文件====》%@",response);
    }];
}
@end
