//
//  SendFilesViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/15.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SendFilesViewController.h"
#import "ZLPhotoManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ProgressIconBtn.h"
#import "ZLQRCodeController.h"
#import "SocketFileViewController.h"
@interface SendFilesViewController ()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) ProgressIconBtn *receiverBtn;

@property (weak, nonatomic) IBOutlet UIImageView *qr_imageView;
@property (strong,nonatomic) MCSession *session;
@property (strong,nonatomic) MCNearbyServiceAdvertiser *nearbyServiceAdveriser;
@property (strong, nonatomic) MCNearbyServiceBrowser *nearbyServiceBrowser;
@property (strong, nonatomic) MCPeerID *peerID;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIImageView *StatusImageView;
/** 传输完成个数 */
@property (nonatomic,assign) NSInteger sendCount;
/** 传输状态 */
@property (weak, nonatomic) IBOutlet UILabel *labelSendStatus;

@property (nonatomic,strong) NSMutableArray *arrayFinish;
@end

@implementation SendFilesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //MultipeerConnectivity.framework了解
    //    MCAdvertiserAssistant //广播助手类 可以接收，并处理用户请求连接的响应。没有回调，会弹出默认的提示框，并处理连接
    
    //    MCNearbyServiceAdvertiser //附近广播服务类 可以接收并处理用户连接的响应。但是，这个类会有回调，告知用户要与你的设备连接，然后可以自定义提示框，以及自定义连接处理
    //    MCNearbyServiceBrowser //附近搜索服务类 用于所搜附近的用户，并可以对搜索到的用户发出邀请加入某个回话中
    //    MCPeerID //点ID类 代表一个用户
    //    MCSession //回话类 启用和管理Multipeer连接回话中的所有人之间的沟通通过Session个别人发送数据
    //    MCBrowserViewController //提供一个标准的用户界面 该界面允许用户进行选择附近设备peer来加入一个session
    
    //注意：根据serviceType创建的对象，该serviceType命名规则：serviceType=由ASCII字母、数字和“-”组成的短文本串，最多15个字符。通常，一个服务的名字应该由应用程序的名字开始，后边跟“-”和一个独特的描述符号。如果不符合，会报错的。
    
    //使用注意：无论是接收者还是发送者都需要在广播数据的同时发送数据，方便发现对方建立连接回话；数据的传输必须要在回话建立完成后才能开始。
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnSearch.layer.borderColor = MainColor.CGColor;
    self.btnSearch.layer.borderWidth = 1.0;
    self.btnScan.layer.borderColor = MainColor.CGColor;
    self.btnScan.layer.borderWidth = 1.0;
    self.btnSearch.selected = YES;
    self.btnSearch.backgroundColor = MainColor;
    [self.btnScan setTitle:[@"二维码发送" language] forState:UIControlStateNormal];
    [self.btnSearch setTitle:[@"搜索附近" language] forState:UIControlStateNormal];
    self.labelSendStatus.text = [@"请对方打开快传，选择接收" language];
    
    [self addOwnViews];
    [self scanNearbyPeer];
    
    
    [self addAnimation];
    self.arrayFinish = [NSMutableArray array];
    self.labelTitle.text = [NSString stringWithFormat:@"%@(%ld)",[@"发送文件" language],self.arrayPath.count];
}

- (IBAction)search_action:(UIButton *)sender {
    self.btnScan.selected = NO;
    self.btnSearch.selected = YES;
    self.qr_imageView.hidden = YES;
    self.btnScan.backgroundColor = [UIColor whiteColor];
    self.btnSearch.backgroundColor = MainColor;
}
- (IBAction)scan_action:(UIButton *)sender {
//    self.btnSearch.selected = NO;
//    self.btnScan.selected = YES;
//    self.btnScan.backgroundColor = MainColor;
//    self.btnSearch.backgroundColor = [UIColor whiteColor];
//    self.qr_imageView.hidden = NO;
//    self.qr_imageView.image = [ZLQRCodeController getQRCodeImageWithString:[[UIDevice currentDevice] name] imageWidth:250];
    SocketFileViewController *vc = [SocketFileViewController new];
    vc.arraySendData = self.arrayPath;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [self.arrayFinish enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err = nil;
        BOOL ret = [manager removeItemAtPath:obj error:&err];
        if (!ret) {
            NSLog(@"删除临时文件出错：err = %@", err.localizedDescription);
        }else{
            NSLog(@"清除文件成功");
        }
    }];
}

#pragma mark - Public

#pragma mark - Private

- (void)addOwnViews
{
    //progressIconBtn
    ProgressIconBtn *btn = [[ProgressIconBtn alloc] init];
    CGFloat btnWH = 100;
    btn.frame = CGRectMake(0, 0, btnWH, btnWH);
    btn.center = CGPointMake(SCREEN_WIDTH / 2.0, 180);
    btn.backgroundColor = [UIColor clearColor];
    btn.hidden = YES;
    [btn addTarget:self action:@selector(receiverBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.receiverBtn = btn;
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
    //创建会话(两边的回话类型必须一致)
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionRequired];
    self.session.delegate = self;
    
    //广播通知(广播是通过serviceType来区分，所以监听广播的serviceType必须相同，不然监听不到)
    self.nearbyServiceAdveriser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:nil serviceType:@"rsp-zysender"];
    self.nearbyServiceAdveriser.delegate = self;
    [self.nearbyServiceAdveriser startAdvertisingPeer];
    
    //监听广播
    self.nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:@"rsp-zyreceiver"];
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

- (void)receiverBtnClicked:(UIButton *)btn
{
    //发出邀请
    //context 携带请求的附加信息
    [self.nearbyServiceBrowser invitePeer:self.peerID toSession:self.session withContext:nil timeout:30];
}

- (void) sendData{


#pragma mark - MCNearbyServiceAdvertiserDelegate

// 收到节点邀请回调
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession * __nullable session))invitationHandler
{
    //只有发送者发出邀请，接收者接收邀请
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
        case MCSessionStateNotConnected:{//未连接
            NSLog(@"未连接");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.receiverBtn.hidden = YES;
            });
            break;
        }
        case MCSessionStateConnecting://连接中
            NSLog(@"未连接");
            break;
        case MCSessionStateConnected://连接完成
        {
            [self sendData];
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
}

// 数据传输完成回调
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error
{
    NSLog(@"数据传输结束%@----%@", localURL.absoluteString, error);
}


        });
    }
}

@end
