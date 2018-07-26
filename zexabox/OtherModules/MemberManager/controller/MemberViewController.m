//
//  MemberViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/8.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MemberViewController.h"
#import "DownloadListViewController.h"
#import "FriendViewController.h"
#import "SharePersonViewController.h"
#import "SettingUserTagViewController.h"
@interface MemberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *arrayData;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"成员管理" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.arrayData = @[[@"删除用户" language],[@"邀请好友" language],[@"设置用户标识" language]];
}

//MARK:-----------action-------------//
- (void) right_action{
    
}

//MARK:-----------tableview delegate-------------//
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.arrayData[indexPath.row];
    if([title isEqualToString:[@"删除用户" language]]){
        [self.navigationController pushViewController:[SharePersonViewController new] animated:YES];
    }
    
    if([title isEqualToString:[@"邀请好友" language]]){
        [self.navigationController pushViewController:[FriendViewController new] animated:YES];
    }
    
    if([title isEqualToString:[@"设置用户标识" language]]){
        [self.navigationController pushViewController:[SettingUserTagViewController new] animated:YES];
    }
}

@end
