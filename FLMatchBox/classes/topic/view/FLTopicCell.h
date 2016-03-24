//
//  FLTopicCell.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLTopicModel;
@interface FLTopicCell : UITableViewCell

@property (nonatomic, strong)FLTopicModel *topicModel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
