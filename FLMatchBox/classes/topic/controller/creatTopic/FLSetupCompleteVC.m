//
//  FLSetupCompleteVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSetupCompleteVC.h"

@interface FLSetupCompleteVC ()

@property (weak, nonatomic) IBOutlet CustomImageView *imgCreatSuccess;

@property (weak, nonatomic) IBOutlet CunstomButton *btnBackTopic;






@end

@implementation FLSetupCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //left
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalName:@"community_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -7, 0, 7);
}

- (void)pop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnBackTopicDidClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
