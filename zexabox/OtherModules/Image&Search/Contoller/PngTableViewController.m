//
//  PngTableViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngTableViewController.h"

@interface PngTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PngTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.arraData == nil) self.arraData = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"新增文件夹" language]];
//    self.arrayData = @[@"按名称排序",@"按上传时间排序",@"切换展示方式",@"上传图片"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.naviView.hidden = YES;
    self.tableView.bounces = NO;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setArraData:(NSArray *)arraData{
    _arraData = arraData;
    [self.tableView reloadData];
}

#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.arraData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.callback){
        self.callback(self.arraData[indexPath.row]);
    }
}

@end
