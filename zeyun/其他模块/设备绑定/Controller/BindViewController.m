//
//  BindViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BindViewController.h"
#import "BindCell.h"
#import "PromptView.h"
#import "UIViewController+Alert.h"
#import "OtherLinkView.h"
#import "BindNoticeView.h"
#import "JumToWiftViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import "BindModel.h"
#import "ScanViewController.h"
#import "YFKit.h"
@interface BindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) BindNoticeView *bindSuccess;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) OtherLinkView *otherDevice;
@property (nonatomic,strong) BindModel *bingModel;
/** 是否停止搜索 */
@property (nonatomic,assign) BOOL isstop;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.arrayData = [NSMutableArray array];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"设备绑定" language];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self registWithNibName:@"BindCell" identifier:@"cell"];
    
    
    BindNoticeView *notice = [[BindNoticeView alloc] initWithFrame:CGRectZero];
    self.bindSuccess = notice;
    notice.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:notice];
    [notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.bindSuccess.hidden = YES;
     /** 请求可绑定设备 */
    [self requestdata];
    /** 其他方式绑定设备 */
//    [self add_other_device];
    /** 获取已经绑定设备 */
    [self request_bind_device];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if(![[NSString backNetType] isEqualToString:@"wifi"]){
//        [self alert:[JumToWiftViewController new]];
//    }
    if(self.isstop)[self.indicatorView stopAnimating];
}


- (void) add_other_device{
    OtherLinkView *temp = [[OtherLinkView alloc] initWithFrame:CGRectZero];
    temp.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:temp];
    self.otherDevice = temp;
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    temp.callback = ^{
        
        if ([YFKit isCameraDenied]){
            [FaceAlertTool svpShowErrorWithMsg:@"请打开相机访问权限"];
            return;
        }
        
        ScanViewController *vc = [[ScanViewController alloc] init];
        vc.callback = ^(NSString *res) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[res dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if(dic){
                NSLog(@"dic = %@",[dic class]);
                BindModel *model = [[BindModel alloc] init];
                model.mac = dic[@"mac"];
                model.peerid = dic[@"peerId"];
                model.sn = dic[@"sn"];
                [self bind_model:model];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
}

- (void) requestdata{
   
}

/** 获取已经绑定设备 */
- (void) request_bind_device{
   
}

//MARK:-----------连接设备-------------//
- (void) connect_devicecell:(BindCell *)cell{
    
}

- (void) disconnect_device:(BindCell *)cell{
    
}

- (void) bind_model:(BindModel *)model{
    BindNoticeView *temp = [[BindNoticeView alloc] init];
    temp.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.tableView);
    }];
    temp.hidden = YES;
    [URLRequest requestJSON:POST urlString:url_device_bind param:@{@"mac":model.mac,@"sn":model.sn,@"peerid":model.peerid} finish:^(id response, NSError *error) {
        temp.hidden = NO;
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                
            }else{
                temp.imageView.image = [UIImage imageNamed:@"失败"];
                temp.labelTitle.text = [@"绑定失败" language];
            }
        }else{
            temp.imageView.image = [UIImage imageNamed:@"失败"];
            temp.labelTitle.text = [@"请求服务器失败" language];
        }
    }];
}

#pragma tableView--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    temp.backgroundColor = self.tableView.backgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [temp addSubview:label];
    label.text = [@"可用设备" language];
    label.font = [UIFont systemFontOfSize:14];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(temp);
        make.left.equalTo(@15);
    }];
    [temp addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5);
        make.centerY.equalTo(temp);
    }];
    [self.indicatorView startAnimating];
    
    return temp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    cell.labelStatus.text = @"";
    if(self.bingModel){
        cell.labelStatus.text = [@"连接成功" language];
        cell.labelStatus.textColor = MainColor;
        self.isstop = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BindCell *cell = (BindCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([cell.labelStatus.text isEqualToString:[@"连接成功" language]]){
        if(![[UserInfoManager manager].aRole isEqualToString:@"1"]){
            [FaceAlertTool createSelectAlertWithTitle:@"提示" message:@"确定解绑设备?" sure:^{
                [self disconnect_device:cell];
            }];
        }
        return;
    }
    cell.labelStatus.textColor = [UIColor hexStringToColor:@"#0bcb0c"];
    cell.labelStatus.text = [@"连接中..." language];
    [self connect_devicecell:cell];
}
#pragma mark Getter
- (UIActivityIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    }
    return _indicatorView;
}
@end
