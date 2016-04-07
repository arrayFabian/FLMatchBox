//
//  FLCommentModel.h
//  FLMatchBox
//
//  Created by Mac on 16/4/7.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLCommentModel : NSObject
@property (nonatomic, copy) NSString *userImg;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger dicussId;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *userName;
@end
