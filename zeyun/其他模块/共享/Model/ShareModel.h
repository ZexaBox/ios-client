//
//  ShareModel.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) NSInteger tag_id;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *file_type;
@property (nonatomic,assign) long size;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *thumbnail;
@end
