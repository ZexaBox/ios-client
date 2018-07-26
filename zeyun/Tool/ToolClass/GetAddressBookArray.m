//
//  GetAddressBookArray.m
//  AddressBookDemo
//
//  Created by bolo-mac mini2 on 2017/6/1.
//  Copyright © 2017年 bolo-mac mini2. All rights reserved.
//

#import "GetAddressBookArray.h"

@implementation GetAddressBookArray

+ (NSArray *)getPhoneAddressBookArray {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果不是已经授权,则直接返回
    if (status == CNAuthorizationStatusDenied) {
        [FaceAlertTool svpShowErrorWithMsg:@"需要授权才能获取通讯录"];
        return nil;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    // 创建联系人的请求对象
    // keys决定这次要获取哪些信息,比如姓名/电话
    NSArray *fetchKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 请求联系人
    NSError *error = nil;
    
    NSMutableArray *array = [NSMutableArray array];

    [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // stop是决定是否要停止
        // 1.获取姓名
        NSString *firstname = contact.givenName;
        NSString *lastname = contact.familyName;
        
        // 2.获取电话号码
        NSArray *phones = contact.phoneNumbers;
        
        // 3.遍历电话号码
        for (CNLabeledValue *labelValue in phones) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *valueName = [NSString stringWithFormat:@"%@%@",lastname,firstname];
            if(![valueName isEqualToString:@""]){
                NSDictionary *dic = @{valueName:@{@"mNUmber":phoneNumber.stringValue,@"nType":labelValue.label}};
                NSLog(@"dic == %@",dic);
                [array addObject:dic];
            }
        }
    }];
    return [array copy];
}


+ (void)wiriteToAddress:(NSDictionary *)dic
{
    
    NSString *name = [[dic allKeys] lastObject];
    NSDictionary *dic2 = [[dic allValues] lastObject];
    NSString *phone = [NSString stringWithFormat:@"%@",dic2[@"mNumber"]];
    NSString *identifier = dic2[@"nType"];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied) {
        [FaceAlertTool svpShowErrorWithMsg:@"需要授权才能恢复备份的通讯录"];
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *request = [[CNSaveRequest alloc] init];
    
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.givenName = name;
    CNPhoneNumber *phoneber = [CNPhoneNumber phoneNumberWithStringValue:phone];
    contact.phoneNumbers = @[[[CNLabeledValue alloc] initWithLabel:identifier value:phoneber]];
    [request addContact:contact toContainerWithIdentifier:nil];
    NSError *error;
    [store executeSaveRequest:request error:&error];
    NSLog(@"保存联系人===%@",error);
}

@end
