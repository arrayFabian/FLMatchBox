//
//  ProgressView.m
//  MatchBox
//
//  Created by whunf on 16/3/25.
//  Copyright © 2016年 whunf. All rights reserved.
//

#import "ProgressView.h"
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
@interface ProgressView()
// 百分比
@property (strong, nonatomic) CAShapeLayer * circleLayer;
@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.borderColor = [UIColor cyanColor].CGColor;
        _circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor purpleColor].CGColor;
        _circleLayer.lineWidth = 4.f;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleLayer];
        
        
        CALayer *gradientLayer = [CALayer layer];
        CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[[UIColor grayColor  ]CGColor],nil]];
//        [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
        [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
        [gradientLayer addSublayer:gradientLayer1];
        
        CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
//        [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
        gradientLayer2.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil]];
        [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
        [gradientLayer addSublayer:gradientLayer2];

        [gradientLayer setMask:_circleLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        
        
    }
    return self;
}

- (void)setPersent:(CGFloat )persent
{
    _persent = persent;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 10.f;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
                   radius:self.bounds.size.width/2.0-3
               startAngle:(-0.5*M_PI)
                  endAngle:((persent*2-0.5)*M_PI)
                 clockwise:YES];
    
    _circleLayer.path = path.CGPath;
    
    
}

@end
