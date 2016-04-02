//
//  FLPreSetupTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPreSetupTopicVC.h"
#import "CunstomButton.h"
@interface FLPreSetupTopicVC ()

@property (weak, nonatomic) IBOutlet CunstomButton *linkphoneBtn;
@property (weak, nonatomic) IBOutlet CunstomButton *followBtn;
@property (weak, nonatomic) IBOutlet CunstomButton *countBtn;

@property (weak, nonatomic) IBOutlet CunstomButton *setUpBtn;

@end

@implementation FLPreSetupTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self initUI];
    
}



- (void)initUI
{
    
    self.countBtn.adjustsImageWhenHighlighted = NO;
    self.followBtn.adjustsImageWhenHighlighted = NO;
    self.linkphoneBtn.adjustsImageWhenHighlighted = NO;
    
    
    if (self.linkphoneBtn.enabled && self.followBtn.enabled && self.countBtn.enabled) {
        self.setUpBtn.enabled = YES;
    }else{
        self.setUpBtn.enabled = NO;
    }
}


- (IBAction)setupBtnDidClick:(CunstomButton *)sender {
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
