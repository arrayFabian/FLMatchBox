//
//  FLForgetPSWVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLForgetPSWVC.h"

@interface FLForgetPSWVC ()

@end

@implementation FLForgetPSWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
