//
//  FLLogin.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/16.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLLogin.h"

@interface FLLogin ()<UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UIView *contentView;



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
