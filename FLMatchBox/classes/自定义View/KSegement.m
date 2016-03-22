//
//  KSegement.m
//  Matchbox
//
//  Created by 刘卓明 on 16/2/12.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "KSegement.h"
#import "ViewConfig.h"
@interface KSegement()
@property (strong, nonatomic) UIButton *lastBtn;
@end


@implementation KSegement


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2.0;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [ViewConfig baseBlue].CGColor;
    }
    return self;
}

- (void)setTitlesArr:(NSArray *)titlesArr andCallback:(SegmentBlcok)callback
{
    _titlesArr = titlesArr;
    _callback = callback;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int W = self.bounds.size.width/titlesArr.count;
    int H = self.bounds.size.height;
    for (int i =0 ; i<titlesArr.count ; i++ ) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*W, 0, W, H)];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[ViewConfig baseBlue] forState:UIControlStateNormal];
        [btn setTitleColor:[ViewConfig baseBlue] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [self btnCLick:btn];
        }
    }
    
    
}

- (void)btnCLick:(UIButton*)btn
{
    _lastBtn.backgroundColor = [UIColor clearColor];
    _lastBtn.selected = NO;
    btn.selected = YES;
    btn.backgroundColor = [ViewConfig baseBlue];
    _lastBtn = btn;
    _callback(btn.tag);
    self.selectIndex = btn.tag;
    
}


@end
