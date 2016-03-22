//
//  FLWelcomeNaviVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLWelcomeNaviVC.h"

@interface FLWelcomeNaviVC ()<UINavigationControllerDelegate>

@property (nonatomic, strong)id  popdelegate;

@end

@implementation FLWelcomeNaviVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.popdelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    
    
    
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
 
    if (self.viewControllers.count != 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalName:@"community_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
        //self.navigationBar.barTintColor = [UIColor redColor];
        //self.navigationBar.tintColor = [UIColor redColor];
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
