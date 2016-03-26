//
//  FLLikeTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLLikeTopicVC.h"

@interface FLLikeTopicVC ()

@end

@implementation FLLikeTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (IBAction)completeGotoMainVC:(id)sender {
    
    FLKeyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLTabBarController"];
    
}


@end
