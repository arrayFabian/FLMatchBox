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

#import "FLOtherUserVC.h"

#import "FLUser.h"
#import <MJExtension.h>



@interface FLAddressVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,FLAddressViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *ktableview;

@property (weak, nonatomic) IBOutlet UIView *searchBarPlaceHoldView;


@property (nonatomic, strong) NSMutableArray *followArr;
@property (nonatomic, strong) NSMutableArray *fansArr;

@property (nonatomic, strong) NSMutableDictionary *followFitDict;
@property (nonatomic, strong) NSMutableArray *followIndex;

@property (nonatomic, strong) NSMutableDictionary *fansFitDict;
@property (nonatomic, strong) NSMutableArray *fansIndex;

@property (nonatomic, strong) NSMutableArray *searchFollowArr;
@property (nonatomic, strong) NSMutableArray *searchFansArr;

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
    
    _followArr = [@[] mutableCopy];
    _fansArr = [@[] mutableCopy];
    
    _searchFollowArr = [@[] mutableCopy];
    _searchFansArr = [@[] mutableCopy];
   
    [self initUI];
    
    
    
    if (self.isFollowVC) {
        
        [self loadFollowData];
    }else if (self.isFansVC){
        
      [self loadFansData];
        
    }else{
          [self loadFollowData];
        [self loadFansData];
    }


    
    
}

- (void)initUI
{
    [self initSearchBarController];

    if (self.isFollowVC) {
        
        self.navigationItem.titleView = nil;
        self.title = @"关注";
        self.searchController.searchBar.placeholder = @"搜索关注";
        
    }else if (self.isFansVC){
        
        self.navigationItem.titleView = nil;
        self.title = @"粉丝";
         self.searchController.searchBar.placeholder = @"搜索粉丝";
        
    }else{
        [self initSegment];
    }

    self.ktableview.sectionIndexColor = MAINCOLOR;
    self.ktableview.sectionIndexBackgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //当行数较少时，去除多余的线
   UIView *footerview = [[UIView alloc]init];
    footerview.backgroundColor = [UIColor clearColor];
    self.ktableview.tableFooterView = footerview;
    
    
   
}



- (void)initSearchBarController
{
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController = searchController;
    
    searchController.dimsBackgroundDuringPresentation = NO;
    
    searchController.delegate = self;
    searchController.searchResultsUpdater = self;
    searchController.searchBar.placeholder = @"搜索粉丝/关注";
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [searchController .searchBar sizeToFit];
    
    [self.searchBarPlaceHoldView addSubview:searchController.searchBar];
    searchController.searchBar.frame = CGRectMake(0, 0, self.view.width, 44);
  
    self.definesPresentationContext = YES;
    
   
    

}

- (IBAction)segementValueChange:(id)sender
{
    [self.ktableview reloadData];
}



