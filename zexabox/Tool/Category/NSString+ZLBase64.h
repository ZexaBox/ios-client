//
//  NSString+Base64.h
//  UBaby
//
//  Created by fengei on 16/11/23.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZLBase64)

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;

/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;
@end
