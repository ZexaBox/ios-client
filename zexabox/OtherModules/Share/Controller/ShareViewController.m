//
//  ShareViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareDefaultCell.h"
#import "ShareCell.h"
#import "UploadViewController.h"
#import "ShareTabView.h"
#import "AlertViewController.h"
#import "NSString+iOSVersion.h"
#import "CloudShareViewController.h"
#import "ShareFileListViewController.h"
@interface ShareViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayImg;

/** 设置新建文件夹的名称 */
@property (nonatomic,strong) UITextField *textField;
//@property (nonatomic,strong) ShareTabView *tab;
@property (nonatomic,strong) UploadViewController *uploadVC;
@property (nonatomic,assign) BOOL isshow_choose;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    * 添加长按手势
//    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
//    [self.tableView addGestureRecognizer:gesture];
    
    self.labelTitle.text = [@"共享" language];
    
    [self registWithNibName:@"ShareDefaultCell" identifier:@"cell"];
    
    
//    self.tab = [[ShareTabView alloc] initWithFrame:CGRectZero];
//    self.tab.hidden = YES;
//    __weak typeof(self) weakSelf = self;
//    self.tab.callback = ^(CommentBtn *btn) {
//        [weakSelf tab_action:btn];
//    };
//    self.isshow_choose = YES;
//    [self.view addSubview:self.tab];
    
    
    /** 适配iphoneX */
//    CGFloat tab_height = 49;
//    if([[NSString GetCurrentDeviceModel] isEqualToString:@"iPhone X"]) tab_height = 69;
//    [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(@(tab_height));
//    }];
}



////MARK:-----------tab action-------------//
//- (void) tab_action:(CommentBtn *)sender{
//
//    AlertViewController *vc = [AlertViewController new];
//    if([sender.labelName.text isEqualToString:[@"下载" language]]){
//        vc.alertType = alert_decode;
//    }
//    if([sender.labelName.text isEqualToString:[@"备份" language]]){
//        vc.alertType = alert_share_backup;
//    }
//    if([sender.labelName.text isEqualToString:[@"分享" language]]){
//        CloudShareViewController *vc = [CloudShareViewController new];
//        [self alert:vc];
//        return;
//    }
//
//    if([sender.labelName.text isEqualToString:[@"删除" language]]){
//        vc.alertType = search_device;
//        vc.hiddenImage = YES;
//        vc.stringTitle = [@"温馨提示" language];
//        vc.desc = [@"确定删除共享文件？" language];
//        vc.rightTitle = [@"删除" language];
//        vc.leftTitle = [@"取消" language];
//    }
//
//    [self alert:vc];
//}

/** 新建文件 */
- (void) right_action:(UIButton *)button{
    
    /** 如果点击添加文件夹，没有输入名称又再点击添加文件夹 */
    if([self.textField.text isEqualToString:@""] && [self.arrayData[0] isEqualToString:@""]){
        self.arrayData[0] = [NSString stringWithFormat:@"新建文件夹%ld",self.arrayData.count - 4];
    }
    
    UploadViewController *vc = [UploadViewController new];
    vc.view.frame = CGRectMake(0, 0, 151, 47);
    vc.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    vc.preferredContentSize = vc.view.frame.size;//设置弹出视图大小必须好推送类型相同
    UIPopoverPresentationController *pover = vc.popoverPresentationController;
    pover.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    [pover setSourceRect:vc.view.bounds];//弹出视图显示位置
    [pover setSourceView:button];//设置目标视图，这两个是必须设置的。
    pover.delegate = self;
    self.uploadVC = vc;
    vc.callback = ^(NSString *title, NSInteger row) {
        [self newfile_action];
    };
    
    [self presentViewController:vc animated:YES completion:^{
        vc.arrayImg = @[@"上传文件夹"];
        vc.arrayData = @[[@"新建文件夹" language]];
    }];//弹出视图
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.uploadVC dismissViewControllerAnimated:NO completion:nil];
}

//MARK:-----------新建文件夹-------------//
- (void) newfile_action{
    [self.arrayData insertObject:@"" atIndex:0];
    [self.arrayImg insertObject:[@"新建文件夹" language] atIndex:0];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
}

////MARK:-----------显示或者隐藏tab-------------//
//- (void) long_click_action:(UILongPressGestureRecognizer *)sender{
//    if(sender.state == UIGestureRecognizerStateBegan){
//        self.isshow_choose = !self.isshow_choose;
//        self.tab.hidden = self.isshow_choose;
//        self.isshow_choose ? [self remove_tab] : [self add_tabView];
//        [self.tableView reloadData];
//    }
//}
//- (void) add_tabView{
//
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.tab.mas_top);
//    }];
//}
//
///** 移除tab视图 */
//- (void) remove_tab{
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviView.mas_bottom);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//}

//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//MARK:-----------uitextfield delegate-------------//
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.textField.text isEqualToString:@""]){
        self.arrayData[0] = [NSString stringWithFormat:@"新建文件夹%ld",self.arrayData.count - 4];
    }else{
        self.arrayData[0] = textField.text;
    }
    self.textField.text = @"";
    [self.textField removeFromSuperview];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
}
#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *temp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        temp.backgroundColor = ZLRGBAColor(239, 239, 239, 1);
        UILabel *label = [temp labelWithTitle:[@"共享文件夹" language] font:14 color:[UIColor hexStringToColor:@"#383c3f"]];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.centerY.equalTo(temp);
        }];
        return temp;
    }else{
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11)];
        temp.backgroundColor =  ZLRGBAColor(239, 239, 239, 1);
        return temp;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 40;
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareFileListViewController *vc = [ShareFileListViewController new];
    vc.stringFileType = self.arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark tableViewGetter
- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
        [_arrayData addObjectsFromArray:@[[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language]]];
    }
    return _arrayData;
}
- (NSMutableArray *)arrayImg{
    if(!_arrayImg){
        _arrayImg = [NSMutableArray array];
        [_arrayImg addObjectsFromArray:@[@"图片文件夹",@"视频文件夹",@"文档文件夹",@"音乐文件夹"]];
    }
    return _arrayImg;
}
- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.placeholder = [@"请输入文件名" language];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.layer.borderWidth = 0.7;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.borderColor = ZLRGBAColor(221, 221, 221, 1).CGColor;
        _textField.delegate = self;
    }
    return _textField;
}
@end
