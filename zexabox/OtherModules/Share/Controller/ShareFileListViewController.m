//
//  ShareFileListViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareFileListViewController.h"
#import "URLRequest.h"
#import "ShareCollectionViewCell.h"
#import "ShareCell.h"
#import "PngModel.h"
#import "CloudUploadImageViewController.h"
#import "CloudUploadVedioViewController.h"
#import "LookFileViewController.h"
#import "LookVideoViewController.h"
@interface ShareFileListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *filetype;
@property (nonatomic,strong) NSArray *arrayColor;
@end

@implementation ShareFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = self.stringFileType;

    
    if([self.stringFileType isEqualToString:[@"图片" language]]){
        self.filetype = @"image";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"切换展示方式" language],[@"上传图片" language]];
    }else if ([self.stringFileType isEqualToString:[@"视频" language]]){
        self.filetype = @"video";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"上传视频" language]];
    }else if ([self.stringFileType isEqualToString:[@"文档" language]]){
        self.filetype = @"text";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"上传文档" language]];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }else{
        self.filetype = @"audio";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"上传音乐" language]];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.arrayColor = @[[UIColor hexStringToColor:@"#f64b41"],[UIColor hexStringToColor:@"#0f97f2"],[UIColor hexStringToColor:@"#f7c536"],[UIColor hexStringToColor:@"#9b78f0"],[UIColor hexStringToColor:@"#fb9797"],[UIColor hexStringToColor:@"#15d878"]];
    
    /** 告诉父类这个是共享空间 */
    self.is_share_space = YES;
}

- (void) search_action{
    SearchViewController *search = [SearchViewController new];
    search.searchTitle = [NSString stringWithFormat:@"%@ %@",[@"搜索" language],self.labelTitle.text];
    search.issharespace = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:nil];
}

//MARK:-----------网络请求-------------//
/** 网络请求 */
- (void)requestData:(NSString *)message{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    self.isshow_choose = YES;
    [self remove_tab];
    [URLRequest requestWithMethod:GET urlString:url_sharespace_list parameters:@{@"filetype":self.filetype} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if(message)[FaceAlertTool svpShowSuccessInfo:message];
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[PngModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:array];
                [self.collectionView reloadData];
                [self.tableView reloadData];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
                self.btnRight.hidden = YES;
            }
        }else{
            if([error.localizedDescription containsString:@"403"]){
                self.btnRight.hidden = YES;
            }else{
                [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
            }
        }
    }];
}

/** 删除文件完成之后的回调 */
- (void)del_data_reload{
    [super del_data_reload];
    [self requestData:@"删除成功"];
}

- (void)data_refresh{
    [super data_refresh];
    self.isshow_choose = YES;
    [self.collectionView reloadData];
    [self.tableView reloadData];
}


//MARK:-----------function-------------//

- (void) choose_action:(NSString *)title{
    [super choose_action:title];
    
    if([title isEqualToString:[@"切换展示方式" language]]){
        self.tableView.hidden = !self.tableView.hidden;
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    
    if([title isEqualToString:[@"上传图片" language]]){
        CloudUploadImageViewController *vc = [CloudUploadImageViewController new];
        vc.isuploadShare = YES;
     [self.collectionView reloadData];
    }
    
    if([title isEqualToString:[@"按名称排序" language]]){
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    
}

- (void) long_click_action:(UILongPressGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        /** 如果是上传文件到云，就不要做长按手势处理 */
        self.isshow_choose = !self.isshow_choose;
        self.tab.hidden = self.isshow_choose;
        self.isshow_choose ? [self remove_tab] : [self add_tabView];
        [self.collectionView reloadData];
        [self.tableView reloadData];
    }
}

- (void) add_tabView{
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tab.mas_top);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tab.mas_top);
    }];
}

/** 移除tab视图 */
- (void) remove_tab{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

//MARK:-----------collection delegate-------------//
//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.arrayData[indexPath.row];
    cell.btnSelect.hidden = self.isshow_choose;
    if(cell.model.tag_id != 0){
        UIColor *color = self.arrayColor[cell.model.tag_id - 1];
        cell.shaplayer.fillColor = color.CGColor;
    }
    
    if([self.filetype isEqualToString:@"text"]){
        cell.headImageView.image = [UIImage imageNamed:@"word"];
    }
    
    if([self.filetype isEqualToString:@"audio"]){
        cell.headImageView.image = [UIImage imageNamed:@"music"];
    }
    
    /** 判断是否选择了这个 */
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelect.selected = YES;
    }else{
        cell.btnSelect.selected = NO;
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = (ShareCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnSelect.selected = !cell.btnSelect.selected;
    if(self.isshow_choose){
//        if([self.filetype isEqualToString:@"video"]){
//            LookVideoViewController *vc = [LookVideoViewController new];
//            vc.model = cell.model;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }else{
        LookFileViewController *vc = [LookFileViewController new];
        cell.model.file_type = self.filetype;
        vc.model = cell.model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
//        }
    }
    if(cell.btnSelect.selected){
        cell.model.file_type = self.filetype;
        [self.arrayDown addObject:cell.model];
    }else{
        [self.arrayDown removeObject:cell.model];
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.arrayData[indexPath.row];
    cell.btnSelected.hidden = self.isshow_choose;
    if(cell.model.tag_id != 0){
        UIColor *color = self.arrayColor[cell.model.tag_id - 1];
        cell.shaplayer.fillColor = color.CGColor;
    }
    if([self.filetype isEqualToString:@"text"]){
        cell.headImageView.image = [UIImage imageNamed:@"word"];
    }
    
    if([self.filetype isEqualToString:@"audio"]){
        cell.headImageView.image = [UIImage imageNamed:@"music"];
    }
    /** 判断是否选择了这个 */
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = (ShareCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    if(self.isshow_choose){
//        if([self.filetype isEqualToString:@"video"]){
//            LookVideoViewController *vc = [LookVideoViewController new];
//            vc.model = cell.model;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }else{
        LookFileViewController *vc = [LookFileViewController new];
        cell.model.file_type = self.filetype;
        vc.model = cell.model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
//        }
    }
    /** 选择文件做其他处理 */
    if(cell.btnSelected.selected){
        cell.model.file_type = self.filetype;
        [self.arrayDown addObject:cell.model];
    }else{
        [self.arrayDown removeObject:cell.model];
    }
}

//MARK:-----------getter-------------//

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellReuseIdentifier:@"tableviewcell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_tableView addGestureRecognizer:gesture];
    }
    return _tableView;
}

//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-70) / 3.0;
        _layout.itemSize = CGSizeMake(width, 130);
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0,15,0,15);
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
        [_collectionView registerNib:[UINib nibWithNibName:@"ShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_collectionView addGestureRecognizer:gesture];
        
    }
    return _collectionView;
}

@end
