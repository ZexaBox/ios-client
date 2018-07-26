//
//  PersonInfoViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonDetailHeadCell.h"
#import "PersonInfoCell.h"
#import "PersonSexCell.h"
#import "NSDate+TimeInterval.h"
#import "ImagePickerViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import <UIButton+WebCache.h>
@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIView *groupView;
@property (nonatomic,strong) NSArray *arrayData;
@property (nonatomic,strong) NSArray *arrayInfo;

@property (nonatomic,strong) UIDatePicker *picker;
@property (nonatomic,weak) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtBirthday;
/** 是否修改了用户名 */
@property (nonatomic,assign) BOOL ischangeInfo;
/** 是否修改了头像 */
@property (nonatomic,assign) BOOL ischangeHeadImage;
@property (nonatomic,assign) BOOL ischangeSex;
@property (nonatomic,assign) BOOL userSex;
@property (nonatomic,strong) UIImage *headImage;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"个人资料" language];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [self registWithNibName:@"PersonDetailHeadCell" identifier:@"cell"];
    [self registWithNibName:@"PersonInfoCell" identifier:@"cell2"];
    [self registWithNibName:@"PersonSexCell" identifier:@"cell3"];
    
    [self.btnRight setTitle:[@"保存" language] forState:UIControlStateNormal];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrayData = @[[@"用户ID" language],[@"昵称" language],[@"称谓" language],[@"生日" language]];
    self.arrayInfo = @[@"8447466",@"Windir",@"",@""];
    
    [self requestUser];
}

/** 修改用户信息 */
- (void) right_action{

    
}

- (void) save_request{
    if(self.ischangeInfo || self.ischangeHeadImage || self.ischangeSex){
        [FaceAlertTool svpShowWithState:@"请稍后..."];
 
        }];
    }
}

//MARK:-----------action-------------//
- (void) choose_image:(UIButton *)sender{
    ImagePickerViewController *temp = [ImagePickerViewController shareImage];
    [temp alertView:self arraytitle:@[[@"从相册选择" language],[@"拍照" language]]];
    temp.back = ^(UIImage *image) {
        self.ischangeHeadImage = YES;
        self.headImage = image;
        [sender setImage:image forState:UIControlStateNormal];
    };
}

- (void) requestUser{
    [FaceAlertTool svpShowWithState:@"请稍后..."];

        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

//MARK:-----------picker Delegate-------------//
- (void) picker_action:(UIDatePicker *)sender{
    self.txtBirthday.text = [NSDate getDateStrWithDate:sender.date];
}

//MARK:-----------uitextField delegate-------------//
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.ischangeInfo = YES;
    if(textField.tag == 1000){
        textField.text = [NSDate getDateStrWithDate:self.picker.date];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(![string isSpeicalCharact]){
        return NO;
    }
    return YES;
}
- (void) text_value_didChange:(UITextField *)textField{
    if(textField.text.length > 20){
        textField.text = [textField.text substringToIndex:20];
    }
}

//MARK:-----------tableview delegate-------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0;
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1)return self.groupView;
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0) return 160;
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        PersonDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageURL,[UserInfoManager manager].avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"个人中心头像"]];
        cell.callback = ^(UIButton *sender){
            [self choose_image:sender];
        };
        return cell;
    }
    
    if(indexPath.row == 2){
        PersonSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *man = self.arrayInfo[indexPath.row];
        if([man integerValue] == 0){
            cell.btnWoman.selected = YES;
            cell.btnMan.selected = NO;
        }else{
            cell.btnWoman.selected = NO;
            cell.btnMan.selected = YES;
        }
        
        /** 设置用户的性别 */
        cell.callback = ^(BOOL isman) {
            self.ischangeSex = YES;
            self.userSex = isman;
        };
        
        return cell;
    }
    
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelName.text = self.arrayData[indexPath.row];
    cell.txtInfo.text = self.arrayInfo[indexPath.row];
    cell.txtInfo.placeholder = [NSString stringWithFormat:@"请填写%@",self.arrayData[indexPath.row]];
    if([cell.labelName.text isEqualToString:[@"生日" language]]){
        cell.rightImage.hidden = NO;
        self.txtBirthday = cell.txtInfo;
        self.txtBirthday.delegate = self;
        cell.txtInfo.inputView = self.picker;
        cell.txtInfo.tag = 1000;
    }
    
    if([cell.labelName.text isEqualToString:[@"昵称" language]]){
        cell.txtInfo.delegate = self;
        self.txtName = cell.txtInfo;
        cell.txtInfo.tag = 2000;
        [cell.txtInfo addTarget:self action:@selector(text_value_didChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if([cell.labelName.text isEqualToString:[@"用户ID" language]]){
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


//MARK:-----------getter-------------//
- (UIView *)groupView{
    if(!_groupView){
        _groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    return _groupView;
}

- (UIDatePicker *)picker{
    if(!_picker){
        _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _picker.datePickerMode = UIDatePickerModeDate;
        _picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _picker.backgroundColor = [UIColor whiteColor];
        [_picker addTarget:self action:@selector(picker_action:) forControlEvents:UIControlEventValueChanged];
    }
    return _picker;
}
@end
