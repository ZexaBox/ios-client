//
//  MobileBackupViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobileBackupViewController.h"
#import "MobilBackupCell.h"
#import "GetAddressBookArray.h"
#import "URLRequest.h"
#import "ZLPhotoManager.h"
#import "MobileUserReBackupViewController.h"
@interface MobileBackupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *arrayImg;
@property (nonatomic,strong) NSArray *arrayTitle;
@end

@implementation MobileBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"手机备份" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registWithNibName:@"MobilBackupCell" identifier:@"cell"];
    self.arrayImg = @[@"图片",@"视频",@"通讯录"];
    self.arrayTitle = @[[@"图片备份" language],[@"视频备份" language],[@"通讯备份" language]];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) backup_action:(MobilBackupCell *)cell on:(BOOL)on{
    if([cell.labelTitle.text isEqualToString:[@"通讯备份" language]]){
        if(on){
            NSArray *array = [GetAddressBookArray getPhoneAddressBookArray];
            [FaceAlertTool svpShowWithState:@"正在备份通讯录"];
            [URLRequest requestJSON:POST urlString:url_backup_addressbook param:array finish:^(id response, NSError *error) {
                if(response){
                    if([[response valueForKey:@"code"] integerValue] == 0){
                        [FaceAlertTool svpShowSuccessInfo:@"备份成功"];
                        [[NSUserDefaults standardUserDefaults] setValue:@(on) forKey:cell.labelTitle.text];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [FaceAlertTool svpShowErrorWithMsg: [response valueForKey:@"message"]];
                    }
                }else{
                    [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
                }
            }];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:@(on) forKey:cell.labelTitle.text];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if([cell.labelTitle.text isEqualToString:[@"图片备份" language]]){
        NSString *title = cell.labelTitle.text;
        [[NSUserDefaults standardUserDefaults] setValue:@(on) forKey:title];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(on){
            [FaceAlertTool svpShowInfo:@"正在后台备份中"];
        }else{
            [FaceAlertTool svpShowInfo:@"图片备份已取消"];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[[ZLPhotoManager alloc] init] GetALLphotosUsingPohotKit:^(NSArray *res) {
                /** 0 表示默认将图片默认传入到我的相册 */
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_BACKUP_FILE" object:@{@"content":res,@"IS_BACKUP":@(on),@"tag":@"image"}];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }
    
    if([cell.labelTitle.text isEqualToString:[@"视频备份" language]]){
        NSString *title = cell.labelTitle.text;
        [[NSUserDefaults standardUserDefaults] setValue:@(on) forKey:title];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(on){
            [FaceAlertTool svpShowInfo:@"正在后台备份中"];
        }else{
            [FaceAlertTool svpShowInfo:@"视频备份已取消"];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[[ZLPhotoManager alloc] init] GetALLVideoUsingPohotKit:^(NSArray *res) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_BACKUP_FILE" object:@{@"content":res,@"IS_BACKUP":@(on),@"tag":@"video"}];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }
}

//MARK:-----------tableview delegate-------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayImg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MobilBackupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImageview.image = [UIImage imageNamed:self.arrayImg[indexPath.row]];
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    
    BOOL on = [[[NSUserDefaults standardUserDefaults] valueForKey:cell.labelTitle.text] boolValue];
    NSLog(@"%@",@(on));
    [cell.myswitch setOn:on];
    cell.callback = ^(MobilBackupCell *cell, BOOL on) {
        [self backup_action:cell on:on];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [GetAddressBookArray wiriteToAddress:@"1231111111" name:@"annnnn"];
    if([self.arrayTitle[indexPath.row] isEqualToString:[@"通讯备份" language]]){
        MobileUserReBackupViewController *vc = [[MobileUserReBackupViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
