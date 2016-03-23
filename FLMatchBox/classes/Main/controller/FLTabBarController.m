//
//  FLTabBarControllerViewController.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLTabBarController.h"

@interface FLTabBarController ()

@end

@implementation FLTabBarController

+ (void)initialize
{

    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FLLog(@"%s",__func__);
    
    [self initTabBarItem];
    
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

- (void)initTabBarItem
{
    NSArray * img = @[@"Social_One",@"Social_Topic",@"Social_Messages",@"Social_Box",@"Social_Private"];
    NSArray * imgArr = @[@"Social_One_Select",@"Social_Topic_Select",@"Social_Messages_Select",@"Social_Box_Select",@"Social_Private_Select"];
    
    NSMutableArray *items = [@[] mutableCopy];
    for (int i = 0; i < img.count; i++) {
        UIImage *image = [[UIImage imageNamed:img[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [[UIImage imageNamed:imgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:nil image:image selectedImage:selectImage];
        item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
        
        self.viewControllers[i].tabBarItem = item;
        
        
        
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
