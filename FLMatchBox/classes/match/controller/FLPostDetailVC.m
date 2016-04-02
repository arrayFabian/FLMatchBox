//
//  FLPostDetailVC.m
//  FLMatchBox
//
//  Created by Mac on 16/4/2.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostDetailVC.h"

@interface FLPostDetailVC ()

@end

@implementation FLPostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%ld",[self.friendId integerValue]);
    
    
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
