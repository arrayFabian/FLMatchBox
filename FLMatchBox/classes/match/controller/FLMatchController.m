//
//  FLMatchController.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/16.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLMatchController.h"

@interface FLMatchController ()

@end

@implementation FLMatchController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"AppIcon40x40~ipad"];
    
    
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
