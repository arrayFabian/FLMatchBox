//
//  FLUser.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/28.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUser : NSObject

@property (nonatomic, copy) NSString *result;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *myInfo;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *url;

+ (instancetype)userparamWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
