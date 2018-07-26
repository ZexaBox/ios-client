//
//  ReceiveFileViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ReceiveFileViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ProgressIconBtn.h"
#import "UIImage+Save.h"
#import "NSString+File.h"
#import "ZLQRCodeController.h"
#import "SocketFileViewController.h"
#import "SocketReceiveFileViewController.h"
#import "YFKit.h"
@interface ReceiveFileViewController ()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIImageView *StatusImageView;



@property (weak, nonatomic) ProgressIconBtn *receiverBtn;

@property (strong,nonatomic) MCSession *session;
@property (strong,nonatomic) MCNearbyServiceAdvertiser *nearbyServiceAdveriser;
@property (strong, nonatomic) MCNearbyServiceBrowser *nearbyServiceBrowser;
@property (strong, nonatomic) MCPeerID *peerID;
@property (strong, nonatomic) NSProgress *progress;
/** 发送文件状态 */
@property (weak, nonatomic) IBOutlet UILabel *labelSendStatus;
@property (nonatomic,assign) NSInteger receiveCount;
@end

@implementation ReceiveFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnSearch.layer.borderColor = MainColor.CGColor;
    self.btnSearch.layer.borderWidth = 1.0;
    self.btnScan.layer.borderColor = MainColor.CGColor;
    self.btnScan.layer.borderWidth = 1.0;
    self.btnSearch.selected = YES;
    self.btnSearch.backgroundColor = MainColor;
    
    self.labelTitle.text = [@"收文件" language];
    
    [self.btnScan setTitle:[@"扫码接收" language] forState:UIControlStateNormal];
    [self.btnSearch setTitle:[@"搜索附近" language] forState:UIControlStateNormal];
    self.labelSendStatus.text = [@"请对方打开快传，选择发送" language];
    
    [self addAnimation];
    ProgressIconBtn *btn = [[ProgressIconBtn alloc] init];
    CGFloat btnWH = 100;
    btn.frame = CGRectMake(0, 0, btnWH, btnWH);
    btn.center = CGPointMake(SCREEN_WIDTH / 2.0, 180);
    btn.backgroundColor = [UIColor clearColor];
    btn.hidden = YES;
    [self.view addSubview:btn];
    self.receiverBtn = btn;
    /** 开始扫描附近节点 */
    [self scanNearbyPeer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.receiverBtn.hidden) {
        self.receiverBtn.hidden = YES;
    }
    if (self.nearbyServiceAdveriser) {
        [self.nearbyServiceAdveriser stopAdvertisingPeer];
    }
    if (self.nearbyServiceBrowser) {
        [self.nearbyServiceBrowser stopBrowsingForPeers];
    }
}


- (IBAction)scan_action:(UIButton *)sender {
    if ([YFKit isCameraDenied]){
        [FaceAlertTool svpShowErrorWithMsg:@"请打开相机访问权限"];
        return;
    }
    self.btnSearch.selected = NO;
    self.btnScan.selected = YES;
    self.btnScan.backgroundColor = MainColor;
    self.btnSearch.backgroundColor = [UIColor whiteColor];
    SocketReceiveFileViewController *vc = [SocketReceiveFileViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)search_action:(UIButton *)sender {
    self.btnScan.selected = NO;
    self.btnSearch.selected = YES;
    self.btnScan.backgroundColor = [UIColor whiteColor];
    self.btnSearch.backgroundColor = MainColor;
}

- (void) addAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.StatusImageView.layer addAnimation:animation forKey:nil];
}

//扫描附近设备
- (void)scanNearbyPeer
{
    //创建会话
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    self.session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionOptional];
    self.session.delegate = self;
    
    //广播通知
    self.nearbyServiceAdveriser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:nil serviceType:@"rsp-zyreceiver"];
    self.nearbyServiceAdveriser.delegate = self;
    [self.nearbyServiceAdveriser startAdvertisingPeer];
    
    //监听广播
    self.nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:@"rsp-zysender"];
    self.nearbyServiceBrowser.delegate = self;
    [self.nearbyServiceBrowser startBrowsingForPeers];
    
}
//显示扫描到的节点
- (void)showPeer
{
    self.receiverBtn.hidden = NO;
    self.receiverBtn.nickName.text = self.peerID.displayName;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5f;
    transition.type = @"rippleEffect";
    [self.receiverBtn.layer addAnimation:transition forKey:nil];
    [self.view bringSubviewToFront:self.receiverBtn];
}

