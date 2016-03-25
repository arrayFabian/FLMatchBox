//
//  FLPostCell.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface FLPostCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnTopic;
@property (weak, nonatomic) IBOutlet UIButton *btnView;

@property (weak, nonatomic) IBOutlet CustomImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIButton *btnOperation;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lbLike;
@property (weak, nonatomic) IBOutlet UILabel *lbComment;
@property (weak, nonatomic) IBOutlet UIButton *btnRetweet;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;

@property (weak, nonatomic) IBOutlet UIView *lbView;

@property (weak, nonatomic) IBOutlet UILabel *lbText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbToTopview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbToImageView;





@end




@implementation FLPostCell

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(FLPostCellModel *)cellmodel
{
    static NSString *reuseID = @"FLPostCell";
    
    FLPostCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseID owner:nil options:nil] lastObject];
    }
    cell.cellmodel = cellmodel;
    return cell;
}


- (void)setCellmodel:(FLPostCellModel *)cellmodel
{
    _cellmodel = cellmodel;
    //用户名
    self.lbName.text = cellmodel.userName;
     //话题名
    [self.btnTopic setTitle:cellmodel.topicName forState:UIControlStateNormal];
     //用户头像
    
    NSString *path = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,cellmodel.imgUrl];
    FLLog(@"%@",path);
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
     //关注按钮
    if (cellmodel.isAction) {
        self.btnFollow.hidden = YES;
    }else{
        self.btnFollow.hidden = NO;
    }
    
    
     //帖子类型 是否有图
    if (cellmodel.type == 1) {
        self.lbToImageView.priority = UILayoutPriorityDefaultLow;
        self.lbToTopview.priority = UILayoutPriorityDefaultHigh;
        self.imgView.hidden = YES;
        
        
    }else if (cellmodel.type == 2){//有图
     
        self.lbToImageView.priority = UILayoutPriorityDefaultHigh;
        self.lbToTopview.priority = UILayoutPriorityDefaultLow;
        self.imgView.hidden = NO;
        
         NSString *path1 = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,[cellmodel.photoList firstObject].imgUrl];
         FLLog(@"%@",path1);
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:path1] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
        
    }
     //帖子文本内容
    self.lbText.text = cellmodel.msg;
    
    //创建时间
    
    //评论数
    self.lbComment.text = [NSString stringWithFormat:@"%ld",cellmodel.discussCount];
    //点赞数
    self.lbLike.text = [NSString stringWithFormat:@"%ld",cellmodel.topCount];
    //是否点赞
    if (cellmodel.isTop) {
        self.btnLike.selected = YES;
    }else{
        self.btnLike.selected = NO;
    }
    
    
    
    
}


- (IBAction)btnCommentDidClick:(UIButton *)sender {
}

- (IBAction)btnRetweetDidClick:(id)sender {
}

- (IBAction)btnLikeDidClick:(id)sender {
}

- (IBAction)btnViewDidClickToShowDetail:(id)sender {
}

- (IBAction)btnOperationDidClick:(id)sender {
}

- (IBAction)btnFollowDidClick:(id)sender {
}

- (IBAction)btnTopicDidClick:(id)sender {
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
