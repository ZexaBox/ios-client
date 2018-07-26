//
//  SettingViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingSwitchCell.h"
#import "SettingCell.h"
#import "NSString+CheckString.h"
#import "SettingSizeViewController.h"
#import "AboutMeViewController.h"
#import "SettingUpdateViewController.h"
#import "AlertViewController.h"
#import "ExitViewController.h"
#import "SettingUserTagViewController.h"
#import "ModPwdViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *arrayData;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[UserInfoManager manager].aRole isEqualToString:@"1"]){
        self.arrayData = @[@[[@"仅wifi环境上传/下载" language]]
                           ,@[[@"设置共享空间大小" language],[@"修改密码" language],[@"关于我们" language]]
                           ,@[[@"退出账号" language]]];
    }else{
        self.arrayData = @[@[[@"仅wifi环境上传/下载" language]]
                           ,@[[@"修改密码" language],[@"关于我们" language]]
                           ,@[[@"退出账号" language]]];
    }
    
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"设置" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registWithNibName:@"SettingSwitchCell" identifier:@"cell"];
    [self registWithNibName:@"SettingCell" identifier:@"cell2"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.arrayData[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /** 第一次取到的值为NO，但是默认为仅在wifi下载、上传，所以这里取反 */
        cell.wift_switch.on = ![[[NSUserDefaults standardUserDefaults] valueForKey:WIFI_DOWNLOAD_UPLOAD] boolValue];
        return cell;
    }
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    cell.labeltitle.text = self.arrayData[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.arrayData[indexPath.section][indexPath.row];
    if([title isEqualToString:[@"设置共享空间大小" language]]){
        [self.navigationController pushViewController:[SettingSizeViewController new] animated:YES];
    }
    
    if([title isEqualToString:[@"关于我们" language]]){
        [self.navigationController pushViewController:[AboutMeViewController new] animated:YES];
    }
    
    if([title isEqualToString:@"检查新版本"]){
        [self alert:[SettingUpdateViewController new]];
    }
    
    if([title isEqualToString:[@"退出账号" language]]){
        [self alert:[ExitViewController new]];
    }
    
    if([title isEqualToString:[@"修改密码" language]]){
        [self.navigationController pushViewController:[ModPwdViewController new] animated:YES];
    }
}

@end
