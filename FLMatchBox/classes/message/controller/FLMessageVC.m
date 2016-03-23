//
//  FLMessageVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLMessageVC.h"

@interface FLMessageVC ()

@end

@implementation FLMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView.layer.cornerRadius = self.navigationItem.titleView.bounds.size.height/2.f;
    self.navigationItem.titleView.layer.masksToBounds = YES;
    self.navigationItem.titleView.layer.borderWidth = 1;
    self.navigationItem.titleView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    
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
