//
//  SharePersonViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SharePersonViewController.h"
#import "DownGroupView.h"
#import "SharePersonDeviceCell.h"
#import "FriendViewController.h"
#import "URLRequest.h"
#import "SharePersonModel.h"
@interface SharePersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) DownGroupView *groupView;
@property (nonatomic,strong) UIButton *btnSure;//确认邀请
@property (nonatomic,strong) NSMutableArray *arrayData;
@end

@implementation SharePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"删除用户" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self registWithNibName:@"SharePersonDeviceCell" identifier:@"cell"];
    
    self.arrayData = [NSMutableArray array];
    
    [self requestData];
    
}

//- (void) btnSure_action{
//    [self.navigationController pushViewController:[FriendViewController new] animated:YES];
//}



//MARK:-----------tableview delegate-------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.groupView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [temp addSubview:self.btnSure];
    
    [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.equalTo(@60);
        make.right.equalTo(@(-60));
        make.height.equalTo(@50);
    }];
    return temp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SharePersonDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    if([[UserInfoManager manager].aRole isEqualToString:@"1"] && [cell.model.mNumber isEqualToString:[UserInfoManager manager].mobile]){
        cell.btnMain.hidden = YES;
    }else{
        cell.btnMain.hidden = NO;
    }
    cell.callbackdelDevice = ^(SharePersonDeviceCell *cell) {
        [self del_bind_phone:cell];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (DownGroupView *)groupView{
    if(!_groupView){
        _groupView = [[DownGroupView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _groupView.labelName.text = [@"已绑定手机号" language];
        _groupView.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    }
    return _groupView;
}

//- (UIButton *)btnSure{
//    if(!_btnSure){
//        _btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnSure setTitle:@"确认邀请" forState:UIControlStateNormal];
//        _btnSure.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _btnSure.backgroundColor = MainColor;
//        _btnSure.layer.cornerRadius = 25;
//
//        [_btnSure addTarget:self action:@selector(btnSure_action) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnSure;
//}
@end
