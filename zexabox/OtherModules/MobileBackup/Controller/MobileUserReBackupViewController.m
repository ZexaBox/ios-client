//
//  MobileUserReBackupViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/11.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobileUserReBackupViewController.h"
#import "CommentBtn.h"
#import "GetAddressBookArray.h"
#import "URLRequest.h"
#import "MobileConnectCell.h"
@interface MobileUserReBackupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet CommentBtn *btn_backup;
@property (weak, nonatomic) IBOutlet CommentBtn *btn_re_backup;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayBackupData;
@property (nonatomic,assign) NSInteger num;
@end

@implementation MobileUserReBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"通讯备份" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@80);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MobileConnectCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stackView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    /** setting UI */
    self.btn_backup.labelName.text = [@"备份" language];
    self.btn_backup.labelName.textColor = MainTextColor;
    self.btn_re_backup.labelName.textColor = MainTextColor;
    self.btn_backup.MyImageView.image = [UIImage imageNamed:@"备份"];
    self.btn_re_backup.MyImageView.image =[UIImage  imageNamed:@"备份恢复"];
    self.btn_re_backup.labelName.text = [@"恢复备份" language];
    self.btn_backup.labelName.font = [UIFont systemFontOfSize:15];
    self.btn_re_backup.labelName.font = [UIFont systemFontOfSize:15];
    self.btn_backup.backgroundColor = [UIColor whiteColor];
    self.btn_re_backup.backgroundColor = [UIColor whiteColor];
    self.stackView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayData = [NSMutableArray array];
    NSArray *array = [GetAddressBookArray getPhoneAddressBookArray];
    [self.arrayData addObjectsFromArray:array];
    self.arrayBackupData = [NSMutableArray array];
    [self.tableView reloadData];
    
}

- (IBAction)backup_action:(id)sender {
    NSArray *array = [GetAddressBookArray getPhoneAddressBookArray];
    [FaceAlertTool svpShowWithState:@"正在备份通讯录"];
    [URLRequest requestJSON:POST urlString:url_backup_addressbook param:array finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                [FaceAlertTool svpShowSuccessInfo:@"备份成功"];
                [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"通讯备份"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [FaceAlertTool svpShowErrorWithMsg: [response valueForKey:@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

/** 恢复备份 */
- (IBAction)re_backup_action:(id)sender {
    /** setData */
    [self requestData];
}

- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_backup_addressbook parameters:nil finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                if([response[@"message"] isKindOfClass:[NSArray class]]){
                    [self.arrayBackupData removeAllObjects];
                    [self.arrayBackupData addObjectsFromArray:response[@"message"]];
                    [self back_up];
                }
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (void) back_up{
    if(self.arrayBackupData.count == 0){
        [FaceAlertTool svpShowInfo:@"暂未获取到备份数据"];
        return;
    }
    
    [FaceAlertTool svpShowWithState:@"正在恢复备份..."];
    [self.arrayData removeAllObjects];
    NSArray *array = [GetAddressBookArray getPhoneAddressBookArray];
    [self.arrayData addObjectsFromArray:array];
    [self.arrayBackupData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL iswrite = NO;
        NSString *name1 = [[obj allKeys] lastObject];
        NSDictionary *dic1 = [[obj allValues] lastObject];
        NSString *phone1 = dic1[@"mNumber"];
        NSString *identifier1 = dic1[@"nType"];
        [self.arrayData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name2 = [[obj2 allKeys] lastObject];
            NSDictionary *dic2 = [[obj2 allValues] lastObject];
            NSString *phone2 = dic2[@"mNUmber"];
            NSString *identifier2 = dic2[@"nType"];
            
            if([name1 isEqualToString:name2] && [phone1 isEqualToString:phone2] && [identifier1 isEqualToString:identifier2]){
                iswrite = YES;
                *stop = YES;
            }else{
                iswrite = NO;
            }
        }];
        if(iswrite == NO){
            self.num += 1;
            [GetAddressBookArray wiriteToAddress:obj];
        }
    }];
    [FaceAlertTool svpShowSuccessInfo:[NSString stringWithFormat:@"%ld个联系人恢复备份成功",self.num]];
    self.num = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

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
    MobileConnectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dic = self.arrayData[indexPath.row];
    cell.labelName.text = [[dic allKeys] lastObject];
    NSDictionary *dic2 = [[dic allValues] lastObject];
    cell.labelPhone.text = dic2[@"mNUmber"];
    return cell;
}




@end
