//
//  FLChooseTypeVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLChooseTypeVC.h"

@interface FLChooseTypeVC ()

@property (weak, nonatomic) IBOutlet UITableViewCell *picTopicCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *textTopicCell;




@end

@implementation FLChooseTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
}



#pragma mark- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLLog(@"%s",__func__);
    
    BOOL isPicType;
    if (self.picTopicCell.selected) {
        isPicType = YES;
    }else if (self.textTopicCell.selected){
        isPicType = NO;
    }
     [self performSegueWithIdentifier:@"FLSetupTopicVC" sender:@(isPicType)];
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ( [segue.identifier isEqualToString:@"FLSetupTopicVC"]) {
        
        id vc = segue.destinationViewController;
        [vc setValue:sender forKeyPath:@"isPicType"];
        
        
        
    }
   


}


@end
