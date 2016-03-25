//
//  FLPostCell.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLPostCellModel;
@protocol FLPostCellModelDelegate <NSObject>



@end

@interface FLPostCell : UITableViewCell

@property (nonatomic, strong)FLPostCellModel *cellmodel;

@property (nonatomic, weak) id<FLPostCellModelDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(FLPostCellModel *)cellmodel;


@end
