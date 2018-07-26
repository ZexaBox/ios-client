//
//  SearchViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SearchViewController : BaseTableViewController

@property (nonatomic,strong) NSString *searchTitle;

/** 是否是云搜索 */
@property (nonatomic,assign) BOOL iscloudSearch;

/** 是否是共享空间搜索文件 */
@property (nonatomic,assign) BOOL issharespace;
@end
