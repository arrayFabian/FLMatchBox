//
//  FLTopicDetailVC.m
//  FLMatchBox
//
//  Created by Mac on 16/4/2.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLTopicDetailVC.h"

#import "FLUser.h"
#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import <MJRefresh.h>
#import <MJExtension.h>

#import <UIImageView+WebCache.h>

#import "FLHttpTool.h"

@interface FLTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIButton *btnNew;
@property (weak, nonatomic) IBOutlet UIButton *btnHot;
@property (weak, nonatomic) IBOutlet UILabel *grayLine;
@property (weak, nonatomic) IBOutlet UILabel *moveLine;

@property (nonatomic, strong)UIScrollView  *scrollView;
@property (nonatomic, strong)UITableView   *lastTableview;
@property (nonatomic, strong)UITableView  *hotTableview;

@property (nonatomic, strong)NSMutableArray   *lastArr;
@property (nonatomic, strong)NSMutableArray  *hotArr;

@property (assign, nonatomic) NSInteger pageLatestIndex;
@property (assign, nonatomic) NSInteger pageHotIndex;
@property (assign, nonatomic) NSInteger pageSize;



@end

@implementation FLTopicDetailVC
- (IBAction)btnNewDidClick:(id)sender
{
    
    self.btnNew.selected = YES;
    self.btnHot.selected = NO;
    [UIView animateWithDuration:0.38 animations:^{
       self.moveLine.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
     [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
}
- (IBAction)btnHotDidClick:(id)sender
{
    self.btnNew.selected = NO;
    self.btnHot.selected = YES;
    [UIView animateWithDuration:0.38 animations:^{
        self.moveLine.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, self.view.width/2.0, 0);

    }];
    [self.scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];

  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"%ld",[self.topicId integerValue]);

    
    [self initUI];
    
    
    

}


- (void)initData
{
    _lastArr = [@[] mutableCopy];
    _hotArr = [@[] mutableCopy];
    
    _pageSize = 10;
    _pageHotIndex = 1;
    _pageLatestIndex = 1;
    
    
}

- (void)initUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,108 , self.view.width, self.view.height-108)];
    self.scrollView = scrollview;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.bounces = NO;
    scrollview.pagingEnabled = YES;
    scrollview.contentSize = CGSizeMake(scrollview.width*2, scrollview.height);
    scrollview.contentOffset = CGPointMake(0, 0);
    
    
    UITableView *lastTableview = [[UITableView alloc]initWithFrame:scrollview.bounds];
    [self.scrollView addSubview:lastTableview];
    self.lastTableview = lastTableview;
    lastTableview.backgroundColor = [UIColor whiteColor];
    lastTableview.delegate = self;
    lastTableview.dataSource = self;
    
    
    UITableView *hotTableview = [[UITableView alloc] initWithFrame:CGRectMake(scrollview.width, 0, scrollview.width, scrollview.height)];
    [self.scrollView addSubview:hotTableview];
    self.hotTableview = hotTableview;
    hotTableview.backgroundColor = [UIColor blackColor];
    hotTableview.dataSource = self;
    hotTableview.delegate = self;
    
    
  
    [self setUpRefresh];
    
    
    
}

- (void)setUpRefresh
{
    
    MJRefreshNormalHeader *mj_header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageLatestIndex = 1;
        [self loadLastData];
        
    }];
    self.lastTableview.mj_header = mj_header1;
    [mj_header1 beginRefreshing];
    
    MJRefreshAutoNormalFooter *mj_footer1 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageLatestIndex++;
        [self loadLastData];
    }];
    self.lastTableview.mj_footer = mj_footer1;
    
    MJRefreshNormalHeader *mj_header2 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageHotIndex = 1;
        [self loadHotData];
        
    }];
    self.hotTableview.mj_header = mj_header2;
    [mj_header2 beginRefreshing];
    
    MJRefreshAutoNormalFooter *mj_footer2 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageHotIndex++;
        [self loadHotData];
    }];
    self.hotTableview.mj_footer = mj_footer2;
    
}

//lasttableview
- (void)loadLastData
{
    /*
    NSDictionary *param = @{@"userId":@(kUserModel.userId)};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetIsNewFriendCircle",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"List"];
            if (arr.count == 0) {
                [weakSelf.friendTableView.mj_header endRefreshing];
                [weakSelf.friendTableView.mj_footer endRefreshing];
                
                return ;
            }else{
                
                _friendsArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                
                
                //                for (NSDictionary *dict in arr) {
                //                    FLTopicModel *model = [FLTopicModel mj_objectWithKeyValues:dict];
                //                    [_fountArr addObject:model];
                //                }
                
                
                [weakSelf.friendTableView reloadData];
                
            }
            
        }
        
        [weakSelf.friendTableView.mj_header endRefreshing];
        [weakSelf.friendTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.friendTableView.mj_header endRefreshing];
        [weakSelf.friendTableView.mj_footer endRefreshing];
        
    }];
    */
    
}

//hottableview
- (void)loadHotData
{
    /*
    NSDictionary *param = @{@"userId":@(kUserModel.userId),
                            @"topicId":@(2)};
    ///Matchbox/usergetMyActionTopIcByUserId
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetFriendCircles",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            
            NSArray *arr = dict[@"List"];
            if (arr.count == 0) {
                [weakSelf.likeTableView.mj_header endRefreshing];
                [weakSelf.likeTableView.mj_footer endRefreshing];
                
                return ;
            }else{
                
                _likesArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                [weakSelf.likeTableView reloadData];
                
            }
            
        }
        [weakSelf.likeTableView.mj_header endRefreshing];
        [weakSelf.likeTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.likeTableView.mj_header endRefreshing];
        [weakSelf.likeTableView.mj_footer endRefreshing];
        
    }];
    
    */
}





#pragma mark- tableview delegate

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.lastTableview) {
        return self.lastArr.count;
    }if (tableView == self.hotTableview) {
        return self.hotArr.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLPostCellModel *cellModel = tableView == self.lastTableview? self.lastArr[indexPath.row]:self.hotArr[indexPath.row];
    
    
    FLPostCell *cell = [FLPostCell cellWithTableView:tableView model:cellModel];
    
    return cell;
    
}

#pragma mark- scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        if (scrollView.contentOffset.x == 0) {
            self.btnNew.selected = YES;
            self.btnHot.selected = NO;
            
            
            [UIView animateWithDuration:0.38 animations:^{
               self.moveLine.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                
            }];
            
        }else{
            self.btnNew.selected = NO;
            self.btnHot.selected = YES;
            [UIView animateWithDuration:0.38 animations:^{
                self.moveLine.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,self.view.width, 0);
                
            }];
            
            
        }
        
        
    }
}



@end
