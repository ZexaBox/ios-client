//
//  BindModel.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/25.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindModel : NSObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *mac;
/** 链接识别号 */
@property (nonatomic,strong) NSString *peerid;
/** sn号 */
@property (nonatomic,strong) NSString *sn;
@end
