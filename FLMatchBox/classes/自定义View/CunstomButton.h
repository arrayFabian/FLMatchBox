//
//  CunstomButton.h
//  Matchbox
//
//  Created by 刘卓明 on 16/1/17.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CunstomButton : UIButton

@property(nonatomic,assign) IBInspectable BOOL isCircle;
@property(nonatomic,assign) IBInspectable CGFloat R;
@property(nonatomic,assign) IBInspectable CGFloat boardWidth;
@property(nonatomic,assign) IBInspectable UIColor * boardColor;

@end
