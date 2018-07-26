//
//  CloudFileListViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/24.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CloudFileListViewController.h"
#import "URLRequest.h"
#import "PngCell.h"
#import "ShareCell.h"
#import "CloudUploadImageViewController.h"
#import "CloudUploadVedioViewController.h"
#import "LookFileViewController.h"
#import "LookVideoViewController.h"
#import "VedioCell.h"
@interface CloudFileListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UITableView *tableView;

/** 文件 格式 */
@property (nonatomic,strong) NSString *filetype;
@end

@implementation CloudFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = self.stringFileType;
    NSString *stringType;
    if([self.stringFileType isEqualToString:[@"图片" language]]){
        self.filetype = @"image";
        stringType = @"上传图片";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"切换展示方式" language],[stringType language]];
    }else if ([self.stringFileType isEqualToString:[@"视频" language]]){
        self.filetype = @"video";
        stringType = @"上传视频";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[@"切换展示方式" language],[stringType language]];
        
    }else if ([self.stringFileType isEqualToString:[@"文档" language]]){
        self.filetype = @"text";
        stringType = @"上传文档";
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[stringType language]];
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        
    }else{
        self.filetype = @"audio";
        stringType = @"上传音乐";
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        self.arrayRightMenu = @[[@"按名称排序" language],[@"按上传时间排序" language],[stringType language]];
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
    
    self.is_cloud_space = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:nil];
}

/
//MARK:-----------function-------------//

- (void) choose_action:(NSString *)title{
    [super choose_action:title];
    
    if([title isEqualToString:[@"切换展示方式" language]]){
        self.tableView.hidden = !self.tableView.hidden;
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    
    if([title isEqualToString:[@"上传视频" language]] || [title isEqualToString:[@"上传文档" language]] || [title isEqualToString:[@"上传音乐" language]]){
        CloudUploadVedioViewController *vc = [CloudUploadVedioViewController new];
        vc.filetype = self.filetype;
        vc.isuploadCound = YES;
        vc.callbackreload = ^{
            [self requestData:@"上传成功"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([title isEqualToString:[@"上传图片" language]]){
        CloudUploadImageViewController *vc = [CloudUploadImageViewController new];
        vc.isuploadToClound = YES;
        vc.callbackreload = ^{
            [self requestData:@"上传成功"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([title isEqualToString:[@"按上传时间排序" language]]){
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    
    if([title isEqualToString:[@"按名称排序" language]]){
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
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

- (void)data_refresh{
    [super data_refresh];
    [self.tableView reloadData];
    [self.collectionView reloadData];
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
    
    PngCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.btnSelect.hidden = self.isshow_choose;
    cell.isCloud = YES;
    cell.model = self.arrayData[indexPath.row];
    if([self.filetype isEqualToString:@"video"]){
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"播放视频"]];
        playImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:playImageView];
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(cell.headImageView);
            make.height.with.equalTo(@45);
        }];
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
    PngCell *cell = (PngCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(self.isshow_choose == NO){
        cell.btnSelect.selected = !cell.btnSelect.selected;
        if(cell.btnSelect.selected){
            cell.model.file_type = self.filetype;
            cell.model.isdownloadFromCloud = YES;
            [self.arrayDown addObject:cell.model];
        }else{
            [self.arrayDown removeObject:cell.model];
        }
    }else{
        
//        if([self.filetype isEqualToString:@"video"]){
//            LookVideoViewController *vc = [LookVideoViewController new];
//            vc.iscloud = YES;
//            vc.model = cell.model;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
        LookFileViewController *vc = [LookFileViewController new];
        vc.iscloud = YES;
        cell.model.file_type = self.filetype;
        vc.model = cell.model;
        [self.navigationController pushViewController:vc animated:YES];
//        }
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
    cell.btnSelected.hidden = self.isshow_choose;
    cell.isCloud = YES;
    cell.model = self.arrayData[indexPath.row];
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
//            cell.model.isdownloadFromCloud = YES;
//            vc.model = cell.model;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
        LookFileViewController *vc = [LookFileViewController new];
        cell.model.isdownloadFromCloud = YES;
        cell.model.file_type = self.filetype;
        vc.model = cell.model;
        [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    if(cell.btnSelected.selected){
        cell.model.file_type = self.filetype;
        cell.model.isdownloadFromCloud = YES;
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PngCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(long_click_action:)];
        [_collectionView addGestureRecognizer:gesture];
        
    }
    return _collectionView;
}


@end
