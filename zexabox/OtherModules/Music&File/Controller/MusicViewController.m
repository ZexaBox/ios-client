//
//  MusicViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MusicViewController.h"
#import "ShareCell.h"
#import "URLRequest.h"
#import "PngModel.h"
#import "LookFileViewController.h"
@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *type;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    if([self.stringName isEqualToString:[@"文档" language]]){
        self.labelTitle.text = self.stringName;
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language]];
        self.type = @"text";
    }else{
        self.labelTitle.text = [@"音乐" language];
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language]];
        self.type = @"audio";
    }
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self requestData:nil];
}

- (void) requestData{
    [self requestData:nil];
}

/** 网络请求 */
- (void)requestData:(NSString *)message{
    self.page += 1;
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_nas_list parameters:@{@"filetype":self.type,@"pageSize":@10,@"page":@(self.page)} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        if(response){
            if(message) {
                [FaceAlertTool svpShowSuccessInfo:message];
                [self.arrayData removeAllObjects];
            }
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[PngModel class]];
                if(array.count < 10){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.arrayData addObjectsFromArray:array];
                [self.tableView reloadData];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (void)del_data_reload{
    [super del_data_reload];
    [self requestData:@"删除成功"];
}
- (void) data_refresh{
    [super data_refresh];
    [self.tableView reloadData];
}

- (void) long_click_action:(UILongPressGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        self.isshow_choose = !self.isshow_choose;
        self.tab.hidden = self.isshow_choose;
        self.isshow_choose ? [self remove_tab] : [self add_tabView];
        [self.tableView reloadData];
    }
}

- (void) add_tabView{
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tab.mas_top);
    }];
}
/** 移除tab视图 */
- (void) remove_tab{
    [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnSelected.hidden = self.isshow_choose;
    cell.model = self.arrayData[indexPath.row];
    if([self.type isEqualToString:@"text"]){
        cell.headImageView.image = [UIImage imageNamed:@"word"];
    }else{
        cell.headImageView.image = [UIImage imageNamed:@"music"];
    }
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = (ShareCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    if(self.isshow_choose){
        LookFileViewController *lookvc = [LookFileViewController new];
        lookvc.model = cell.model;
        [self.navigationController pushViewController:lookvc animated:YES];
        return;
    }
    if(cell.btnSelected.selected){
        [self.arrayDown addObject:cell.model];
    }else{
        [self.arrayDown removeObject:cell.model];
    }
}
#pragma mark tableViewGetter
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellReuseIdentifier:@"tableviewcell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_tableView addGestureRecognizer:gesture];
    }
    return _tableView;
}
@end
