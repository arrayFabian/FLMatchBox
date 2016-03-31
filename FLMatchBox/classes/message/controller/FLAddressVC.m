//
//  FLAddressVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAddressVC.h"

#import "FLAddressCell.h"
#import "FLAddressCellModel.h"
#import "FLAddressView.h"

#import "FLHttpTool.h"

#import "FLUser.h"
#import <MJExtension.h>



@interface FLAddressVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *ktableview;


@property (nonatomic, strong) NSMutableArray *followArr;
@property (nonatomic, strong) NSMutableArray *fansArr;


@property (nonatomic, strong) FLAddressView *popView;

@end

@implementation FLAddressVC

- (FLAddressView *)popView
{
    if (_popView == nil) {
        _popView = [[[NSBundle mainBundle] loadNibNamed:@"FLAddressView" owner:nil options:nil] lastObject];
        
    }
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isFollowVC) {
        
        self.navigationItem.titleView = nil;
        self.title = @"关注";
    }else if (self.isFansVC){
        self.navigationItem.titleView = nil;
        self.title = @"粉丝";
    }else{
        [self initSegment];
    }
   
    [self initData];

    
}



- (IBAction)segementValueChange:(id)sender
{
    [self.ktableview reloadData];
}

- (void)initData
{
    _followArr = [@[] mutableCopy];
    _fansArr = [@[] mutableCopy];
    
  
    
    [self loadNewData];
}

- (void)loadNewData
{
    __weak typeof (self) weakSelf = self;
    //关注
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetMyAction",BaseUrl] param:@{@"userId":@(kUserModel.userId)} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"Firends"];
            self.followArr = [FLAddressCellModel mj_objectArrayWithKeyValuesArray:arr];
            
            
            [weakSelf.ktableview reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    //粉丝
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetMyFans",BaseUrl] param:@{@"userId":@(kUserModel.userId)} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"Firends"];
            self.fansArr = [FLAddressCellModel mj_objectArrayWithKeyValuesArray:arr];
            
            
            [weakSelf.ktableview reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];

    
    
    
}


- (void)initSegment
{
    self.navigationItem.titleView.layer.cornerRadius = self.navigationItem.titleView.bounds.size.height/2.f;
    self.navigationItem.titleView.layer.masksToBounds = YES;
    self.navigationItem.titleView.layer.borderWidth = 1;
    self.navigationItem.titleView.layer.borderColor = [[UIColor blackColor]CGColor];
    
}



#pragma mark- tabelview delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    FLAddressCellModel *model =  self.segment.selectedSegmentIndex == 0? self.followArr[indexPath.row]:self.fansArr[indexPath.row];
    self.popView.model = model;
    
    [self.view.window addSubview:self.popView];
    
}

#pragma mark- tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
   return self.segment.selectedSegmentIndex == 0 ? self.followArr.count : self.fansArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLAddressCell *cell =[FLAddressCell cellWithTableview:tableView];
    
    FLAddressCellModel *model = self.segment.selectedSegmentIndex == 0? self.followArr[indexPath.row]:self.fansArr[indexPath.row];
    cell.cellModel = model;
    
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"footer";
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"header";
//}

//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return @[@"A",@"B",@"C",@"D",];
//}



@end
