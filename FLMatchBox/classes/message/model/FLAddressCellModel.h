//
//  FLAddressCellModel.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLAddressCellModel : NSObject


@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *userName;

/**
 *  首字母
 */
@property (nonatomic, copy) NSString *aleph;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
