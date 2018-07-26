//
//  DicToModel.m
//  字典解析
//
//  Created by zoulin on 16/3/23.
//  Copyright © 2016年 FishOfEyes. All rights reserved.
//

#import "DicToModel.h"
#import <objc/runtime.h>
unsigned int count = 0;
int arrayBegin=0;//查找字典中的键
@interface DicToModel ()
{
}

@property (nonatomic, copy) NSMutableArray *arrayMoelData;
@end
@implementation DicToModel

+(DicToModel *) dicToModel
{
    return [[DicToModel alloc]init];
}
/**
 *  开始解析
 *
 *  @param response 请求下来的data数据
 *  @param model    请求模型
 */
- (void)modelGetWithID:(id)response model:(Class)model
{
    if(response == nil)
    {
        return;
    }
//    id result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    [self checkIsWhichClass:response modelClass:(Class) model];
}
//判断是字典还是数组
- (void) checkIsWhichClass:(id) result modelClass:(Class) model
{
    if([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *) result;
        arrayBegin = 0;
        [self parseringWithDic:dic model:model];
    }
    else if([result isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *) result;
        [self parseringWithArray:array modelClass:model];
    }
}
- (void) parseringWithDic:(NSDictionary *) dic model:(Class) model
{
    NSArray *arrayKey = [dic allKeys];
    Class class = NSClassFromString(NSStringFromClass(model));
    id modelData = [[class alloc]init];
    Ivar *ivars = class_copyIvarList([modelData class], &count);
    for (int i = 0;i<count;i++)
    {
        Ivar ivar = ivars[i];
        const char *cName = ivar_getName(ivar);
        NSString *OCName = [[NSString stringWithUTF8String:cName] substringFromIndex:1];
        if([arrayKey containsObject:OCName])
        {
            [modelData setValue:dic[OCName] forKey:OCName];
        }
        else if([arrayKey containsObject:@"id"] || [arrayKey containsObject:@"description"])
        {
            if([OCName containsString:@"id"]) [modelData setValue:dic[@"id"] forKey:OCName];
            if([OCName containsString:@"description"]) [modelData setValue:dic[@"description"] forKey:OCName];
        }
        else
        {
            if(arrayBegin<arrayKey.count)
            {
                [self checkIsWhichClass:dic[arrayKey[arrayBegin]] modelClass:model];
                arrayBegin++;
            }
        }
    }
    free(ivars);
    [self.arrayMoelData addObject:modelData];
}
- (void) parseringWithArray:(NSArray *) array modelClass:(Class) model
{
    for(id temp in array)
    {
        [self checkIsWhichClass:temp modelClass:model];
    }
}
/**
 *  用户调用的函数
 *
 *  @param response 请求的数据
 *  @param model    模型类
 *
 *  @return 解析好的数据
 */
- (NSArray *) modelGetData:(id) response model:(__unsafe_unretained Class)model
{
    [self modelGetWithID:response model:model];
    //移除最后一个
//    [self.arrayMoelData removeObjectAtIndex:self.arrayMoelData.count-1];
    return  [self.arrayMoelData copy];
}
- (NSMutableArray *)arrayMoelData
{
    if(!_arrayMoelData)
    {
        _arrayMoelData = [NSMutableArray array];
    }
    return _arrayMoelData;
}
@end
