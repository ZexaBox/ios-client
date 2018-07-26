//
//  MobileListViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobileListViewController.h"
#import "MobileListTableViewCell.h"
#import "ZLPhotoManager.h"
@interface MobileListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL isopen;
@property (nonatomic,strong) UIButton *btnGroup;
@property (nonatomic,strong) UIView *groupView;
@property (nonatomic,strong) ZLPhotoManager *photoManager;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayShowData;
@property (nonatomic,strong) NSMutableArray *arraySelectData;
@property (nonatomic,strong) NSMutableArray *arrayChooseData;
@end

@implementation MobileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
}

- (void) setupUI{
    
    self.naviView.hidden = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isopen = YES;
    [self registWithNibName:@"MobileListTableViewCell" identifier:@"cell"];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.arrayShowData = [NSMutableArray array];
    
    if([self.stringGroup isEqualToString:@"Camera"]){
        [self.photoManager GetALLVideoUsingPohotKit:^(NSArray *res) {
            [self.arrayData addObjectsFromArray:res];
        }];
    }
    
    self.arraySelectData = [NSMutableArray array];
}

/** action */
- (void) group_click_action:(UIButton *)sender{
    self.isopen = sender.selected;
    sender.selected = !sender.selected;
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
}

#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.isopen ? self.arrayData.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.groupView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MobileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row >= self.arrayShowData.count){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoManager getVideoFaceImage:self.arrayData[indexPath.row] complemtion:^(UIImage *res,NSString *name) {
                cell.headImageView.image = res;
                cell.labelName.text = name;
            }];
        });
    }else{
        NSDictionary *dic = self.arrayShowData[indexPath.row];
        cell.headImageView.image = [[dic allValues] lastObject];
        cell.labelName.text = [[dic allKeys] lastObject];
    }
    if([self.arraySelectData containsObject:@(indexPath.row)]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MobileListTableViewCell *cell = (MobileListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    /** 添加选择的名称作为判断 */
    if(cell.btnSelected.selected){
        /** 判断是否选择中 */
        [self.arraySelectData addObject:@(indexPath.row)];
    }else{
        [self.arraySelectData removeObject:@(indexPath.row)];
    }
    if(self.callback) self.callback(cell.btnSelected.selected,@{cell.labelName.text:self.arrayData[indexPath.row]});
}

#pragma mark tableViewGetter

- (UIButton *)btnGroup{
    if(!_btnGroup){
        
        _btnGroup = [self.view buttonWithTitle:[NSString stringWithFormat:@"    %@",self.stringGroup] font:16 color:MainTextColor];
        [_btnGroup setImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];
        [_btnGroup setImage:[UIImage imageNamed:@"tableview_next"] forState:UIControlStateSelected];
        _btnGroup.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_btnGroup addTarget:self action:@selector(group_click_action:) forControlEvents:UIControlEventTouchUpInside];
        _btnGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _btnGroup;
}
- (UIView *)groupView{
    if(!_groupView){
        _groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _groupView.backgroundColor = [UIColor whiteColor];
        [_groupView addSubview:self.btnGroup];
        [self.btnGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.groupView);
            make.left.equalTo(@15);
            make.right.equalTo(@0);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
        
        [_groupView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.groupView);
            make.height.equalTo(@1);
        }];
    }
    return _groupView;
}


- (ZLPhotoManager *)photoManager{
    if(!_photoManager){
        _photoManager = [[ZLPhotoManager alloc] init];
    }
    return _photoManager;
}

- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
@end
