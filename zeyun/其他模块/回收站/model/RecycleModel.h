//
//  Recycle.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecycleModel : NSObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) long size;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *thumbnail;
@end
