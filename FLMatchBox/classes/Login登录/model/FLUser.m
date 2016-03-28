//
//  FLUser.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/28.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLUser.h"

#import <MJExtension/MJExtension.h>

@implementation FLUser
MJExtensionCodingImplementation

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)userparamWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}



@end
