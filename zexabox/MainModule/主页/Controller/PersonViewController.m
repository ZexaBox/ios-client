//
//  PersonViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonTableViewCell.h"
#import "PersonInfoHeadCell.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *arrayImg;
@property (nonatomic,strong) NSArray *arryTitle;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 设置UI */
    [self setupUI];
}

/** 设置UI */
- (void) setupUI{
    
    
    if([[UserInfoManager manager].aRole isEqualToString:@"1"]){
        self.arrayImg = @[@"",@"个人资料",@"积分管理",@"账号管理",@"外接设备",@"传输列表",@"回收站",@"设置"];
        self.arryTitle = @[@"",[@"个人资料" language],[@"积分管理" language],[@"成员管理" language],[@"设备管理" language],[@"传输列表" language],[@"回收站" language],[@"设置" language]];
    }else{
        self.arrayImg = @[@"",@"个人资料",@"积分管理",@"外接设备",@"传输列表",@"回收站",@"设置"];
        self.arryTitle = @[@"",[@"个人资料" language],[@"积分管理" language],[@"设备管理" language],[@"传输列表" language],[@"回收站" language],[@"设置" language]];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT);
    } completion:nil];
    [self.tableView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(-(SCREEN_WIDTH * 0.7), 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayImg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) return 210;
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        PersonInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelName.text = [UserInfoManager manager].mobile;
        NSURL *avatar = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageURL,[UserInfoManager manager].avatar]];
        [cell.headImageView sd_setImageWithURL:avatar placeholderImage:[UIImage imageNamed:@"个人中心头像"]];
        return cell;
    }
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    cell.labelTitle.text = self.arryTitle[indexPath.row];
    cell.MyImageView.image = [UIImage imageNamed:self.arrayImg[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.callback){
        self.callback(self.arryTitle[indexPath.row]);
    }
}
#pragma mark tableViewGetter
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-(SCREEN_WIDTH * 0.7), 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"PersonHeadCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
