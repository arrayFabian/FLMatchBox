//
//  FLTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLTopicVC.h"
#import "FLTopicCell.h"
#import "FLTopicModel.h"

#import "FLHeaderScrollView.h"


#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#import "FLHttpTool.h"

@interface FLTopicVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *kupdatetableView;

@property (weak, nonatomic) IBOutlet UITableView *ktableView;
@property (weak, nonatomic) IBOutlet UITableView *knewtableView;
@property (weak, nonatomic) IBOutlet UIView *chooseBtnView;
@property (weak, nonatomic) IBOutlet UIButton *btnTopicNew;
@property (weak, nonatomic) IBOutlet UIButton *btnTopicUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lbMoveLine;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;




@property (nonatomic, strong) NSMutableArray *fountArr;
@property (nonatomic, assign) NSUInteger foundIndex;

@property (nonatomic, strong) NSMutableArray *knewArr;
@property (nonatomic, assign) NSUInteger knewIndex;

@property (nonatomic, strong) NSMutableArray *kupdateArr;
@property (nonatomic, assign) NSUInteger kupdateIndex;




@end

@implementation FLTopicVC
- (IBAction)segmentValueChange:(id)sender
{
    if (self.segment.selectedSegmentIndex == 1 ) {
        
        if (self.btnTopicNew.selected) {
            [self.view bringSubviewToFront:self.knewtableView];
        }else{
            [self.view bringSubviewToFront:self.kupdatetableView];
        }
        
        [self.view bringSubviewToFront:self.chooseBtnView];
        

    }else{
        [self.view bringSubviewToFront:self.ktableView];
        
    }
    
    
    
    
}

- (IBAction)btnTopicNewClick:(id)sender
{
    self.btnTopicNew.selected = YES;
    self.btnTopicUpdate.selected = NO;
    self.lbMoveLine.transform = CGAffineTransformIdentity;
   
    [self.view bringSubviewToFront:self.knewtableView];

    
    
}
- (IBAction)btnTopicUpdateClick:(id)sender
{
    self.btnTopicNew.selected = NO;
    self.btnTopicUpdate.selected = YES;
    self.lbMoveLine.transform = CGAffineTransformMakeTranslation(self.lbMoveLine.width, 0);
    [self.view bringSubviewToFront:self.kupdatetableView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
     FLLog(@"%s",__func__);
    
    [self initData];
    
    [self initUI];
    
    
    [self setUpRefresh];
    
    
    
}

- (void)setUpRefresh
{
    //上拉刷新 下拉加载
    //数据处理：  下拉清空之前数据，把新得到的数据赋给数组； 上啦加载将请求到的数据添加进数组
    __weak __typeof(&*self) weakSelf = self;
    
    //ktableView
    self.ktableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _foundIndex = 1;
        [weakSelf loadFoundData];
        
    }];
    
    self.ktableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _foundIndex++;
        [weakSelf loadFoundData];
        
    }];

    
    //knewtableView
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _knewIndex = 1;
        [weakSelf loadNewData];
        
    }];
    NSMutableArray *imagesArr = [@[] mutableCopy];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"More%d.png",i]];
        [imagesArr addObject:image];
    }
    [header setImages:imagesArr forState:MJRefreshStateIdle];
    [header setImages:imagesArr forState:MJRefreshStatePulling];
    [header setImages:imagesArr forState:MJRefreshStateRefreshing];
    
    self.knewtableView.mj_header = header;
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _knewIndex++;
        [weakSelf loadNewData];
        
    }];
    [footer setImages:imagesArr forState:MJRefreshStateRefreshing];
    self.knewtableView.mj_footer = footer;
    
    
    //kupdatetableView
    self.kupdatetableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _kupdateIndex = 1;
        [weakSelf loadUpdateData];
        
    }];
    
    self.kupdatetableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _kupdateIndex++;
        [weakSelf loadUpdateData];
        
    }];

    //第一次自动创新
    [self.ktableView.mj_header beginRefreshing];
     [self.knewtableView.mj_header beginRefreshing];
     [self.kupdatetableView.mj_header beginRefreshing];
    

}

