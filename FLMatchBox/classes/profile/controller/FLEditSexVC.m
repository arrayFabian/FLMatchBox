//
//  FLEditSexVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLEditSexVC.h"
#import "FLAccountTool.h"
#import "FLUser.h"

#import "FLHttpTool.h"

@interface FLEditSexVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *femaleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *maleCell;

@property (nonatomic, strong)FLUser *user;

@end

@implementation FLEditSexVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FLUser *user = [FLAccountTool user];
    _user = user;
    if ([user.sex isEqualToString:@"男"]) {
        self.maleCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.femaleCell.accessoryType = UITableViewCellAccessoryNone;
    }else if ([user.sex isEqualToString:@"女"]){
        self.femaleCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.maleCell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        self.maleCell.accessoryType = UITableViewCellAccessoryNone;
        self.femaleCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.maleCell.selected == YES) {
        self.maleCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.femaleCell.accessoryType = UITableViewCellAccessoryNone;
        
        __weak __typeof(&*self) weakSelf = self;

        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] param:@{@"user.id":@(_user.userId),@"user.userName":_user.userName,@"user.sex":@"男",@"user.myInfo":_user.myInfo} success:^(id responseObject) {
           
            if ([responseObject[@"result"] integerValue] == 0) {
                
                _user.sex = @"男";
                [FLAccountTool saveUser:_user];
                
                //跳转
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];

        
        
    }
    if (self.femaleCell.selected == YES) {
        self.femaleCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.maleCell.accessoryType = UITableViewCellAccessoryNone;
        
        __weak __typeof(&*self) weakSelf = self;
        
        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] param:@{@"user.id":@(_user.userId),@"user.userName":_user.userName,@"user.sex":@"女",@"user.myInfo":_user.myInfo} success:^(id responseObject) {
            
            if ([responseObject[@"result"] integerValue] == 0) {
                
                _user.sex = @"女";
                [FLAccountTool saveUser:_user];
                
                //跳转
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];

    }
    
    
    
}


@end
