//
//  FLAccount.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLAccount : NSObject

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userId;
/**
 *  登录手机号
 */
@property (nonatomic, assign) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