//隐藏扫描到的节点
- (void)hidePeer
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5f;
    transition.type = @"rippleEffect";
    [self.receiverBtn.layer addAnimation:transition forKey:nil];
    [self.view bringSubviewToFront:self.receiverBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.receiverBtn.hidden = YES;
    });
}

#pragma mark - Action

#pragma mark - MCNearbyServiceBrowserDelegate

// 发现了附近的广播节点
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID
withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info
{
    NSLog(@"发现了节点：%@", peerID.displayName);
    //这里只考虑一个节点的情况
    [browser stopBrowsingForPeers];
    
    self.peerID = peerID;
    
    //更新UI显示
    [self showPeer];
}

// 广播节点丢失
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"丢失了节点：%@", peerID.displayName);
    //这里只考虑一个节点的情况
    [browser startBrowsingForPeers];
    
    self.peerID = nil;
    
    //更新UI显示
    [self hidePeer];
}

// 搜索失败回调
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    [browser stopBrowsingForPeers];
    NSLog(@"搜索出错：%@", error.localizedDescription);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

// 收到节点邀请回调
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession * __nullable session))invitationHandler
{
    NSLog(@"收到%@节点的连接请求", peerID.displayName);
    [advertiser stopAdvertisingPeer];
    
    //交互选择框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@%@", peerID.displayName,[@"请求与你建立连接" language]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:[@"接受" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(YES, self.session);
    }];
    [alert addAction:accept];
    UIAlertAction *reject = [UIAlertAction actionWithTitle:[@"拒绝" language] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(NO, self.session);
    }];
    [alert addAction:reject];
    [self presentViewController:alert animated:YES completion:nil];
}

// 广播失败回调
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    [advertiser stopAdvertisingPeer];
    NSLog(@"%@节点广播失败", advertiser.myPeerID.displayName);
}

#pragma mark - MCSessionDelegate

// 会话状态改变回调
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateNotConnected://未连接
            NSLog(@"未连接");
            break;
        case MCSessionStateConnecting://连接中
            NSLog(@"连接中");
            break;
        case MCSessionStateConnected://连接完成
        {
            NSLog(@"连接完成");
        }
            break;
    }
}

// 普通数据传输
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"普通数据%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

// 数据流传输
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"数据流%@", peerID.displayName);
}

// 数据源传输开始
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"数据传输开始");
    //KVO观察
//    self.progress = progress;
//    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    self.labelSendStatus.text = [@"正在接收数据..." language];
}
// 数据传输完成回调
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error
{
    if (error) {
        NSLog(@"数据传输结束%@----%@", localURL.absoluteString, error);
    }else {
        NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:resourceName];
        NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
        //判断文件是否存在，存在则删除
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:destinationPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
        }
        //转移文件
        NSError *error1 = nil;
        if (![[NSFileManager defaultManager] moveItemAtURL:localURL toURL:destinationURL  error:&error1]) {
            NSLog(@"移动文件出错：error = %@", error1.localizedDescription);
        }else {
            self.receiveCount += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                NSFileManager *manager = [NSFileManager defaultManager];
                NSDictionary *attrs = [manager attributesOfItemAtPath:destinationPath error:&error];
                if (error) {
                    NSLog(@"读取文件属性出错：error = %@", error.localizedDescription);
                }else {
                    NSLog(@"文件存储路径%@", destinationPath);
                    NSLog(@"文件大小%@", attrs[NSFileSize]);
                    UIImage *image = [UIImage imageWithContentsOfFile:destinationPath];
                    if(image){
                        [image saveImage];
                    }else{
                        [destinationPath saveVideo];
                    }
                }
                self.labelSendStatus.text = [NSString stringWithFormat:@"%@%ld",[@"接收文件成功" language],self.receiveCount];
            });
            //移除监听
//            [self.progress removeObserver:self forKeyPath:@"completedUnitCount" context:nil];
        }
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSProgress *progress = (NSProgress *)object;
    NSLog(@"%lf", progress.fractionCompleted);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.receiverBtn setProgressValue:progress.fractionCompleted];
//    });
}

@end
