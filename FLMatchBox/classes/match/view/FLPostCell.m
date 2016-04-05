//
//  FLPostCell.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import "FLHttpTool.h"
#import "FLUser.h"

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



@property (weak, nonatomic) IBOutlet UILabel *lbText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbToTopview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbToImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeadToCellTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgHeadToTopic;



@end




@implementation FLPostCell

- (void)imgHeadTapped:(UITapGestureRecognizer *)sender
{
    FLLog(@"%s",__func__);
    
    if ([self.delegate respondsToSelector:@selector(postCell:imgHeadTapped:)]) {
        [self.delegate postCell:self imgHeadTapped:_cellmodel];
    }
}

- (void)imgViewTapped:(UITapGestureRecognizer *)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnViewDidClick:)]) {
        [self.delegate postCell:self imgViewTapped:_cellmodel.photoList];
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(FLPostCellModel *)cellmodel
{
    static NSString *reuseID = @"FLPostCell";
    
    FLPostCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseID owner:nil options:nil] lastObject];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgView.clipsToBounds = YES;
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        
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
    
     //帖子类型 是否有图
    if (cellmodel.type == 1 || cellmodel.photoList.count == 0) {
        self.lbToImageView.priority = UILayoutPriorityDefaultLow;
        self.lbToTopview.priority = UILayoutPriorityDefaultHigh;
        self.imgView.hidden = YES;
        
        
    }else {//有图
     
        self.lbToImageView.priority = UILayoutPriorityDefaultHigh;
        self.lbToTopview.priority = UILayoutPriorityDefaultLow;
        self.imgView.hidden = NO;
        
         NSString *path1 = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,[cellmodel.photoList firstObject].imgUrl];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:path1] placeholderImage:[UIImage imageNamed:@"DefaultAvatar.png"]];
        
    }
     //帖子文本内容
    self.lbText.text = cellmodel.msg;
    

    //创建时间
    self.lbTime.text = cellmodel.createDate;
    
    //评论数
    self.lbComment.text = [NSString stringWithFormat:@"%ld",cellmodel.discussCount];
    //点赞数
    self.lbLike.text = [NSString stringWithFormat:@"%ld",cellmodel.topCount];
    
    //点赞 和 关注
    NSLog(@"%ld",(long)cellmodel.isTop);
    self.btnLike.selected = cellmodel.isTop;
    self.btnFollow.hidden = cellmodel.isAction;
    
    
    
    
}


- (void)setIsCellInTopicDetail:(BOOL)isCellInTopicDetail
{
    _isCellInTopicDetail = isCellInTopicDetail;
    
    if (isCellInTopicDetail) {
        self.imgHeadToCellTop.priority = UILayoutPriorityDefaultHigh;
        self.ImgHeadToTopic.priority = UILayoutPriorityDefaultLow;
        self.btnTopic.hidden = YES;
    }else{
        self.imgHeadToCellTop.priority = UILayoutPriorityDefaultLow;
        self.ImgHeadToTopic.priority = UILayoutPriorityDefaultHigh;
        self.btnTopic.hidden = NO;
    }
    
}


- (void)setIsCellInUserDetail:(BOOL)isCellInUserDetail
{
    _isCellInUserDetail = isCellInUserDetail;
    
    if (isCellInUserDetail) {
        self.btnFollow.hidden = YES;
    }else{
        self.btnFollow.hidden = NO;
    }
    
}

- (void)setIsCellInPostDetail:(BOOL)isCellInPostDetail
{
    _isCellInPostDetail = isCellInPostDetail;
    if (isCellInPostDetail) {
        self.btnFollow.hidden = YES;
        self.btnOperation.hidden = YES;
        self.toolView.hidden = YES;
    }else{
        self.btnFollow.hidden = NO;
        self.btnOperation.hidden = NO;
        self.toolView.hidden = NO;
    }
}

- (IBAction)btnCommentDidClick:(UIButton *)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnCommentDidClick:)]) {
        [self.delegate postCell:self btnCommentDidClick:_cellmodel];
    }
}

- (IBAction)btnRetweetDidClick:(id)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnRetweetDidClick:)]) {
        [self.delegate postCell:self btnRetweetDidClick:_cellmodel];
    }

}

//点赞让cell自己完成
- (IBAction)btnLikeDidClick:(id)sender
{
    FLLog(@"%s",__func__);
    UIButton *btn = (UIButton *)sender;
    FLLog(@"%d",btn.selected);
    NSString *url = btn.selected? @"/Matchbox/usercancleTop":@"/Matchbox/useraddTopForFriend";
    FLLog(@"%@",url);
    
    NSDictionary *param = @{@"userId":@(kUserModel.userId),
                                @"friendId":@(_cellmodel.friendId)};
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@%@",BaseUrl,url] param:param success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            _cellmodel.isTop = !_cellmodel.isTop;
            btn.selected = !btn.selected;
            
            if (_cellmodel.isTop) {
                _cellmodel.topCount++;
            }else{
                _cellmodel.topCount--;
            }
            
         self.lbLike.text = [NSString stringWithFormat:@"%ld",_cellmodel.topCount];
            
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (IBAction)btnViewDidClickToShowDetail:(id)sender
{
    FLLog(@"%s",__func__);
    
    if ([self.delegate respondsToSelector:@selector(postCell:btnViewDidClick:)]) {
        [self.delegate postCell:self btnViewDidClick:_cellmodel];
    }
    

}

- (IBAction)btnOperationDidClick:(id)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnOperationDidClick:)]) {
        [self.delegate postCell:self btnOperationDidClick:self.cellmodel];
    }

}

- (IBAction)btnFollowDidClick:(id)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnFollowDidClick:)]) {
        [self.delegate postCell:self btnFollowDidClick:self.cellmodel];
    }
    
    
}

- (IBAction)btnTopicDidClick:(id)sender
{
    FLLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(postCell:btnTopicDidClick:)]) {
        [self.delegate postCell:self btnTopicDidClick:_cellmodel];
    }

}


- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *imgHeadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgHeadTapped:)];
    self.headImg.userInteractionEnabled = YES;
    [self.headImg addGestureRecognizer:imgHeadTap];
    
    UITapGestureRecognizer *imgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapped:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:imgViewTap];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
