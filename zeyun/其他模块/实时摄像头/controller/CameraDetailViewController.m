//
//  CameraDetailViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CameraDetailViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "MRVLCPlayer.h"
#import "URLRequest.h"
#import "CameraLoginViewController.h"
#import "UIViewController+Alert.h"
@interface CameraDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headView;
//@property (nonatomic,strong) VLCMediaPlayer *vlePlayer;
//@property (nonatomic,strong) UIView *palerView;
@property (nonatomic,strong) MRVLCPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *labelNotice;
@property (weak, nonatomic) IBOutlet UILabel *labelUse;
@end

@implementation CameraDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.labelNotice.text = [@"暂无可用摄像头" language];
    self.labelUse.text = [@"可用摄像头" language];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"实时摄像头" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [self.btnRight setTitle:@"┼" forState:UIControlStateNormal];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self reload_url:self.video_url];
}

- (void)right_action{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) reload_url:(NSString *)stringURL{
    [self.player dismiss];
    self.player = [[MRVLCPlayer alloc] init];
    self.player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    self.player.center = self.view.center;
    self.player.mediaURL = [NSURL URLWithString:stringURL];
    [self.player showInView:self.view];
    
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.headView.mas_top);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player dismiss];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CameraModel *model = self.arrayData[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = MainTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CameraLoginViewController *login = [CameraLoginViewController new];
    [self alert:login];
    CameraModel *model = self.arrayData[indexPath.row];
    login.callback = ^(NSString *accout, NSString *pwd) {
        [self login_request:accout pwd:pwd model:model];
    };
}


- (void) login_request:(NSString *)user pwd:(NSString *)pwd model:(CameraModel *)model{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestJSON:POST urlString:url_camera_connect param:@{@"id":[NSString stringWithFormat:@"%@",model.id],@"user":user,@"password":pwd} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSString *url = response[@"data"][@"url"];
                if(![url isKindOfClass:[NSNull class]]  && url != nil){
                    [self reload_url:url];
                }
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}
//- (UIView *)palerView
//{
//    if(!_palerView)
//    {
//        _palerView = [[UIView alloc]initWithFrame:CGRectZero];
//    }
//    return _palerView;
//}

@end
