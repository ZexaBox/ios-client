//
//  PngFileDateViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngFileDateViewController.h"
#import "URLRequest.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface PngFileDateViewController ()<TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnOneDay;
@property (weak, nonatomic) IBOutlet UIButton *btnSevenDay;
@property (weak, nonatomic) IBOutlet UIButton *btnLongDay;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;
@property (weak, nonatomic) IBOutlet UIButton *btnWX;
@property (weak, nonatomic) IBOutlet UIButton *btnQQ;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
/** 文件有效期 */
@property (weak, nonatomic) IBOutlet UILabel *labelFileDate;

@end

@implementation PngFileDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self asptF:self.btnOneDay];
    [self asptF:self.btnSevenDay];
    [self asptF:self.btnLongDay];
    [self asptF:self.btnCopy];
    [self asptF:self.btnWX];
    [self asptF:self.btnQQ];
    
    [self.btnOneDay setTitle:[@"一天过期" language] forState:UIControlStateNormal];
    [self.btnSevenDay setTitle:[@"七天过期" language] forState:UIControlStateNormal];
    [self.btnLongDay setTitle:[@"永久有效" language] forState:UIControlStateNormal];
    [self.btnCopy setTitle:[@"复制私密链接" language] forState:UIControlStateNormal];
    [self.btnWX setTitle:[@"分享到微信" language] forState:UIControlStateNormal];
    [self.btnQQ setTitle:[@"分享到QQ" language] forState:UIControlStateNormal];
    self.labelFileDate.text = [@"文件有效期" language];
}
- (void) asptF:(UIButton *)sender{
    sender.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (IBAction)choose_action:(UIButton *)sender {
    [self.stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)copylink_action:(UIButton *)sender {
    [self requestLink:0];
}
- (IBAction)wx_action:(id)sender {
    [self requestLink:1];
}
- (IBAction)qq_action:(id)sender {
    [self requestLink:2];
}

/** 0:copy到粘贴板，1：微信，2:QQ */
- (void) requestLink:(NSInteger) tag{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    NSString *url;
    if(self.issharespace){
        url = url_sharespace_share;
    }else{
        url = url_nas_file_share;
    }
    
    NSInteger day = 1;
    if(self.btnSevenDay.selected){
        day = 7;
    }
    if(self.btnLongDay.selected){
        day = 0;
    }
    
    [URLRequest requestJSON:POST urlString:url param:@{@"file_id":self.model.id,@"day":@(day)} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSString *url = [NSString stringWithFormat:@"%@%@",BaseImageURL,response[@"data"][@"url"]];
                if(tag == 0){
                    [UIPasteboard generalPasteboard].string = url;
                    [FaceAlertTool svpShowSuccessInfo:@"已复制到粘贴板"];
                }
                if(tag == 1){
                    //微信
                    [self shareWithTag:url];
                }
                if(tag == 2){
                    //qq
                    [self shareQQ:url];
                }
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
}

- (void) shareWithTag:(NSString *)url{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"点击查看分享文件";
    message.description = [NSString stringWithFormat:@"%@",self.model.name];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;//分享链接
    message.mediaObject = webObj;
    req.message = message;
    req.bText = NO;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    req.scene = WXSceneSession;
    BOOL res = [WXApi sendReq:req];
    NSLog(@"微信结果===%@",@(res));
}

- (void) shareQQ:(NSString *)url{
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:url] title:@"点击查看分享文件" description:self.model.name previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@"test"], 1) targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
    // 分享给好友
    [QQApiInterface sendReq:req];
}


@end
