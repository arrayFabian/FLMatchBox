//
//  FLAccountTool.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLAccount;
@interface FLAccountTool : NSObject

+ (void)saveAccount:(FLAccount *)account;

+ (FLAccount *)account;
@end
