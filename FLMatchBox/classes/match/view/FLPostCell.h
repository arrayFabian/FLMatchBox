//
//  FLPostCell.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLPostCellModel,FLPostCell,Photolist;
@protocol FLPostCellModelDelegate <NSObject>
@optional
- (void)postCell:(FLPostCell *)postCell btnTopicDidClick:(NSInteger)topicId;

- (void)postCell:(FLPostCell *)postCell btnOperationDidClick:(FLPostCellModel *)cellModel;

- (void)postCell:(FLPostCell *)postCell btnCommentDidClick:(NSInteger)friendId;

- (void)postCell:(FLPostCell *)postCell btnRetweetDidClick:(NSInteger)friendId;

- (void)postCell:(FLPostCell *)postCell btnViewDidClick:(NSInteger)friendId;

- (void)postCell:(FLPostCell *)postCell imgHeadTapped:(NSInteger)userId;

- (void)postCell:(FLPostCell *)postCell imgViewTapped:( NSArray<Photolist *> *)photoList;

@end

@interface FLPostCell : UITableViewCell

@property (nonatomic, strong)FLPostCellModel *cellmodel;

@property (nonatomic, weak) id<FLPostCellModelDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(FLPostCellModel *)cellmodel;


@end
