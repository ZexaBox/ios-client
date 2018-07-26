//
//  PngViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngViewController.h"
#import "PngCell.h"
#import "PngReusableView.h"
#import "PngTableViewController.h"
#import "ShareCell.h"
#import "ShareTabView.h"
#import "AlertViewController.h"
#import "UIViewController+Alert.h"
#import "PngFileDateViewController.h"
#import "PngCopyViewController.h"
#import "SearchViewController.h"
#import "NSString+iOSVersion.h"
#import "URLRequest.h"
#import "PngDiretoryCell.h"
#import "PngModel.h"
#import "FileListViewController.h"
@interface PngViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
/** 分页 */
@property (nonatomic,assign) NSInteger page;

/** 新增文件夹 */
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSString *fileName;
@end

@implementation PngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
    /** 网路请求 */
    [self requestData:nil issuccess:nil];
    
}

- (void) setupUI{
    self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"新增文件夹" language]];
    
    self.labelTitle.text = [@"图片" language];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

//MARK:-----------网络请求-------------//
/** 网络请求 */
- (void)requestData:(NSString *)message issuccess:(BOOL) issuccess{
    self.isshow_choose = YES;
    self.isshow_choose ? [self remove_tab] : [self add_tabView];
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_nas_images parameters:@{@"dir_id":@0} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(message){
            if(issuccess){
                [FaceAlertTool svpShowSuccessInfo:message];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:message];
            }
        }
        if(response){
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[PngModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:array];
                [self.collectionView reloadData];
                __weak typeof(self) weakSelf = self;
                
                //全选按钮选中传值
                self.sBlock = ^(BOOL allSelect) {
                    if (allSelect) {
                        [weakSelf.arrayDown addObjectsFromArray:array];
                    }else{
                        [weakSelf.arrayDown removeAllObjects];
                    }
                    [weakSelf.collectionView reloadData];

                };

            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

//MARK:-----------新建文件夹-------------//
- (void) requestCreateFolder{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestJSON:POST urlString:url_folder_create param:@{@"name":self.fileName} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([response[@"code"] integerValue] == 0){
                [self requestData:@"创建成功" issuccess:YES];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
                [self.collectionView reloadData];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

/** 覆盖删除文件的方法，因为删除文件的接口和删除文件夹的接口不一样 */
- (void)del_file{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    if(self.arrayDown.count == 0){
        [self requestData:@"删除成功" issuccess:YES];
        return;
    }
    PngModel *model = self.arrayDown[0];
    [URLRequest requestJSON:POST urlString:url_folder_delete param:@{@"dirid":model.id} finish:^(id response, NSError *error) {
        if(response){
            if([response[@"code"] integerValue] == 0){
                
            }
        }
        [self.arrayDown removeObjectAtIndex:0];
        [self del_file];
    }];
}

- (void) choose_action:(NSString *)title{
    [super choose_action:title];
    if([title isEqualToString:[@"新增文件夹" language]]){
        [self.arrayData addObject:@""];
        [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
    }
}

- (void) data_refresh{
    [super data_refresh];
    [self.collectionView reloadData];
}

- (void) long_click_action:(UILongPressGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        self.isshow_choose = !self.isshow_choose;

        self.tab.hidden = self.isshow_choose;
        self.navSelectView.hidden = self.isshow_choose;
        self.isshow_choose ? [self remove_tab] : [self add_tabView];
        [self.collectionView reloadData];
        
    }
}

- (void) add_tabView{
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tab.mas_top);
    }];
}

/** 移除tab视图 */
- (void) remove_tab{
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}
//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//MARK:-----------textfile delegate-------------//
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.textField removeFromSuperview];
    [self.arrayData removeObject:@""];
    if(![self.textField.text isEqualToString:@""]){
        self.fileName = self.textField.text;
    }else{
        [self.collectionView reloadData];
        return;
    }
    self.textField.text = @"";
    
    [self requestCreateFolder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField removeFromSuperview];
    [self.arrayData removeObject:@""];
    if(![self.textField.text isEqualToString:@""]){
        self.fileName = self.textField.text;
    }else{
        [self.collectionView reloadData];
        return YES;
    }
    self.textField.text = @"";
    
    [self requestCreateFolder];
    return YES;
}

//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PngCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PngModel *model = self.arrayData[indexPath.row];
    
    if([model isKindOfClass:[NSString class]]){
        cell.labelName.text = @"";
    }else{
        cell.model = model;
    }
    cell.headImageView.image = [UIImage imageNamed:@"新建文件夹"];
    cell.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    if([cell.labelName.text isEqualToString:@""]){
        [cell.contentView addSubview:self.textField];
        [self.textField becomeFirstResponder];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.labelName);
            make.centerY.equalTo(cell.labelName);
            make.right.equalTo(@(-10));
            make.height.equalTo(@31);
        }];
    }
    
    
    if([cell.model.name isEqualToString:@"我的相册"] || [cell.model.name isEqualToString:@"最近上传"]){
        cell.btnSelect.hidden = YES;
    }else{
        cell.btnSelect.hidden = self.isshow_choose;
    }
    
    /** 判断是否选择了这个 */
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelect.selected = YES;
    }else{
        cell.btnSelect.selected = NO;
    }

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-100) / 3.0;
    return CGSizeMake(width, 130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PngCell *cell = (PngCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(self.isshow_choose == NO){
        if([cell.model.name isEqualToString:@"我的相册"] || [cell.model.name isEqualToString:@"最近上传"]){
            return;
        }
 
        cell.btnSelect.selected = !cell.btnSelect.selected;
        if(cell.btnSelect.selected){
            cell.model.file_type = @"image";
            [self.arrayDown addObject:cell.model];
        }else{
            [self.arrayDown removeObject:cell.model];
        }
    }else{
        FileListViewController *vc = [FileListViewController new];
        vc.folderID = [NSString stringWithFormat:@"%@",cell.model.id];
        vc.stringFolderName = cell.model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark tableViewGetter
//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-70) / 3.0;
        _layout.itemSize = CGSizeMake(width, 130);
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(10,15,0,15);
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PngCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_collectionView addGestureRecognizer:gesture];
        
    }
    return _collectionView;
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.placeholder = [@"请输入文件名" language];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.layer.borderWidth = 0.7;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.borderColor = ZLRGBAColor(221, 221, 221, 1).CGColor;
        _textField.delegate = self;
    }
    return _textField;
}

@end
