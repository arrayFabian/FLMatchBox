//
//  TopUserVC.m
//  MatchBox
//
//  Created by whunf on 16/3/31.
//  Copyright © 2016年 whunf. All rights reserved.
//

#import "TopUserVC.h"
#import "FLTopUserModel.h"
#import <UIImageView+WebCache.h>
#import "FLOtherUserVC.h"
@interface TopUserVC ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation TopUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initUI];
}

- (void)initUI {
    self.title = @"点赞";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [[UIView alloc]init];
}

/******************** tableview delegate *********************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topUserModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"UITableViewCellStyleSubtitle";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        UIImageView * myImgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 44, 44)];
        myImgaeView.layer.masksToBounds = YES;
        myImgaeView.layer.cornerRadius = 22;
        myImgaeView.tag = 10;
        [cell.contentView addSubview:myImgaeView];
        
        UILabel * lbName = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, self.view.bounds.size.width-68, 20)];
        lbName.textColor = MAINCOLOR;
        lbName.font = [UIFont systemFontOfSize:15];
        lbName.tag = 11;
        [cell.contentView addSubview:lbName];
        
        UILabel * lbID = [[UILabel alloc]initWithFrame:CGRectMake(60, 36, self.view.bounds.size.width-68, 15)];
        lbID.textColor = MAINCOLOR;
        lbID.font = [UIFont systemFontOfSize:10];
        lbID.tag = 12;
        [cell.contentView addSubview:lbID];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    FLTopUserModel * model = _topUserModelArr[indexPath.row];
    UIImageView * imageV = [cell viewWithTag:10];
    NSString * url = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,model.userImg];
    [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    UILabel * lbName = [cell viewWithTag:11];
    lbName.text = model.userName;
    UILabel * lbID = [cell viewWithTag:12];
    lbID.text = [NSString stringWithFormat:@"ID:%ld",(long)model.userId];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLOtherUserVC * vc =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FLOtherUserVC"];
    FLTopUserModel * model = _topUserModelArr[indexPath.row];
    vc.otherUserId = model.userId;
    vc.otherUserName = model.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
