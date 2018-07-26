//
//  SearchViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SearchViewController.h"
#import "ShareCell.h"
#import "ShareModel.h"
#import "URLRequest.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *labelNomore;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *searchType;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellReuseIdentifier:@"tableviewcell"];
    self.labelTitle.text = @" ";
    self.btnLeft.hidden = YES;
    [self.naviView addSubview:self.textField];
    
    [self.btnRight setTitle:[@"取消" language] forState:UIControlStateNormal];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.btnRight);
        make.right.equalTo(self.btnRight.mas_left).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.labelNomore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(64+27));
        make.left.right.equalTo(self.view);
    }];
    
    if([self.searchTitle containsString:[@"图片" language]]){
        self.searchType = @"image";
    }else if([self.searchTitle containsString:[@"文档" language]]){
        self.searchType = @"text";
    }else if([self.searchTitle containsString:[@"音乐" language]]){
        self.searchType = @"audio";
    }else{
        self.searchType = @"video";
    }
    self.page = 1;
    [self addFootRefresh];
}

- (void) right_action{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadMoreData{
    self.page += 1;
    [self requestData: NO];
}

/** 网络请求 */
- (void)requestData:(BOOL) isremove{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    NSString *url;
    if(self.iscloudSearch){
        url = url_cloud_search;
    }else{
        url = url_seach_fileType;
    }
    
    if(self.issharespace){
        url = url_sharespace_search_type;
    }
    
    [URLRequest requestWithMethod:GET urlString:url parameters:@{@"name":self.textField.text,@"filetype":self.searchType,@"page":@(self.page),@"pageSize":@(20)} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        if(response){
            if([response[@"code"] integerValue] == 0){
                if(isremove) [self.arrayData removeAllObjects];
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"][@"files"] model:[ShareModel class]];
                if(array.count < 20){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if(array.count == 0){
                    [FaceAlertTool svpShowInfo:@"没有找到任何数据"];
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

//MARK:-----------textfield delegate-------------//
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(![self.textField.text isEqualToString:@""]){
        [self requestData:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(![self.textField.text isEqualToString:@""]){
        [self requestData:YES];
    }
    return YES;
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
    cell.model = self.arrayData[indexPath.row];
    if([self.searchType isEqualToString:@"text"]){
        cell.headImageView.image = [UIImage imageNamed:@"word"];
    }
    if([self.searchType isEqualToString:@"audio"]){
        cell.headImageView.image = [UIImage imageNamed:@"music"];
    }
    if([self.searchType isEqualToString:@"video"]){
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"播放"]];
        playImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:playImageView];
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(cell.headImageView);
            make.height.with.equalTo(@23);
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = self.searchTitle;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.layer.borderWidth = 0.7;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.borderColor = ZLRGBAColor(221, 221, 221, 1).CGColor;
        _textField.delegate = self;
        UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索(1)"]];
        temp.frame = CGRectMake(0, 0, 30, 15);
        temp.contentMode = UIViewContentModeScaleAspectFit;
        _textField.leftView = temp;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UILabel *)labelNomore{
    if(!_labelNomore){
        _labelNomore = [self.view labelWithTitle:[@"没有更多结果了" language] font:18 color:MainTextColor];
        _labelNomore.textAlignment =  NSTextAlignmentCenter;
        _labelNomore.hidden = YES;
    }
    return _labelNomore;
}

- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

@end
