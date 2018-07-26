//
//  ExternalDeviceImportVC.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExternalDeviceImportVC.h"
#import "ShareCell.h"
#import "ShareDefaultCell.h"
#import "UIViewController+Alert.h"
#import "ExternalSMSViewController.h"
#import "AlertViewController.h"
#import "CloudUploadImageViewController.h"
#import "CloudUploadVedioViewController.h"
#import "URLRequest.h"
@interface ExternalDeviceImportVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayImg;
@property (nonatomic,strong) NSArray *arrayfiletype;
@property (nonatomic,strong) UIButton *btnImport;
/** 当前验证码 */
@property (nonatomic,strong) NSString *currentCode;
@end

@implementation ExternalDeviceImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.labelTitle.text = [@"外接设备" language];
    
    [self registWithNibName:@"ShareDefaultCell" identifier:@"cell"];
    
//    [self.view addSubview:self.btnImport];
//    [self.btnImport mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@(-25));
//        make.left.equalTo(@60);
//        make.right.equalTo(@(-60));
//        make.height.equalTo(@50);
//    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.arrayfiletype = @[@"image",@"video",@"text",@"audio"];
}

- (void) right_action:(UIButton *)sender{
    
}

- (void) import_action{
    [FaceAlertTool svpShowWithState:@"验证码发送中..."];
    ExternalSMSViewController *vc = [ExternalSMSViewController new];
    vc.callback = ^(NSString *code){
        AlertViewController *temp = [[AlertViewController alloc] init];
        temp.alert_decodeTitle = [@"文件已导入" language];
        temp.alertType = alert_decode;
        [self alert:temp];
    };
    [self alert:vc];
    /** 网络请求 */
    [URLRequest requestWithMethod:GET urlString:url_sendsms parameters:@{@"mNumber":[UserInfoManager manager].mobile} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response != nil){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSString *code = [response[@"data"] valueForKey:@"mCode"];
                self.currentCode = code;
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[response valueForKey:@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayImg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0;
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelName.text = self.arrayData[indexPath.row];
    cell.headImageView.image = [UIImage imageNamed:self.arrayImg[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.arrayData[indexPath.row];
    if([title isEqualToString:[@"图片" language]]){
        CloudUploadImageViewController *vc = [CloudUploadImageViewController new];
        vc.isimportToDevice = YES;
        vc.externalModel = self.externalModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CloudUploadVedioViewController *vc = [CloudUploadVedioViewController new];
        vc.filetype = self.arrayfiletype[indexPath.row];
        vc.isimportTodevice = YES;
        vc.externalModel = self.externalModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
        [_arrayData addObjectsFromArray:@[[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language]]];
    }
    return _arrayData;
}
- (NSMutableArray *)arrayImg{
    if(!_arrayImg){
        _arrayImg = [NSMutableArray array];
        [_arrayImg addObjectsFromArray:@[@"图片文件夹",@"视频文件夹",@"文档文件夹",@"音乐文件夹"]];
    }
    return _arrayImg;
}

- (UIButton *)btnImport{
    if(!_btnImport){
        _btnImport = [self.view buttonWithTitle:[@"导入" language] font:16 color:[UIColor whiteColor]];
        _btnImport.backgroundColor = MainColor;
        _btnImport.layer.cornerRadius = 25;
        [_btnImport addTarget:self action:@selector(import_action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnImport;
}
@end
