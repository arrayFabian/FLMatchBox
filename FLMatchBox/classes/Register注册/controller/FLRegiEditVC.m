//
//  FLRegiEditVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLRegiEditVC.h"

@interface FLRegiEditVC ()

@end

@implementation FLRegiEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
