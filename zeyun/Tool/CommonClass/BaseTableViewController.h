//
//  BaseTableViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "ZLBaseViewController.h"
@interface BaseTableViewController : ZLBaseViewController

@property (nonatomic,strong) UITableView *tableView;

/** 添加下拉刷新 */
- (void) addHeadRefresh;

/** 添加上啦刷新 */
- (void) addFootRefresh;

/** 重新加载数据 */
- (void) reloadData;

/** 上啦刷新数据 */
- (void) loadMoreData;

/** 结束所有刷新 */
- (void) endReshfresh;

/** regist Nib */
- (void) registWithNibName:(NSString *)name identifier:(NSString *)identifier;
@end
