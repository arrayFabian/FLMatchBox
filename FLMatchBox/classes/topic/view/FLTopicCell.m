//
//  FLTopicCell.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLTopicCell.h"
#import "FLTopicModel.h"

@interface FLTopicCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbTopic;
@property (weak, nonatomic) IBOutlet UILabel *lbReadCount;





@end


@implementation FLTopicCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *reuseId = @"topicCell";
    
    FLTopicCell *cell = [tableview dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FLTopicCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}


- (void)setTopicModel:(FLTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    self.lbTopic.text = topicModel.name;
    self.lbReadCount.text = [NSString stringWithFormat:@"%ld 次浏览",topicModel.seeCount];
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
