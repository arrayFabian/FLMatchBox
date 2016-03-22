//
//  FLLogin.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/16.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLLogin.h"

@interface FLLogin ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *countryLb;
@property (weak, nonatomic) IBOutlet UITextField *shortNum;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *popBtn;


@end


@implementation FLLogin

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
