//
//  RecycleViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "RecycleViewController.h"
#import "DownGroupView.h"
#import "RecycleCell.h"
#import "URLRequest.h"
#import "RecycleModel.h"
#import "PngTableViewController.h"
@interface RecycleViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (nonatomic,strong) DownGroupView *groupView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayDel;
@property (nonatomic,strong) PngTableViewController *alertVc;
@end

@implementation RecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"回收站" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self registWithNibName:@"RecycleCell" identifier:@"cell"];

    self.arrayData = [NSMutableArray array];
    self.arrayDel = [NSMutableArray array];
    
    [self.btnRight setImage:[UIImage imageNamed:@"更多_填充"] forState:UIControlStateNormal];
    self.btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.btnRight addTarget:self action:@selector(right_more_action:) forControlEvents:UIControlEventTouchUpInside];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.alertVc dismissViewControllerAnimated:NO completion:nil];
}

//MARK:-----------action-------------//
- (void)right_more_action:(UIButton *)sender{
    PngTableViewController *vc = [PngTableViewController new];
    self.alertVc = vc;
    vc.view.frame = CGRectMake(0, 0, 151, 80);
    vc.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    vc.preferredContentSize = vc.view.bounds.size;//设置弹出视图大小必须好推送类型相同
    UIPopoverPresentationController *pover = vc.popoverPresentationController;
    pover.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sender];
    [pover setSourceView:sender];//设置目标视图，这两个是必须设置的。
    pover.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        vc.arraData = @[[@"清空" language],[@"撤回" language]];
    }];
    
    vc.callback = ^(NSString *title) {
        [self choose_action:title];
    };
}

- (void) choose_action:(NSString *)title{
    if(self.arrayDel.count == 0) {
        [FaceAlertTool svpShowErrorWithMsg:@"请选择文件"];
        return;
    }
    if([title isEqualToString:[@"清空" language]]){
        [FaceAlertTool createSelectAlertWithTitle:@"提示" message:@"确认要永久删除文件吗？" inViewController:self sure:^{
            [FaceAlertTool svpShowWithState:@"正在删除..."];
            [self recycle_del];
        }];
    }
    
    if([title isEqualToString:[@"撤回" language]]){
        [FaceAlertTool createSelectAlertWithTitle:@"提示" message:@"确认要撤回文件吗？" inViewController:self sure:^{
            [FaceAlertTool svpShowWithState:@"正在撤回..."];
            [self recycle_restore];
        }];
    }
}

- (void)recycle_restore{
    if(self.arrayDel.count == 0){
        [FaceAlertTool svpShowSuccessInfo:@"清除成功"];
        [self requestData];
        return;
    }
    RecycleModel *model = self.arrayDel[0];
    
    [URLRequest requestJSON:POST urlString:url_recycle_restore param:@{@"file_id":model.id} finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                
            }
        }else{
            NSLog(@"error = %@",error);
        }
        [self.arrayDel removeObjectAtIndex:0];
        [self recycle_restore];
    }];
}

//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//MARK:-----------action-------------//
- (void) right_action{
    
}

/** 删除回收站文件 */
- (void) recycle_del{
    if(self.arrayDel.count == 0){
        [FaceAlertTool svpShowSuccessInfo:@"清除成功"];
        [self requestData];
        return;
    }
    
    RecycleModel *model = self.arrayDel[0];
    
    [URLRequest requestJSON:POST urlString:url_recycle_delete param:@{@"file_id":model.id} finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSLog(@"删除文件成功");
            }
        }else{
            NSLog(@"error = %@",error);
        }
        [self.arrayDel removeObjectAtIndex:0];
        [self recycle_del];
    }];
    
}

- (void) requestData{


//MARK:-----------tableview delegate-------------//
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
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecycleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    if([self.arrayDel containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecycleCell *cell = (RecycleCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    if(cell.btnSelected.selected){
        [self.arrayDel addObject:cell.model];
    }else{
        [self.arrayDel removeObject:cell.model];
    }
}

- (DownGroupView *)groupView{
    if(!_groupView){
        _groupView = [[DownGroupView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _groupView.labelName.text = [@"回收站文件30天后会自动清除" language];
        _groupView.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    }
    return _groupView;
}

@end
