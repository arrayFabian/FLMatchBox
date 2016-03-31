//
//  FLAddressCell.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAddressCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLAddressCellModel.h"

@interface FLAddressCell ()



@end




@implementation FLAddressCell

+ (instancetype)cellWithTableview:(UITableView *)tableview
{
    static NSString *identifier = @"addressCell";
    FLAddressCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FLAddressCell" owner:nil options:nil] lastObject];
    }
    
    return cell;

}


- (void)setCellModel:(FLAddressCellModel *)cellModel
{
    _cellModel = cellModel;
    
   // NSString *urlstr = [NSString stringWithFormat:@"%@",cellModel.url];
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:cellModel.url] placeholderImage:[UIImage imageNamed:@"DefaultAvatar.png"]];
        self.lbID.text = [NSString stringWithFormat:@"ID:%ld",cellModel.userId];
        self.lbName.text = cellModel.userName;
    
     
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
