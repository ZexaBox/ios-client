//
//  NSString+Base64.m
//  UBaby
//
//  Created by fengei on 16/11/23.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "NSString+ZLBase64.h"

@implementation NSString (ZLBase64)

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
