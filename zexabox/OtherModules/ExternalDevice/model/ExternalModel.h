//
//  ExternalModel.h
//  zeyun
//
//  Created by 邹琳 on 2018/6/15.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExternalModel : NSObject

@property (nonatomic,strong) NSString *ext;
@property (nonatomic,strong) NSString *file_type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) long size;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *path;
@end
