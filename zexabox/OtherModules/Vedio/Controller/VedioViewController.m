//
//  VedioViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "VedioViewController.h"
#import "VedioCell.h"
#import "URLRequest.h"
#import "PngModel.h"
#import <QBImagePickerController.h>
#import "LookFileViewController.h"
#import "LookVideoViewController.h"
#import "ShareCell.h"
@interface VedioViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,QBImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation VedioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    self.labelTitle.text = [@"视频" language];
    self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"切换展示方式" language],[@"上传视频" language]];
    /** 添加上拉刷新 */
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self requestData:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"UPLOAD_FINISH_NEED_UPLOADDATA" object:nil];
}

- (void)pop_action{
    [super pop_action];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) requestData{
    [self requestData:nil];
}

//MARK:-----------请求数据-------------//
/** 网络请求 */
- (void)requestData:(NSString *)message{
    self.page += 1;
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    self.isshow_choose = YES;
    [self remove_tab];
    [URLRequest requestWithMethod:GET urlString:url_nas_list parameters:@{@"filetype":@"video",@"pageSize":@10,@"page":@(self.page)} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        [self.collectionView.mj_footer endRefreshing];
        if(response){
            if(message)[FaceAlertTool svpShowSuccessInfo:message];
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[PngModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:array];
                if(array.count < 10) [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                [self.collectionView reloadData];
                [self.tableView reloadData];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (void)del_data_reload{
    [super del_data_reload];
    [self requestData:@"删除成功"];
}

- (void)data_refresh{
    [super data_refresh];
    [self.collectionView reloadData];
    [self.tableView reloadData];
}


- (void) long_click_action:(UILongPressGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
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

- (void)choose_action:(NSString *)title{
    [super choose_action: title];
    
    if([title isEqualToString:[@"上传视频" language]]){
        //如果是个人中心上传文件
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.prompt = [@"请选择视频" language];
        imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
    if([title isEqualToString:[@"切换展示方式" language]]){
        self.tableView.hidden = !self.tableView.hidden;
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
}

//MARK:-----------qbimagepicker delegate-------------//
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    /** 视频不需要传入到文件夹下面所以直接给一个video的键 */
    [FaceAlertTool svpShowInfo:@"文件已经添加至上传列表"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHOOSE_IMAGE_FINISH" object:@{@"video":assets}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.btnSelected.hidden = self.isshow_choose;
    cell.model = self.arrayData[indexPath.row];
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    
    /** 判断是否选择了这个 */
    if([self.arrayDown containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell = (VedioCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    PngModel *model = self.arrayData[indexPath.row];
    if(self.isshow_choose){
        LookFileViewController *vc = [LookFileViewController new];
//        LookVideoViewController *vc = [LookVideoViewController new];
        cell.model.file_type = @"video";
        cell.model.isdownloadFromCloud = YES;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if(cell.btnSelected.selected){
        model.file_type = @"video";
        [self.arrayDown addObject:model];
    }else{
        [self.arrayDown removeObject:model];
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
        LookFileViewController *vc = [LookFileViewController new];
//        LookVideoViewController *vc = [LookVideoViewController new];
        cell.model.file_type = @"video";
        vc.model = cell.model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    /** 选择文件做其他处理 */
    if(cell.btnSelected.selected){
        cell.model.file_type = @"video";
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

- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-70) / 3.0;
        _layout.itemSize = CGSizeMake(width, 130);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0,10,0,10);
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
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"VedioCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_collectionView addGestureRecognizer:gesture];
    }
    return _collectionView;
}
@end
