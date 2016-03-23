//
//  FLTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLTopicVC.h"

@interface FLTopicVC ()

@end

@implementation FLTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView.layer.cornerRadius = self.navigationItem.titleView.bounds.size.height/2.f;
    self.navigationItem.titleView.layer.masksToBounds = YES;
    self.navigationItem.titleView.layer.borderWidth = 1;
    self.navigationItem.titleView.layer.borderColor = [[UIColor blackColor]CGColor];
     FLLog(@"%s",__func__);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FLLog(@"%s",__func__);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    FLLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    FLLog(@"%s",__func__);
}

- (void)dealloc
{
    FLLog(@"%s",__func__);
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
