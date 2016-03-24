//
//  FLSetupTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSetupTopicVC.h"
#import "CunstomButton.h"

@interface FLSetupTopicVC ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet CunstomButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITableView *ktableView;









@end

@implementation FLSetupTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)nextBtnClick:(id)sender {
}
- (IBAction)continueBtnClick:(id)sender {
}
- (IBAction)reInputBtnClick:(id)sender {
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
