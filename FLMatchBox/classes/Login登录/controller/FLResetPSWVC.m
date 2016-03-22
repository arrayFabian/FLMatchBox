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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
