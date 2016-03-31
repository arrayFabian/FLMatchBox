//
//  FLCollectionVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLCollectionVC.h"

@interface FLCollectionVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@end

@implementation FLCollectionVC
- (IBAction)btnEditClick:(id)sender
{
    self.btnEdit.selected = !self.btnEdit.selected;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    
}


@end
