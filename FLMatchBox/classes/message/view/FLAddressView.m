//
//  FLAddressView.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAddressView.h"
#import "FLAddressCellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomView.h"
@interface FLAddressView ()

@property (weak, nonatomic) IBOutlet CustomImageView *imgHead;

@property (weak, nonatomic) IBOutlet CustomView *customView;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbID;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;



@end




@implementation FLAddressView

- (IBAction)btnChatClicl:(id)sender
{
    
}
- (IBAction)btnHomeClick:(id)sender
{
    
}
- (IBAction)btnFollowClick:(id)sender
{
    //取消关注
    
    
}
- (IBAction)btnCloseClick:(id)sender
{
    [self removeFromSuperview];
    
    
}

- (void)setModel:(FLAddressCellModel *)model
{
    _model = model;
    
    // NSString *urlstr = [NSString stringWithFormat:@"%@",model];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"DefaultAvatar.png"]];
    self.lbID.text = [NSString stringWithFormat:@"ID:%ld",model.userId];
    self.lbName.text = model.userName;

    
}
- (void)tapCover:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    [view removeFromSuperview];
    
}

- (void)awakeFromNib
{
   self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:FLKeyWindow];
   
    if (point.x > self.customView.frame.origin.x && point.x < self.customView.frame.origin.x + self.customView.width && point.y > self.customView.frame.origin.y && point.y < self.customView.frame.origin.y + self.customView.height) {
        return;
    }
    
     [self removeFromSuperview];
}




- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
