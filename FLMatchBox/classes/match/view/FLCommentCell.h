//
//  FLCommentCell.h
//  FLMatchBox
//
//  Created by Mac on 16/4/7.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLCommentModel;
@interface FLCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnHead;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (strong, nonatomic) FLCommentModel * model;
+ (instancetype)cellWithTableView:(UITableView *)tableview AndModel:(id)model;






@end
