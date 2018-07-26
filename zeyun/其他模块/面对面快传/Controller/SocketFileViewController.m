//
//  SocketFileViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SocketFileViewController.h"
#import <GCDAsyncSocket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "UIImage+Save.h"
#import "ZLQRCodeController.h"
#import "ZLPhotoManager.h"
#import "URLRequest.h"
#import "NSDate+TimeInterval.h"
@interface SocketFileViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *listenSocket;//主机
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;//客户机


@property (nonatomic,strong) UIImageView *qr_ImageIvew;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSData *fileData;
@property (nonatomic,assign) NSInteger port;
@end

@implementation SocketFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 拼接服务端地址和端口号用来生成二维码 */
    self.port = arc4random_uniform(9999)+10000;
    NSString *string = [NSString stringWithFormat:@"%@,%ld",[self getIPAddress],self.port];
    NSLog(@"%@",string);
    /** 生成二维码图片 */
    UIImage *image = [ZLQRCodeController getQRCodeImageWithString:string imageWidth:200];
    self.qr_ImageIvew = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:self.qr_ImageIvew];
    [self.qr_ImageIvew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.height.equalTo(@200);
    }];
    
    self.labelTitle.text = [@"二维码发送文件" language];
    /** 开启socket监听 */
    [self socketServer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.listenSocket disconnect];
    [self.clientSocket disconnect];
    [SVProgressHUD dismiss];
    self.listenSocket = nil;
}

- (void) socketServer
{
    self.listenSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *err;
    if(![self.listenSocket acceptOnPort:self.port error:&err])
    {
        NSLog(@"error:%@",err);
    }
}

- (void) sendData{
    
    if(self.arraySendData.count == 0){
        [FaceAlertTool svpShowSuccessInfo:@"文件发送完毕"];
        return;
    }
    NSDictionary *dic = self.arraySendData[0];
    NSString *name = [[dic allKeys] lastObject];
    PHAsset *asset = [dic valueForKey:name];
    name = [name uppercaseString];
    if([[name pathExtension] isEqualToString:@"JPG"] || [[name pathExtension] isEqualToString:@"PNG"] || [[name pathExtension] isEqualToString:@"GIF"]){
        [[[ZLPhotoManager alloc] init] getImageFromPHAsset:asset completion:^(NSString *name, UIImage *res, NSData *data) {
            [SVProgressHUD dismiss];
            self.fileData = data;
            self.filename = name;
            [self sendDataSendName:YES];
            
        }];
    }else{
        [[[ZLPhotoManager alloc] init] getVideoFromPHAsset:asset completion:^(NSString *name, UIImage *res, NSData *data) {
            [SVProgressHUD dismiss];
            self.fileData = data;
            self.filename = name;
            [self sendDataSendName:YES];
        }];
    }
}

- (void) sendDataSendName:(BOOL) issend{
    [SVProgressHUD dismiss];
    [FaceAlertTool svpShowWithState:[NSString stringWithFormat:@"%@-%@",[@"正在发送文件" language],self.filename]];
    if(issend){
        /** tag == 100标示发送的是文件的名字 */
        [self.clientSocket writeData:[[NSString stringWithFormat:@"{\"name\":\"%@\",\"length\":\"%ld\"}",self.filename,self.fileData.length] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:100];
    }else{
        /** tag == 200 标示发送的是文件的data */
        [self.clientSocket writeData:self.fileData withTimeout:-1 tag:200];
    }
}

#pragma mark --delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    self.clientSocket = newSocket;
    NSLog(@"服务器地址:%@ 端口:%d",self.clientSocket.connectedHost,self.clientSocket.connectedPort);
    /** 开启接收客户端数据 */
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    [sock readDataWithTimeout:-1 tag:0];//开启服务端监听客户端发送数据
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送完毕,%ld",tag);
    [self request];
}

- (void) request{
    long time = [[NSDate timestamp] longLongValue];
    [URLRequest requestJSON:POST urlString:url_faceToface_mark param:@{@"name":self.filename,@"size":@(self.fileData.length),@"timestamp":@(time),@"action":@"post"} finish:^(id response, NSError *error) {
        NSLog(@"对面快传发送文件====》%@",response);
    }];
}

- (NSString *)getIPAddress//获取服务机的ip地址
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


@end
