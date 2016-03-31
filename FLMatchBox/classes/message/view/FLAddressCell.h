//
//  FLAddressCell.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLAddressCellModel;
@interface FLAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CustomImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbID;

@property (nonatomic, strong)FLAddressCellModel *cellModel;

+ (instancetype)cellWithTableview:(UITableView *)tableview;


@end
