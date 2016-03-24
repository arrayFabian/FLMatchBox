//
//  CustomView.h
//  Matchbox
//
//  Created by 刘卓明 on 16/1/17.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CustomView : UIView

@property(nonatomic,assign) IBInspectable BOOL isCircle;
@property(nonatomic,assign) IBInspectable CGFloat R;

@end
