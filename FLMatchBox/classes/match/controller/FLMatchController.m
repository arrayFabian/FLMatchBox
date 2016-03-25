//
//  FLMatchController.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/16.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLMatchController.h"

#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

#import "FLHttpTool.h"

@interface FLMatchController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong)UIScrollView *scrollview;

@property (nonatomic, strong)UITableView *friendTableView;

@property (nonatomic, strong)UITableView *likeTableView;


@property (nonatomic, strong)NSMutableArray *friendsArr;

@property (nonatomic, strong)NSMutableArray *likesArr;

@end

@implementation FLMatchController

- (IBAction)segmentValueChange:(id)sender
{
    if (self.segment.selectedSegmentIndex == 0) {
        [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else{
        
        [self.scrollview setContentOffset:CGPointMake(_scrollview.width, 0) animated:YES];
        
    }
 
}


- (void)viewDidLoad {
    [super viewDidLoad];
     FLLog(@"%s",__func__);
   
    [self initData];
    
    [self initUI];
    
    [self setUpRefresh];
    
    
    
}

- (void)initData
{
    _friendsArr = [@[] mutableCopy];
    _likesArr = [@[] mutableCopy];
}

- (void)setUpRefresh
{
    //上拉刷新 下拉加载
    //数据处理：  下拉清空之前数据，把新得到的数据赋给数组； 上啦加载将请求到的数据添加进数组
    __weak __typeof(&*self) weakSelf = self;
    
    self.friendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
      
        [weakSelf loadFriendData];
        
    }];
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadLikeData];
        
    }];
    NSMutableArray *imagesArr = [@[] mutableCopy];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"More%d.png",i]];
        [imagesArr addObject:image];
    }
    [header setImages:imagesArr forState:MJRefreshStateIdle];
    [header setImages:imagesArr forState:MJRefreshStatePulling];
    [header setImages:imagesArr forState:MJRefreshStateRefreshing];
    
    self.likeTableView.mj_header = header;
    
    //第一次自动创新
    [self.friendTableView.mj_header beginRefreshing];
    
    
    self.friendTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
       
        [weakSelf loadFriendData];
        
    }];
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
       
        [weakSelf loadLikeData];
    }];
    [footer setImages:imagesArr forState:MJRefreshStateRefreshing];
    self.likeTableView.mj_footer = footer;
    
}



- (void)initUI
{
    //segment
    self.navigationItem.titleView.layer.cornerRadius = self.navigationItem.titleView.bounds.size.height/2.f;
    self.navigationItem.titleView.layer.masksToBounds = YES;
    self.navigationItem.titleView.layer.borderWidth = 1;
    self.navigationItem.titleView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    //scrollview
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-44)];
    [self.view addSubview:scrollview];
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(scrollview.width * 2, scrollview.height);
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.bounces = NO;
    _scrollview = scrollview;
    
    //tableview
    UITableView *friendTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _scrollview.width, _scrollview.height)];
    [_scrollview addSubview:friendTableview];
    _friendTableView = friendTableview;
    
    friendTableview.dataSource = self;
    friendTableview.delegate = self;
    friendTableview.rowHeight = UITableViewAutomaticDimension;
    friendTableview.estimatedRowHeight = 457;
    
    UITableView *likeTableview = [[UITableView alloc]initWithFrame:CGRectMake(_scrollview.width, 0, _scrollview.width, _scrollview.height)];
    [_scrollview addSubview:likeTableview];
    _likeTableView = likeTableview;
   
    likeTableview.dataSource = self;
    likeTableview.delegate = self;
    likeTableview.rowHeight = UITableViewAutomaticDimension;
    likeTableview.estimatedRowHeight = 457;

}

//friend tableview
- (void)loadFriendData
{
    NSDictionary *param = @{@"userId":@1};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetMyFriendPost",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([dict[@"result"] integerValue] == 0) {
            NSArray *arr = dict[@"List"];
            if (arr.count == 0) {
                [weakSelf.friendTableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                NSArray *modelArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                _friendsArr = [modelArr mutableCopy];;
                
                //                for (NSDictionary *dict in arr) {
                //                    FLTopicModel *model = [FLTopicModel mj_objectWithKeyValues:dict];
                //                    [_fountArr addObject:model];
                //                }
                
                
                [weakSelf.friendTableView reloadData];
                
            }
        
        }
        
        [self.friendTableView.mj_header endRefreshing];
        [self.friendTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.friendTableView.mj_header endRefreshing];
        [self.friendTableView.mj_footer endRefreshing];
        
    }];
    
    
}

//like tableview
- (void)loadLikeData
{
    
    NSDictionary *param = @{@"userId":@1,
                            @"topicId":@2
                            };
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetFriendCircles",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
       
        
        if ([dict[@"result"] integerValue] == 0) {
            NSArray *arr = dict[@"List"];
            if (arr.count == 0) {
                [weakSelf.likeTableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                 NSArray *modelArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                
                _likesArr = [modelArr mutableCopy];
                
                [weakSelf.likeTableView reloadData];
                
            }
            
        }
        [self.likeTableView.mj_header endRefreshing];
        [self.likeTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.likeTableView.mj_header endRefreshing];
        [self.likeTableView.mj_footer endRefreshing];
        
    }];
    
    
}


#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.friendTableView) {
        return self.friendsArr.count;
    }
    return self.likesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLPostCellModel *model = tableView == self.friendTableView ? self.friendsArr[indexPath.row]:self.likesArr[indexPath.row];
    
    FLPostCell *cell = [FLPostCell cellWithTableView:tableView model:model];
    
    return cell;
    
    
}

#pragma mark- tableview delegate



#pragma mark- scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     FLLog(@"%s",__func__);
    if (scrollView == self.scrollview) {
        
        if (scrollView.contentOffset.x == 0) {
            self.segment.selectedSegmentIndex = 0;
        }else if(scrollView.contentOffset.x == _scrollview.width){
            self.segment.selectedSegmentIndex = 1;
        }
    }
}



#pragma mark- live method
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FLLog(@"%s",__func__);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    FLLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    FLLog(@"%s",__func__);
}

- (void)dealloc
{
    FLLog(@"%s",__func__);
}



@end
