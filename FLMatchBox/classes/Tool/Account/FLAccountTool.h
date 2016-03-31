//
//  FLAccountTool.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FLAccount,FLUser;

@interface FLAccountTool : NSObject

+ (void)saveAccount:(FLAccount *)account;

+ (FLAccount *)account;

+ (FLUser *)user;

+ (void)saveUser:(FLUser *)user;


@end
