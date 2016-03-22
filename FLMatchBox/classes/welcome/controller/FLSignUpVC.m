//
//  FLSignUpVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSignUpVC.h"
#import "FLThreeSignInView.h"
#import "FLSignInVC.h"
@interface FLSignUpVC ()

@end

@implementation FLSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    FLThreeSignInView *threeView = [[[NSBundle mainBundle]loadNibNamed:@"FLThreeSignInView" owner:nil options:nil] lastObject];
//  threeView.frame = CGRectMake(0,self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
//   
//    [self.view addSubview:threeView];
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
     btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn sizeToFit];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem.customView.hidden = self.hideRightBarItem;
    
}

- (void)gotoLogin
{
    FLSignInVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLSignInVC"];
    [vc setValue:@YES forKey:@"hideRightBarItem"];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)dealloc
{
     FLLog(@"%s",__func__);
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
