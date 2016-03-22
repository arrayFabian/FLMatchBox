//
//  FLThreeSignInView.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/16.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLThreeSignInView.h"

@interface FLThreeSignInView ()

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end


@implementation FLThreeSignInView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        
        
        
    }
    return self;
}

@end
