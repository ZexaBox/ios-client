//
//  MobileImageViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobileImageViewController.h"
#import "PngCell.h"
#import "MobilImageReusableView.h"
#import "ZLPhotoManager.h"
@interface MobileImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) MobilImageReusableView *head;

@property (nonatomic,assign) BOOL isopen;
@property(nonatomic,strong)NSMutableArray <PHAsset*> *assets;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) PHCachingImageManager *imageManager;
@property (nonatomic,strong) NSMutableArray *arrayFinishData;
@property (nonatomic,strong) ZLPhotoManager *photoManager;

@property (nonatomic,strong) NSMutableArray *arraySelectData;
/** 缓存 */
@property (nonatomic,strong) NSMutableArray *arrayCache;
@end

@implementation MobileImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.isopen = YES;
    self.arrayData = [NSMutableArray array];
    /** 获取相册数据 */
    [self.photoManager GetALLphotosUsingPohotKit:^(NSArray *res) {
        [self.arrayData addObjectsFromArray:res];
        [self.collectionView reloadData];
    }];
    
    self.arraySelectData = [NSMutableArray array];
    self.arrayCache = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}


//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        
        self.head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        self.head.callback = ^(BOOL isopen) {
            weakself.isopen = isopen;
            [weakself.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:1]];
        };
        return self.head;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0) return CGSizeMake(SCREEN_WIDTH, 40);
    return CGSizeMake(0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0) return 0;
    return self.isopen ? self.arrayData.count : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PngCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.btnSelect.hidden = NO;
    [self.photoManager getImageForomPhAsset:self.arrayData[indexPath.row] completion:^(NSString *name, UIImage *res) {
        cell.labelName.text = name;
        cell.headImageView.image = res;
        [self.arrayCache addObject:name];
    }];
    if([self.arraySelectData containsObject:@(indexPath.row)]){
        cell.btnSelect.selected = YES;
    }else{
        cell.btnSelect.selected = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PngCell *cell = (PngCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnSelect.selected = !cell.btnSelect.selected;
    if(cell.btnSelect.selected){
        [self.arraySelectData addObject:@(indexPath.row)];
    }else{
        [self.arraySelectData removeObject:@(indexPath.row)];
    }
    
//    [self.photoManager getImageFromPHAsset:self.arrayData[indexPath.row] completion:^(NSString *name, UIImage *res, NSData *data) {
//        if(self.callback) self.callback(cell.btnSelect.selected,@{name:data});
//    }];
    if(self.callback) self.callback(cell.btnSelect.selected,@{cell.labelName.text:self.arrayData[indexPath.row]});
}
//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-55) / 3.0;
        _layout.itemSize = CGSizeMake(width, 130);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0,17,0,17);
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PngCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[MobilImageReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    }
    return _collectionView;
}

- (ZLPhotoManager *)photoManager{
    if(!_photoManager){
        _photoManager = [[ZLPhotoManager alloc] init];
        [self.collectionView reloadData];
    }
    return _photoManager;
}
@end