- (void)loadFollowData
{
    __weak typeof (self) weakSelf = self;
    //关注
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetMyAction",BaseUrl] param:@{@"userId":@(kUserModel.userId)} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"Firends"];
            //1. 根据userName设置其首字母 重写setter方法
            
            
            for (NSDictionary *dict in arr) {
                FLAddressCellModel *model = [[FLAddressCellModel alloc] initWithDict:dict];
                [_followArr addObject:model];
            }
            
            /**
             *
             @[@"#",@"A",@"v",@"x"];
             
             @{
             @"A":@[model1,model2],
             @"V":@[model4,model3];
             }
             */

             // 2.开始分组
            
           
            _followIndex = [@[] mutableCopy];
           _followFitDict = [@{} mutableCopy];
            
            NSString *base = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            for (FLAddressCellModel *model in _followArr) {
                // 2.1 判断是否是正常的ABC
                if ([base rangeOfString:model.aleph].length > 0) {//正常的ABC
                    
                    NSMutableArray *arr = _followFitDict[model.aleph];
                    
                    if (!arr) {
                        arr = [NSMutableArray arrayWithObject:model];
                        [_followFitDict setObject:arr forKey:model.aleph];
                        [_followIndex addObject:model.aleph];
                        
                    }else{
                        
                        [arr addObject:model];
                        
                        
                    }
                }else{// # , . _
                    
                    NSMutableArray *sArr = _followFitDict[@"#"];
                    if (!sArr) {
                        sArr = [NSMutableArray arrayWithObject:model];
                        [_followFitDict setObject:sArr forKey:@"#"];
                        [_followIndex insertObject:@"#" atIndex:0];
                        
                    }else{
                        [sArr addObject:model];
                    }
                    
                }
                
            }
            
              NSLog(@"%@------%@",_followIndex,_followFitDict);
             [_followIndex sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                 return [obj1 compare:obj2];
                
            }];
            NSLog(@"%@------%@",_followIndex,_followFitDict);
            
            [weakSelf.ktableview reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (void)loadFansData
{
    
    //粉丝
    
       __weak typeof (self) weakSelf = self;

        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetMyFans",BaseUrl] param:@{@"userId":@(kUserModel.userId)} success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dict = responseObject;
            if ([dict[@"result"] integerValue] == 0) {
    
                NSArray *arr = dict[@"Firends"];
    
    
                for (NSDictionary *dict in arr) {
                    FLAddressCellModel *model = [[FLAddressCellModel alloc] initWithDict:dict];
                    [_fansArr addObject:model];
                }
    
    
                // 2.开始分组
                
                
                _fansIndex = [@[] mutableCopy];
                _fansFitDict = [@{} mutableCopy];
                
                NSString *base = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                for (FLAddressCellModel *model in _fansArr) {
                    // 2.1 判断是否是正常的ABC
                    if ([base rangeOfString:model.aleph].length > 0) {//正常的ABC
                        
                        NSMutableArray *arr = _fansFitDict[model.aleph];
                        
                        if (!arr) {
                            arr = [NSMutableArray arrayWithObject:model];
                            [_fansFitDict setObject:arr forKey:model.aleph];
                            [_fansIndex addObject:model.aleph];
                            
                        }else{
                            
                            [arr addObject:model];
                            
                            
                        }
                    }else{// # , . _
                        
                        NSMutableArray *sArr = _fansFitDict[@"#"];
                        if (!sArr) {
                            sArr = [NSMutableArray arrayWithObject:model];
                            [_fansFitDict setObject:sArr forKey:@"#"];
                            [_fansIndex insertObject:@"#" atIndex:0];
                            
                        }else{
                            [sArr addObject:model];
                        }
                        
                    }
                    
                }
                
                
                [_fansIndex sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [obj1 compare:obj2];
                    
                }];
               
                
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
    FLAddressCellModel *model;
    if (self.isFollowVC) {
        model = _searchController.isActive ? _searchFollowArr[indexPath.row]: [self.followFitDict[self.followIndex[indexPath.section]] objectAtIndex:indexPath.row];
        
        
    }else if (self.isFansVC){
        
        model = _searchController.isActive? _searchFansArr[indexPath.row] :[self.fansFitDict[self.fansIndex[indexPath.section]] objectAtIndex:indexPath.row];
        
    }else{
        
        if (_searchController.isActive) {
            if (indexPath.section == 0) {
                model = _searchFollowArr[indexPath.row];
            }else{
                model = _searchFansArr[indexPath.row];
            }
            
            
        }else{
            
            model = self.segment.selectedSegmentIndex == 0? [self.followFitDict[self.followIndex[indexPath.section]] objectAtIndex:indexPath.row]:[self.fansFitDict[self.fansIndex[indexPath.section]] objectAtIndex:indexPath.row];
            
        }
        
        
    }
    
    self.popView.model = model;
    self.popView.delegate = self;
    
    [self.view.window addSubview:self.popView];
    
}

#pragma mark- tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (self.isFollowVC) {
        return  self.searchController.isActive?1: _followIndex.count;
        
    }else if (self.isFansVC){
        
        return self.searchController.isActive? 1 : _fansIndex.count;
        
    }else if (self.searchController.isActive) {
        
        return 2;
    }
    
        return self.segment.selectedSegmentIndex == 0 ? _followIndex.count:_fansIndex.count;
    
    

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.isFollowVC) {
        return _searchController.isActive? _searchFollowArr.count: [self.followFitDict[self.followIndex[section]] count];
       
        
    }else if (self.isFansVC){
        return _searchController.isActive? _searchFansArr.count : [self.fansFitDict[self.fansIndex[section]] count];
       
        
    }
    
    if (self.searchController.isActive) {
        
        if (section == 0) {
            return _searchFollowArr.count;
        }else{
            return _searchFansArr.count;
        }
    }


    
    return self.segment.selectedSegmentIndex == 0 ? [self.followFitDict[self.followIndex[section]] count] : [self.fansFitDict[self.fansIndex[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLAddressCell *cell =[FLAddressCell cellWithTableview:tableView];
    
    FLAddressCellModel *model;
    if (self.isFollowVC) {
        model = _searchController.isActive ? _searchFollowArr[indexPath.row]: [self.followFitDict[self.followIndex[indexPath.section]] objectAtIndex:indexPath.row];
        
        
    }else if (self.isFansVC){
        
        model = _searchController.isActive? _searchFansArr[indexPath.row] :[self.fansFitDict[self.fansIndex[indexPath.section]] objectAtIndex:indexPath.row];
        
    }else{
        
        if (_searchController.isActive) {
            if (indexPath.section == 0) {
                model = _searchFollowArr[indexPath.row];
            }else{
                model = _searchFansArr[indexPath.row];
            }
            
            
        }else{
        
        model = self.segment.selectedSegmentIndex == 0? [self.followFitDict[self.followIndex[indexPath.section]] objectAtIndex:indexPath.row]:[self.fansFitDict[self.fansIndex[indexPath.section]] objectAtIndex:indexPath.row];
        
        }
        
        
    }
    

    cell.cellModel = model;
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isFollowVC) {
        return _searchController.isActive ? @"关注": self.followIndex[section];
        
    }else if (self.isFansVC){
        
        return _searchController.isActive ? @"粉丝": self.fansIndex[section];
    }else if (!_searchController.isActive){
        return self.segment.selectedSegmentIndex == 0 ?self.followIndex[section]:self.fansIndex[section];

    }else{
    
        if (self.searchController.isActive && self.searchFollowArr.count > 0 && section == 0) {
            return @"关注";
        }else if (self.searchController.isActive && self.searchFansArr.count > 0 && section == 1){
            return @"粉丝";
        }
    }
    
    return nil;
    
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.isActive) {
        
        if (self.isFollowVC ) {
            return  self.followIndex;
            
        }else if (self.isFansVC){
            return self.fansIndex;
            
        }
        return self.segment.selectedSegmentIndex == 0 ? self.followIndex:self.fansIndex;
        
    }
    
    return nil;

   
}


