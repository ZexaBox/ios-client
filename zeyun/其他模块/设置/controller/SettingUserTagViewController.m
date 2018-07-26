//
//  SettingUserTagViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingUserTagViewController.h"
#import "SettingBingMobileCell.h"
#import "ChooseTagColorViewController.h"
#import "UIViewController+Alert.h"
#import "URLRequest.h"
#import "SharePersonModel.h"
#import "TagModel.h"
@interface SettingUserTagViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *groupView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSArray *arrayColor;
@property (nonatomic,strong) NSMutableArray *arrayTagModel;
@end

@implementation SettingUserTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"设置用户标识" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [self registWithNibName:@"SettingBingMobileCell" identifier:@"cell"];
    self.arrayData = [NSMutableArray array];
    self.arrayColor = @[[UIColor hexStringToColor:@"#f64b41"],[UIColor hexStringToColor:@"#0f97f2"],[UIColor hexStringToColor:@"#f7c536"],[UIColor hexStringToColor:@"#9b78f0"],[UIColor hexStringToColor:@"#fb9797"],[UIColor hexStringToColor:@"#15d878"]];
    self.arrayTagModel = [NSMutableArray array];
    
    /**  请求用户数据 */
    [self requestData];
    /** 请求用户标示列表 */
    [self requestTag];
}

- (void) requestData{
    [URLRequest requestWithMethod:GET urlString:url_member_list parameters:nil finish:^(id response, NSError *error) {
        if(response){
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[SharePersonModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

/** 获取标示 */
- (void) requestTag{
    [URLRequest requestWithMethod:GET urlString:url_user_tag_list parameters:nil finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[TagModel class]];
                [self.arrayTagModel addObjectsFromArray:array];
            }
        }
    }];
}

/** 用户绑定标签 */
- (void) requestBindTag:(TagModel *)model idx:(SharePersonModel *)personModel{
    [URLRequest requestJSON:POST urlString:url_user_tag_bind param:@{@"tag_id":@(model.id),@"pre_tag_id":@(personModel.tag_id),@"account_id":personModel.account_id} finish:^(id response, NSError *error) {
        NSLog(@"修改用户标示=%@,error = %@",response,error);
        [self requestData];
    }];
}

//MARK:-----------设置标示-------------//
- (void) setUserTagRequest:(SettingBingMobileCell *)current{
    ChooseTagColorViewController *vc = [ChooseTagColorViewController new];
    vc.callback = ^(UIColor *color,NSInteger idx) {
        if(self.arrayTagModel.count == 0){
            [FaceAlertTool svpShowErrorWithMsg:@"未获取到标识数据，请退出重试"];
            return;
        }
        TagModel *model = self.arrayTagModel[idx];
        if(model.id == current.model.tag_id){
            return;
        }
        if(idx < self.arrayTagModel.count){
            [self requestBindTag:model idx:current.model];
        }else{
            NSLog(@"没有获取到数据tag");
        }
    };
    [self alert:vc];
}

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
    SettingBingMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    if(cell.model.tag_id != 0){
        UIColor *temp = self.arrayColor[cell.model.tag_id - 1];
        cell.shaplayer.fillColor = temp.CGColor;
    }
    __weak typeof(self) weakself = self;
    cell.callback = ^(SettingBingMobileCell *current) {
        [weakself setUserTagRequest:current];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UIView *)groupView{
    if(!_groupView){
        _groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UILabel *label = [_groupView labelWithTitle:[@"已绑定手机号" language] font:14 color:MainTextColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.groupView);
            make.left.equalTo(@15);
        }];
    }
    return _groupView;
}

@end
