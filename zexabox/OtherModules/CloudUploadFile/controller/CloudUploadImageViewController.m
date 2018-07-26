//
//  CloudUploadImageViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/11.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CloudUploadImageViewController.h"
#import "URLRequest.h"
#import <MJRefresh.h>
#import "PngModel.h"
#import "PngCell.h"
#import "PngDiretoryCell.h"
#import "FileListViewController.h"
#import "PngReusableView.h"
@interface CloudUploadImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;

/** 文件数据 */
@property (nonatomic,strong) NSMutableArray *arrayData;
/** 分页 */
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *arrayUpload;
@end

@implementation CloudUploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    /** 网路请求 */
    [self requestData];
}

- (void) setupUI{
    
    self.labelTitle.text = [@"图片" language];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.btnRight setTitle:[@"完成" language] forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrayUpload = [NSMutableArray array];
}

- (void) right_action{
    if(self.arrayUpload.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    if(self.isuploadShare){
        /** 上传到共享空间 */
        [self requestToshare];
    }else{
        /** 上传到云空间 */
        [self upload_Png];
    }
}

- (void) upload_Png{
    if(self.arrayUpload.count == 0){
        if(self.callbackreload) self.callbackreload();
        return;
    }
    [FaceAlertTool svpShowWithState:[NSString stringWithFormat:@"正在上传%ld个文件",self.arrayUpload.count]];
    PngModel *model = self.arrayUpload[0];
    [URLRequest requestJSON:POST urlString:url_cloud_upload param:@{@"id":model.id} finish:^(id response, NSError *error) {
        [self.arrayUpload removeObjectAtIndex:0];
        [self upload_Png];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSLog(@"上传文件到云%@",response);
            }
        }else{
            NSLog(@"上传文件到云出错误了=%@",error);
        }
    }];
}
//MARK:-----------网络请求-------------//


//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PngCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.btnSelect.hidden = YES;
    cell.model = self.arrayData[indexPath.row];
    cell.headImageView.image = [UIImage imageNamed:@"新建文件夹"];
    cell.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-100) / 3.0;
    return CGSizeMake(width, 130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PngCell *cell = (PngCell *)[collectionView cellForItemAtIndexPath:indexPath];
    FileListViewController *vc = [FileListViewController new];
    vc.folderID = [NSString stringWithFormat:@"%@",cell.model.id];
    vc.stringFolderName = cell.model.name;
    vc.isuploadToShare = self.isuploadShare;
    vc.iscloundUpload = self.isuploadToClound;
    vc.isimporttoDevice = self.isimportToDevice;
    
    vc.callbackChooseUploadToCloud = ^(PngModel *model, BOOL isAdd) {
        if(isAdd){
            [self.arrayUpload addObject:model];
        }else{
            [self.arrayUpload removeObject:model];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PngDiretoryCell" bundle:nil] forCellWithReuseIdentifier:@"cell2"];
        [_collectionView registerClass:[PngReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
        
    }
    return _collectionView;
}

- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

@end
