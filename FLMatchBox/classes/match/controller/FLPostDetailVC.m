//
//  FLPostDetailVC.m
//  FLMatchBox
//
//  Created by Mac on 16/4/2.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostDetailVC.h"


#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import "FLHttpTool.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MJExtension.h>



@interface FLPostDetailVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) UITableView *tableview;

@property (nonatomic, weak) FLPostCell *tableHeader;

@property (nonatomic, weak) UIView *toolView;

@property (nonatomic, weak) UIView *sectionHeader;


@property (nonatomic, strong) NSMutableArray *retweetArr;
@property (nonatomic, strong) NSMutableArray *commentArr;

@end

@implementation FLPostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _retweetArr = [@[] mutableCopy];
    _commentArr = [@[] mutableCopy];
    
    
    [self initUI];
   
    
    
}

- (void)initUI
{
    [self initTableView];
}

- (void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
//    tableview.rowHeight = UITableViewAutomaticDimension;
//    tableview.estimatedRowHeight = 80;
    tableview.rowHeight = 44;
    
    FLPostCell *tableHeader = [[[NSBundle mainBundle] loadNibNamed:@"FLPostCell" owner:nil options:nil] firstObject];
    tableHeader.isCellInPostDetail = YES;
    tableHeader.cellmodel = _cellModel;
    
    self.tableHeader = tableHeader;
    self.tableview.tableHeaderView = tableHeader;
    
    
}

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell23";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    
    return cell;
    
    
}




#pragma mark- tableview delegate



@end
