//
//  FLLoginRespoParam.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/26.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLLoginRespoParam : NSObject

@property (nonatomic, copy) NSString *result;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *myInfo;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *url;

+ (instancetype)paramWithDict:(NSDictionary *)dict;

@end
