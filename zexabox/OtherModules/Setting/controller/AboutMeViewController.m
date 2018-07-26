//
//  AboutMeViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "AboutMeViewController.h"
#import "URLRequest.h"
#import "UserReadViewController.h"
@interface AboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion2;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labeEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnArgment;
@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = [@"关于我们" language];
    self.labelAppName.text = [@"泽云" language];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.labelVersion.text = [NSString stringWithFormat:@"V.%@",app_Version];
    self.labelVersion2.text = [NSString stringWithFormat:@"%@：v%@",[@"当前版本" language],app_Version];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[@"客服热线：" language] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor hexStringToColor:@"#a5a5a5"]}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"0755-86951132" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:MainColor}];
    [str appendAttributedString:str2];
    self.labelPhone.attributedText = str;
    
    
    NSMutableAttributedString *strEmail = [[NSMutableAttributedString alloc] initWithString:[@"客服邮箱：" language] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor hexStringToColor:@"#a5a5a5"]}];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"service@zexabox.com" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:MainColor}];
    [strEmail appendAttributedString:str3];
    self.labeEmail.attributedText = strEmail;
    [self.btnArgment setTitle:[NSString stringWithFormat:@"《%@》",[@"泽云用户协议" language]] forState:UIControlStateNormal];
    [self requestData];
}

- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_setting_aboutUs parameters:nil finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            NSLog(@"aboutme = %@",response);
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (IBAction)user_read_action:(id)sender {
    [self.navigationController pushViewController:[UserReadViewController new] animated:YES];
}

@end
