//
//  FLLoginRespoParam.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/26.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLLoginRespoParam.h"

@implementation FLLoginRespoParam


+ (instancetype)paramWithDict:(NSDictionary *)dict
{
    FLLoginRespoParam *param = [[self alloc] init];
    [param setValuesForKeysWithDictionary:dict];
    
    return param;
}



@end
