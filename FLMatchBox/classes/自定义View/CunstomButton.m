//
//  CunstomButton.m
//  Matchbox
//
//  Created by 刘卓明 on 16/1/17.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "CunstomButton.h"

@implementation CunstomButton
- (void)setIsCircle:(BOOL)isCircle
{
    _isCircle = isCircle;
    if (isCircle) {
        self.layer.cornerRadius = self.bounds.size.height/2.0;
        self.layer.masksToBounds = YES;
    }
}

- (void)setR:(CGFloat)R{
    _R = R;
    if (_R) {
        self.layer.cornerRadius = R;
        self.layer.masksToBounds = YES;
    }
}

- (void)setBoardWidth:(CGFloat)boardWidth
{
    _boardWidth = boardWidth;
    if (_boardWidth ) {
        self.layer.borderWidth = _boardWidth;
    }
}

- (void)setBoardColor:(UIColor *)boardColor
{
    _boardColor = boardColor;
    self.layer.borderColor = boardColor.CGColor;
}

@end
