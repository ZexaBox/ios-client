//
//  URLRequest.h
//  UBaby
//
//  Created by fengei on 16/11/7.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLURLConst.h"
#import "DicToModel.h"
typedef void (^finishCallback)(id response,NSError *error);
typedef NS_ENUM(NSUInteger,ResquestMethod) {
    POST,
    GET,
    PUT,
    DELEGATE,
};
@interface URLRequest : NSObject


@end
