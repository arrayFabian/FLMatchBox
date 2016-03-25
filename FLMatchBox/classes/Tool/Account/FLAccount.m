//
//  FLAccount.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAccount.h"

#import <MJExtension/MJExtension.h>

@implementation FLAccount
// 底层便利当前的类的所有属性，一个一个归档和接档
MJExtensionCodingImplementation


+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    FLAccount *account = [[self alloc] init];
    [account setValuesForKeysWithDictionary:dict];
    return account;
}

@end
