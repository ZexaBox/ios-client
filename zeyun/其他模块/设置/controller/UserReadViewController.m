
//
//  UserReadViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UserReadViewController.h"
#import <WebKit/WebKit.h>
#import "URLRequest.h"
@interface UserReadViewController ()

@property (nonatomic,strong) WKWebView *webview;
@end

@implementation UserReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = [@"泽云用户协议" language];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *pre = [[WKPreferences alloc] init];
    pre.minimumFontSize = 40;
    config.preferences = pre;
    self.webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:self.webview];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self request];
}

- (void) request{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_regist_protocol parameters:nil finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                [self.webview loadHTMLString:response[@"data"] baseURL:nil];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
    
}


@end
