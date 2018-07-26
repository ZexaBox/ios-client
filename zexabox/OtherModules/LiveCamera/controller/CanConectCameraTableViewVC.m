//
//  CanConectCameraTableViewVC.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CanConectCameraTableViewVC.h"
#import "CameraLoginViewController.h"
#import "UIViewController+Alert.h"
#import "CameraDetailViewController.h"
#import "URLRequest.h"
#import "CameraModel.h"
@interface CanConectCameraTableViewVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *groupView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@end

@implementation CanConectCameraTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"实时摄像头" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.arrayData = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    
    [URLRequest requestWithMethod:GET urlString:url_camera_scan parameters:nil finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response)
        {
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[CameraModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (void) login_request:(NSString *)user pwd:(NSString *)pwd model:(CameraModel *)model{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestJSON:POST urlString:url_camera_connect param:@{@"id":[NSString stringWithFormat:@"%@",model.id],@"user":user,@"password":pwd} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                CameraDetailViewController *vc = [CameraDetailViewController new];
                vc.video_url = response[@"data"][@"url"];
                vc.arrayData = self.arrayData;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.groupView;
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

- (UIView *)groupView{
    if(!_groupView){
        _groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UILabel *label = [_groupView labelWithTitle:[@"可连接摄像头" language] font:14 color:MainTextColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.groupView);
            make.left.equalTo(@15);
        }];
    }
    return _groupView;
}

@end
