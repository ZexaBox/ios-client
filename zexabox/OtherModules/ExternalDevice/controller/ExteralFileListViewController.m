//
//  ExteralFileListViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/15.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExteralFileListViewController.h"
#import "URLRequest.h"
#import "ExternalModel.h"
#import "ExternalDeviceCell.h"
#import "ExternalDeviceImportVC.h"
#import "UploadViewController.h"
@interface ExteralFileListViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayImg;
@property (nonatomic,strong) NSMutableArray *arrayDirectory;
@property (nonatomic,strong) UploadViewController *alertVC;

@property (nonatomic,strong) NSMutableArray *arrayFinish;
@end

@implementation ExteralFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = self.model.name;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self registWithNibName:@"ExternalDeviceCell" identifier:@"cell"];
    self.arrayDirectory = [NSMutableArray array];
    
    [self.btnRight setImage:[UIImage imageNamed:@"更多_填充"] forState:UIControlStateNormal];
    self.btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.btnRight addTarget:self action:@selector(right_more_action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestData];
    
    self.arrayFinish = [NSMutableArray array];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.alertVC dismissViewControllerAnimated:NO completion:nil];
}

- (void)right_more_action:(UIButton *)sender{
    UploadViewController *vc = [UploadViewController new];
    self.alertVC = vc;
    vc.view.frame = CGRectMake(0, 0, 151, 80);
    vc.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    vc.preferredContentSize = vc.view.frame.size;//设置弹出视图大小必须好推送类型相同
    UIPopoverPresentationController *pover = vc.popoverPresentationController;
    pover.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sender];
    [pover setSourceView:sender];//设置目标视图，这两个是必须设置的。
    pover.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        vc.arrayImg = @[@"导入",@"复制"];
        vc.arrayData = @[[@"导入文件" language],[@"一键拷贝" language],];
    }];
    vc.callback = ^(NSString *title, NSInteger row) {
        [self choose_action:title];
    };
}

//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void) choose_action:(NSString *)title{
    if([title isEqualToString:[@"导入文件" language]]){
        ExternalDeviceImportVC *vc = [ExternalDeviceImportVC new];
        vc.externalModel = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        /** 一键拷贝 */
        [self copy_action];
    }
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

- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_external_list parameters:@{@"path":self.model.path} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[ExternalModel class]];
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
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
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
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ExteralFileListViewController *vc = [ExteralFileListViewController new];
        vc.model = self.arrayDirectory[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

@end
