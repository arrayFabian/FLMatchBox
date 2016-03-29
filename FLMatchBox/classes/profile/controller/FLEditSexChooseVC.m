//
//  FLEditSexChooseVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLEditSexChooseVC.h"



@interface FLEditSexChooseVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *otherSexCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sameSexCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *bothSexCell;



@end

@implementation FLEditSexChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([self.sexChoose isEqualToString:@"异性"]) {
        self.otherSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if ([self.sexChoose isEqualToString:@"同性"]){
        self.sameSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if ([self.sexChoose isEqualToString:@"双性"]){
        self.bothSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0) {
        
        self.otherSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.sameSexCell.accessoryType = UITableViewCellAccessoryNone;
        self.bothSexCell.accessoryType = UITableViewCellAccessoryNone;
        self.sexChoose = @"异性";
        
    }else if (indexPath.row == 1){
        self.otherSexCell.accessoryType = UITableViewCellAccessoryNone;
        self.sameSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.bothSexCell.accessoryType = UITableViewCellAccessoryNone;
        
         self.sexChoose = @"同性";
    }else{
        self.otherSexCell.accessoryType = UITableViewCellAccessoryNone;
        self.sameSexCell.accessoryType = UITableViewCellAccessoryNone;
        self.bothSexCell.accessoryType = UITableViewCellAccessoryCheckmark;
       self.sexChoose = @"双性";
        
    }
    
    if ([self.delegate respondsToSelector:@selector(passValue:)]) {
        [self.delegate passValue:self.sexChoose];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}






@end