- (void)initUI
{
    //segment
    self.navigationItem.titleView.layer.cornerRadius = self.navigationItem.titleView.bounds.size.height/2.f;
    self.navigationItem.titleView.layer.masksToBounds = YES;
    self.navigationItem.titleView.layer.borderWidth = 1;
    self.navigationItem.titleView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    //table headerview
    FLHeaderScrollView *scrollView = [[FLHeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, self.ktableView.width, 150)];
    scrollView.itemsArr = @[@"logBanner1.jpg",@"logBanner2.jpg",@"logBanner3.jpg",@"logBanner4.jpg",@"logBanner5.jpg"];
    self.ktableView.tableHeaderView = scrollView;
   
    
    self.btnTopicNew.selected = YES;
    self.btnTopicUpdate.selected = NO;
    
}

- (void)initData
{
    _foundIndex = 1;
    _fountArr = [@[] mutableCopy];
    
    _knewIndex = 1;
    _knewArr = [@[] mutableCopy];
    
    _kupdateArr = [@[] mutableCopy];
    _kupdateIndex = 1;
   
}

//ktableView
- (void)loadFoundData
{
    NSDictionary *param = @{@"userId":@1,
                @"pageModel.pageSize":@10,
               @"pageModel.pageIndex":@(_foundIndex)};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetTopicListHot",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
       
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            NSArray *arr = dict[@"list"];
            if (arr.count == 0) {
                [weakSelf.ktableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
               
                if (_foundIndex == 1) {
                    [_fountArr removeAllObjects];
                }
                
                NSArray *modelArr = [FLTopicModel mj_objectArrayWithKeyValuesArray:arr];
                [_fountArr addObjectsFromArray:modelArr];

//                for (NSDictionary *dict in arr) {
//                    FLTopicModel *model = [FLTopicModel mj_objectWithKeyValues:dict];
//                    [_fountArr addObject:model];
//                }
                FLLog(@"fountArr:%@",_fountArr);


                [weakSelf.ktableView reloadData];

            }
            
            
        }
        [self.ktableView.mj_header endRefreshing];
        [self.ktableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.ktableView.mj_header endRefreshing];
        [self.ktableView.mj_footer endRefreshing];
        
    }];
    
    
}

//knewtableView
- (void)loadNewData
{
    NSDictionary *param = @{@"userId":@1,
                            @"pageModel.pageSize":@20,
                            @"pageModel.pageIndex":@(_knewIndex)};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetTopicListNew",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            NSArray *arr = dict[@"list"];
            if (arr.count == 0) {
                [weakSelf.knewtableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                if (_knewIndex == 1) {
                    [_knewArr removeAllObjects];
                }
                
                NSArray *modelArr = [FLTopicModel mj_objectArrayWithKeyValuesArray:arr];
                [_knewArr addObjectsFromArray:modelArr];
                FLLog(@"_knewArr %@",_knewArr);
                
                [weakSelf.knewtableView reloadData];
                
            }
            
        }
        [self.knewtableView.mj_header endRefreshing];
        [self.knewtableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.knewtableView.mj_header endRefreshing];
        [self.knewtableView.mj_footer endRefreshing];
        
    }];
    
    
}

//kupdatetableView
- (void)loadUpdateData
{
    NSDictionary *param = @{@"userId":@1,
                            @"pageModel.pageSize":@20,
                            @"pageModel.pageIndex":@(_kupdateIndex)};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetTopicListNew",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            NSArray *arr = dict[@"list"];
            if (arr.count == 0) {
                [weakSelf.kupdatetableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                if (_kupdateIndex == 1) {
                    [_kupdateArr removeAllObjects];
                }
                
                NSArray *modelArr = [FLTopicModel mj_objectArrayWithKeyValuesArray:arr];
                [_kupdateArr addObjectsFromArray:modelArr];
               
                
                [weakSelf.kupdatetableView reloadData];
                
            }
            
        }
        [self.kupdatetableView.mj_header endRefreshing];
        [self.kupdatetableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.kupdatetableView.mj_header endRefreshing];
        [self.kupdatetableView.mj_footer endRefreshing];
        
    }];
    
    
}



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


#pragma mark- tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma maek- tableview data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.ktableView) {
        return self.fountArr.count;
    }else if (tableView == self.knewtableView){
        return self.knewArr.count;
    }
    
   return self.kupdateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLTopicCell *cell = [FLTopicCell cellWithTableView:tableView];
    
    
    FLTopicModel *topicModel;
    if (tableView == self.ktableView) {
        topicModel = self.fountArr[indexPath.row];
    }else if (tableView == self.knewtableView){
         topicModel = self.knewArr[indexPath.row];
    }else if (tableView == self.kupdatetableView){
         topicModel = self.kupdateArr[indexPath.row];
    }

    cell.topicModel = topicModel;
    return cell;
}

@end
