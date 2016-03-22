//
//  FLResetPSWVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/17.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLResetPSWVC.h"
#import "FLSignInVC.h"

@interface FLResetPSWVC ()


@end

@implementation FLResetPSWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tureToPopToLoginVC:(id)sender
{
   
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[FLSignInVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
