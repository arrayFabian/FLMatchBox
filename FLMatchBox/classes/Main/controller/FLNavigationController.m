//
//  FLNavigationController.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLNavigationController.h"

@interface FLNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong)id  popdelegate;

@end

@implementation FLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popdelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
   
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
     FLLog(@"%s",__func__);
    
    if (self.viewControllers.count != 0) {//非根控制器
        
        //left
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalName:@"community_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
        //self.navigationBar.barTintColor = [UIColor redColor];
        //self.navigationBar.tintColor = [UIColor redColor];
        viewController.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -7, 0, 7);
        
        
        //bottom bar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)pop
{
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popdelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    
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
