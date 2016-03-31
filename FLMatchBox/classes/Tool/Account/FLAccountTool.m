//
//  FLAccountTool.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAccountTool.h"
#import "FLAccount.h"
#import "FLUser.h"


#define FLAccountFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

#define FLUserFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]


@implementation FLAccountTool

//类方法一般用静态变量代替成员属性
static FLAccount *_account;
static FLUser *_user;

+ (void)saveAccount:(FLAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:FLAccountFilePath];
}

+ (void)saveUser:(FLUser *)user
{
    [NSKeyedArchiver archiveRootObject:user toFile:FLUserFilePath];
}

+ (FLAccount *)account
{
    if (_account == nil) {
        
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:FLAccountFilePath];
    }
    //    //判断是否过期
    //    if ([[NSDate date] compare:_account.expires_date] != NSOrderedAscending) {// 递减 过期，重新授权
    //
    //        return nil;
    //    }
    
    return _account;
    
}

+ (FLUser *)user
{
    
    _user = [NSKeyedUnarchiver unarchiveObjectWithFile:FLUserFilePath];
    
    return _user;
}


@end
