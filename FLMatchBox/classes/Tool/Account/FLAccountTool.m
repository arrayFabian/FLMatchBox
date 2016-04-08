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

#define FLMatchPostCellModelArrFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"FLMatchPostCellModelArr.data"]


#define FLBoxPostCellModelArrFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"FLBoxPostCellModelArr.data"]

@implementation FLAccountTool

//类方法一般用静态变量代替成员属性
static FLAccount *_account;
static FLUser *_user;
static NSMutableArray *_modelArr;
static NSMutableArray *_boxArr;

+ (void)saveMatchPostCellModelArr:(NSMutableArray *)modelArr
{
    [NSKeyedArchiver archiveRootObject:modelArr toFile:FLMatchPostCellModelArrFilePath];
    
}
+ (NSMutableArray *)getMatchPostCellModelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSKeyedUnarchiver unarchiveObjectWithFile:FLMatchPostCellModelArrFilePath];

    }
    
    return _modelArr;

    
}

+ (void)saveBoxPostCellModelArr:(NSMutableArray *)modelArr
{
    
     [NSKeyedArchiver archiveRootObject:modelArr toFile:FLBoxPostCellModelArrFilePath];
    
}

+ (NSMutableArray *)getBoxPostCellModelArr
{
    if (_boxArr == nil) {
        _boxArr = [NSKeyedUnarchiver unarchiveObjectWithFile:FLBoxPostCellModelArrFilePath];
    }
    
    return _boxArr;

}

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
