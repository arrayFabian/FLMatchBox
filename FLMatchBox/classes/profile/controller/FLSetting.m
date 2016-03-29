//
//  FLSetting.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/28.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSetting.h"

@interface FLSetting ()

@property (weak, nonatomic) IBOutlet UILabel *lbTextFont;
@property (weak, nonatomic) IBOutlet UILabel *lbCache;

@property (weak, nonatomic) IBOutlet UILabel *lbVersion;




@end

@implementation FLSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