#pragma mark- searchcontroller update
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchString = [self.searchController.searchBar text];
    NSLog(@"%@",searchString);
    [_searchFollowArr removeAllObjects];
    [_searchFansArr removeAllObjects];
    
    if (self.isFollowVC) {
        for (FLAddressCellModel *model in self.followArr) {
            if ([model.userName rangeOfString:searchString].length > 0) {
                [self.searchFollowArr addObject:model];
                
                
            }
        }

        
    }else if (self.isFansVC){
        for (FLAddressCellModel *model in self.fansArr) {
            if ([model.userName rangeOfString:searchString].length > 0) {
                [self.searchFansArr addObject:model];
            }
        }

        
        
    }else{
       
        for (FLAddressCellModel *model in self.followArr) {
            if ([model.userName rangeOfString:searchString].length > 0) {
                [self.searchFollowArr addObject:model];
                
                
            }
        }
        
        for (FLAddressCellModel *model in self.fansArr) {
            if ([model.userName rangeOfString:searchString].length > 0) {
                [self.searchFansArr addObject:model];
                
                
            }
        }

        
    }

    
    
    [self.ktableview reloadData];
    
}

#pragma mark- FLAddressViewDelegate
- (void)addressView:(FLAddressView *)addressCell btnHomeDidClick:(FLAddressCellModel *)model
{
     [self.popView removeFromSuperview];
    
    
    FLOtherUserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLOtherUserVC"];
    vc.addressModel = model;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)addressView:(FLAddressView *)addressCell btnChatDidClick:(FLAddressCellModel *)model
{
    [self.popView removeFromSuperview];
    
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = model.userName?model.userName:[NSString stringWithFormat:@"%ld",model.userId];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
