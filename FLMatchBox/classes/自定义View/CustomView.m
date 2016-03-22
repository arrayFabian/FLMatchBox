//
//  CustomView.m
//  Matchbox
//
//  Created by 刘卓明 on 16/1/17.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView




- (void)setIsCircle:(BOOL)isCircle
{
    _isCircle = isCircle;
    if (isCircle) {
        self.layer.cornerRadius = self.bounds.size.height/2.0;
        self.layer.masksToBounds = YES;
    }
}


@end
