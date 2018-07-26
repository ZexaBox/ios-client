//
//  GetAddressBookArray.h
//  AddressBookDemo
//
//  Created by bolo-mac mini2 on 2017/6/1.
//  Copyright © 2017年 bolo-mac mini2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/CNContact.h>
#import <ContactsUI/ContactsUI.h>

@interface GetAddressBookArray : NSObject

+ (NSArray *)getPhoneAddressBookArray;

+ (void)wiriteToAddress:(NSDictionary *)dic;
@end
