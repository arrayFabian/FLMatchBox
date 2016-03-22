//
//  FLRegiServerVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/22.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLRegiServerVC.h"

@interface FLRegiServerVC ()

@end

@implementation FLRegiServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
