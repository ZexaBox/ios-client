//
//  FaceToFaceCloseViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FaceToFaceCloseViewController.h"
#import "PngCell.h"
#import "URLRequest.h"
#import "PngModel.h"
#import "FaceToFaceCloseCollectionViewCell.h"
#import "FaceToFaceModel.h"
#import "ZLPhotoManager.h"
@interface FaceToFaceCloseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) ZLPhotoManager *photoManager;
@property (nonatomic,strong) NSArray *arrayVideo;
@property (nonatomic,strong) NSArray *arrayImage;
@property (nonatomic,strong) NSMutableDictionary *dicImage;
@end

@implementation FaceToFaceCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = [@"最近文件" language];
    self.arrayData = [NSMutableArray array];
    self.dicImage = [NSMutableDictionary dictionary];
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    self.photoManager = [[ZLPhotoManager alloc] init];
    [self.photoManager GetALLVideoUsingPohotKit:^(NSArray<PHAsset *> *res) {
        self.arrayVideo = [NSArray arrayWithArray:res];
    }];
    [self.photoManager GetALLphotosUsingPohotKit:^(NSArray<PHAsset *> *res) {
        self.arrayImage = [NSArray arrayWithArray:res];
    }];
    
    
    
    [self requestData];
}
- (void) requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    [URLRequest requestWithMethod:GET urlString:url_faceToface_list parameters:nil finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSArray *arrray = [[DicToModel dicToModel] modelGetData:response[@"data"][@"upload"] model:[FaceToFaceModel class]];
                NSArray *array2 = [[DicToModel dicToModel] modelGetData:response[@"data"][@"download"] model:[FaceToFaceModel class]];
                [self.arrayData removeAllObjects];
                [self.arrayData addObjectsFromArray:arrray];
                [self.arrayData addObjectsFromArray:array2];
                [self getInfo];
                [self.collectionView reloadData];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[response valueForKey:@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}
//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FaceToFaceCloseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.arrayData[indexPath.row];
    cell.headImageView.image = self.dicImage[cell.model.name];
    return cell;
}

- (void) getInfo{
    [self.arrayImage enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:obj1] firstObject];
        [self.arrayData enumerateObjectsUsingBlock:^(FaceToFaceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([resource.originalFilename isEqualToString:obj.name]){
                [self.photoManager getVideoFaceImage:obj1 complemtion:^(UIImage *res, NSString *name) {
                    [self.dicImage setValue:res forKey:obj.name];
                }];
            }
        }];
    }];
    
    [self.arrayVideo enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:obj1] firstObject];
        [self.arrayData enumerateObjectsUsingBlock:^(FaceToFaceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([resource.originalFilename isEqualToString:obj.name]){
                [self.photoManager getVideoFaceImage:obj1 complemtion:^(UIImage *res, NSString *name) {
                    [self.dicImage setValue:res forKey:obj.name];
                }];
            }
        }];
    }];
    
    [self.collectionView reloadData];
}

//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (SCREEN_WIDTH-70) / 3.0;
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
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"FaceToFaceCloseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}


@end
