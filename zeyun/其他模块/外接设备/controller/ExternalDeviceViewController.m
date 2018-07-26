//
//  ExternalDeviceViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExternalDeviceViewController.h"
#import "UploadViewController.h"
#import "ExternalDeviceCell.h"
#import "ExternalDeviceImportVC.h"
#import "AlertViewController.h"
#import "URLRequest.h"
#import "ShareDefaultCell.h"
#import "ShareFileListViewController.h"
#import "ExternalModel.h"
#import "ExteralFileListViewController.h"
@interface ExternalDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayImg;
@property (nonatomic,strong) NSMutableArray *arrayDirectory;
@property (nonatomic,strong) UIButton *btnCopy;
@property (nonatomic,strong) UploadViewController *alertVC;

@property (nonatomic,strong) NSMutableArray *arrayFinish;
@end

@implementation ExternalDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"外接设备" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.btnRight setImage:[UIImage imageNamed:@"更多_填充"] forState:UIControlStateNormal];
    self.btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.btnRight addTarget:self action:@selector(right_more_action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self registWithNibName:@"ExternalDeviceCell" identifier:@"cell"];
//    [self registWithNibName:@"ShareDefaultCell" identifier:@"cell"];
    
    [self.view addSubview:self.btnCopy];
    [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-25));
        make.left.equalTo(@60);
        make.right.equalTo(@(-60));
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnCopy.mas_top).offset(-25);
    }];
    
    self.arrayDirectory = [NSMutableArray array];
    self.arrayFinish = [NSMutableArray array];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.alertVC dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_external_list parameters:@{@"path":@"/"} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[ExternalModel class]];
                [self.arrayDirectory removeAllObjects];
                [self.arrayData removeAllObjects];
                [array enumerateObjectsUsingBlock:^(ExternalModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.file_type isEqualToString:@"folder"]){
                        [self.arrayDirectory addObject:obj];
                    }else{
                        [self.arrayData addObject:obj];
                    }
                }];
                [self.tableView reloadData];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[NSString stringWithFormat:@"%@",[response valueForKey:@"message"]]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器出错"];
        }
    }];
}


//MARK:-----------action-------------//
- (void)right_more_action:(UIButton *)sender{
    UploadViewController *vc = [UploadViewController new];
    self.alertVC = vc;
    vc.view.frame = CGRectMake(0, 0, 151, 120);
    vc.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    vc.preferredContentSize = vc.view.frame.size;//设置弹出视图大小必须好推送类型相同
    UIPopoverPresentationController *pover = vc.popoverPresentationController;
    pover.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sender];
    [pover setSourceView:sender];//设置目标视图，这两个是必须设置的。
    pover.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        vc.arrayImg = @[@"导入",@"复制",@"断开"];
        vc.arrayData = @[[@"导入文件" language],[@"一键拷贝" language],[@"安全拔出" language]];
    }];
    vc.callback = ^(NSString *title, NSInteger row) {
        [self choose_action:title];
    };
}

- (void) copy_action{
    if(self.arrayFinish.count == 0){
        [FaceAlertTool svpShowErrorWithMsg:@"请选择文件"];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [self.arrayFinish enumerateObjectsUsingBlock:^(ExternalModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.path];
    }];
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestJSON:POST urlString:url_external_copy_todevice param:@{@"path":array} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                [FaceAlertTool svpShowSuccessInfo:@"拷贝成功"];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[NSString stringWithFormat:@"%@",[response valueForKey:@"message"]]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器出错"];
        }
    }];
}

/** 安全退出 */
- (void) safe_exit{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestJSON:POST urlString:url_external_umount param:@{@"id":@0} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                AlertViewController *temp = [[AlertViewController alloc] init];
                temp.alert_decodeTitle = [@"外接设备已安全拔出" language];
                temp.alertType = alert_decode;
                [self alert:temp];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[NSString stringWithFormat:@"%@",[response valueForKey:@"message"]]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器出错"];
        }
    }];
}

//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//MARK:-----------tabledelegate-------------//

- (void) choose_action:(NSString *)title{
    
    if([title isEqualToString:[@"导入文件" language]]){
        [self.navigationController pushViewController:[ExternalDeviceImportVC new] animated:YES];
    }
    
    if([title isEqualToString:[@"安全拔出" language]]){
        [self safe_exit];
    }
    
    if([title isEqualToString:[@"一键拷贝" language]]){
        [self copy_action];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return self.arrayDirectory.count;
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    temp.backgroundColor = [UIColor hexStringToColor:@"#f0f0f0"];
    return temp;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)return 10;
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ExternalDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.model = self.arrayDirectory[indexPath.row];
        
        /** 文件夹 */
        if([self.arrayFinish containsObject:cell.model]){
            cell.btnSelected.selected = YES;
        }else{
            cell.btnSelected.selected = NO;
        }
        
        cell.callback = ^(BOOL select,ExternalModel *model) {
            if(select){
                [self.arrayFinish addObject:model];
            }else{
                [self.arrayFinish addObject:model];
            }
        };
        return cell;
    }else{
        ExternalDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.model = self.arrayData[indexPath.row];
        
        /** 文件 */
        if([self.arrayFinish containsObject:cell.model]){
            cell.btnSelected.selected = YES;
        }else{
            cell.btnSelected.selected = NO;
        }
        
        cell.callback = ^(BOOL select,ExternalModel *model) {
            if(select){
                [self.arrayFinish addObject:model];
            }else{
                [self.arrayFinish addObject:model];
            }
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ExteralFileListViewController *vc = [ExteralFileListViewController new];
        vc.model = self.arrayDirectory[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIButton *)btnCopy{
    if(!_btnCopy){
        _btnCopy = [self.view buttonWithTitle:[@"一键拷贝" language] font:16 color:[UIColor whiteColor]];
        _btnCopy.backgroundColor = MainColor;
        _btnCopy.layer.cornerRadius = 25;
        [_btnCopy addTarget:self action:@selector(copy_action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCopy;
}

- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
//        [_arrayData addObjectsFromArray:@[@"图片",@"视频",@"文档",@"音乐"]];
    }
    return _arrayData;
}
- (NSMutableArray *)arrayImg{
    if(!_arrayImg){
        _arrayImg = [NSMutableArray array];
//        [_arrayImg addObjectsFromArray:@[@"图片文件夹",@"视频文件夹",@"文档文件夹",@"音乐文件夹"]];
    }
    return _arrayImg;
}
@end
