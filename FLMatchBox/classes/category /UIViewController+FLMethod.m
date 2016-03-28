//
//  UIViewController+FLMethod.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/28.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "UIViewController+FLMethod.h"
#import <MMAlertView.h>


@implementation UIViewController (FLMethod)

- (void)sentAlert:(NSString *)title detail:(NSString *)detail
{
    MMAlertView *alert = [[MMAlertView alloc]initWithConfirmTitle:title detail:detail];
    [alert show];
}




@end
