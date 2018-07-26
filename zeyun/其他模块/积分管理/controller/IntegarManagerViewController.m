//
//  IntegarManagerViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "IntegarManagerViewController.h"
#import "IntegerCell.h"
#import "URLRequest.h"
#import "UserIntegerModel.h"
@interface IntegarManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelGroupName;
@property (weak, nonatomic) IBOutlet UILabel *labelInterger;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (weak, nonatomic) IBOutlet UIButton *btnCanUseIntegral;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegral;
@end

@implementation IntegarManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self.btnCanUseIntegral setTitle:[@" 可用积分" language] forState:UIControlStateNormal];
    self.labelIntegral.text = [@"积分变更记录" language];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"积分管理" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self registWithNibName:@"IntegerCell" identifier:@"cell"];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelGroupName.mas_bottom).offset(10);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.arrayData = [NSMutableArray array];
    
    /** 获取总积分 */
    [self requestIntegar];
    /** 获取积分获取列表 */
    [self request_list];
}

- (void) requestIntegar{
    

}

/** 获取积分详细列表 */
- (void) request_list{

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
    IntegerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
