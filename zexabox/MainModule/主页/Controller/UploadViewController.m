//
//  UploadViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UploadViewController.h"
#import "UploadCell.h"
@interface UploadViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
//    [self setupData];
}

- (void) setupUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registWithNibName:@"UploadCell" identifier:@"cell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    self.tableView.bounces = NO;
    self.naviView.hidden = YES;
}

///** 设置数据 */
//- (void) setupData{
//    self.arrayData = @[[@"上传图片" language],[@"上传视频" language]];
//    self.arrayImg = @[@"上传图片",@"上传视频"];
//}

- (void)setArrayData:(NSArray *)arrayData{
    _arrayData = arrayData;
    [self.tableView reloadData];
}

#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.MyImageView.image = [UIImage imageNamed:self.arrayImg[indexPath.row]];
    cell.labelname.text = self.arrayData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 线程冲突 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if(self.callback){
                self.callback(self.arrayData[indexPath.row], indexPath.row);
            }
        }];
    });
}

@end
