//
//  FLCommentCell.m
//  FLMatchBox
//
//  Created by Mac on 16/4/7.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLCommentCell.h"

#import "FLCommentModel.h"
#import <UIButton+WebCache.h>



@implementation FLCommentCell



+ (instancetype)cellWithTableView:(UITableView *)tableview AndModel:(id)model
{
    static NSString * ID = @"FLCommentCell";
    FLCommentCell * cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil]lastObject];
    }
    cell.model = model;
    return cell;
}

- (void)setModel:(FLCommentModel *)model
{
    _model = model;
    NSString * url = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,model.userImg];
    [_btnHead sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    _lbName.text = model.userName;
    _lbTime.text = model.createDate;
    _lbContent.text = model.content;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
