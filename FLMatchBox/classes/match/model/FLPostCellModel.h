//
//  FLPostCellModel.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>





@class Photolist;
@interface FLPostCellModel : NSObject


@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger discussCount;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger isCollection;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger topicId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger isAction;

@property (nonatomic, strong) NSArray<Photolist *> *photoList;

@property (nonatomic, assign) NSInteger friendId;

@property (nonatomic, assign) NSInteger topCount;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger shareCount;

@property (nonatomic, assign) NSInteger isTop;

@end


@interface Photolist : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *imgUrl;

@end

