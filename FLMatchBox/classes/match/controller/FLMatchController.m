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
#import "FLUser.h"

#import <MJRefresh/MJRefresh.h>

#import <MJExtension/MJExtension.h>

#import "FLHttpTool.h"
#import <MMPopupView.h>
#import <MMSheetView.h>
#import "ProgressView.h"
#import <UIImageView+WebCache.h>

@interface FLMatchController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FLPostCellModelDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong)UIScrollView *scrollview;

@property (nonatomic, strong)UITableView *friendTableView;
@property (nonatomic, strong)UITableView *likeTableView;
@property (nonatomic, strong)NSMutableArray *friendsArr;
@property (nonatomic, strong)NSMutableArray *likesArr;

@property (strong, nonatomic) UIButton  * imgBrowser;
@property (strong, nonatomic) UIScrollView * imageScrollView;
@property (strong, nonatomic) UIImageView * bigImageView;
@property (strong, nonatomic) ProgressView * progressview;

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
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [weakSelf loadFriendData];
        
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.friendTableView.mj_header = mj_header;
    
    MJRefreshAutoNormalFooter *mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [weakSelf loadFriendData];
        
    }];
    [mj_footer endRefreshingWithNoMoreData];
    mj_footer.automaticallyHidden = YES;
    self.friendTableView.mj_footer = mj_footer;
    
    
    
    MJRefreshNormalHeader *mj_header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadLikeData];
        
    }];
    mj_header1.lastUpdatedTimeLabel.hidden = YES;
    self.likeTableView.mj_header = mj_header1;
    
    MJRefreshAutoNormalFooter *mj_footer1 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadLikeData];
    }];
    [mj_footer1 endRefreshingWithNoMoreData];
    mj_footer1.automaticallyHidden = YES;
    self.likeTableView.mj_footer = mj_footer1;
    
    
    //第一次自动创新
    [self.friendTableView.mj_header beginRefreshing];
    [self.likeTableView.mj_header beginRefreshing];
    
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
    friendTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendTableview.rowHeight = UITableViewAutomaticDimension;
    friendTableview.estimatedRowHeight = 400;
    
    UITableView *likeTableview = [[UITableView alloc]initWithFrame:CGRectMake(_scrollview.width, 0, _scrollview.width, _scrollview.height)];
    [_scrollview addSubview:likeTableview];
    _likeTableView = likeTableview;
   
    likeTableview.dataSource = self;
    likeTableview.delegate = self;
    likeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    likeTableview.rowHeight = UITableViewAutomaticDimension;
    likeTableview.estimatedRowHeight = 400;

}

//friend tableview
- (void)loadFriendData
{
    NSDictionary *param = @{@"userId":@(kUserModel.userId)};
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetMyFriendPost",BaseUrl];
    
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
    
    
}

//like tableview
- (void)loadLikeData
{
    
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
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
    
    
}

#pragma mark- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //FLPostCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
}


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


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == _imageScrollView) {
        return _bigImageView;
    }
    
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == _imageScrollView) {
        
        CGFloat W = scrollView.contentSize.width > scrollView.bounds.size.width?scrollView.contentSize.width:scrollView.bounds.size.width;
        
        CGFloat H = scrollView.contentSize.height > scrollView.bounds.size.height?scrollView.contentSize.height:scrollView.bounds.size.height;
        _bigImageView.center = CGPointMake(W/2.0, H/2.0);
        
    }
    

    
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    
//}


#pragma mark- liveCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    FLLog(@"%s",__func__);
    
    [self initData];
    
    [self initUI];
    
    [self setUpRefresh];
    
    
    
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

#pragma mark- FLPostCellModelDelegate

- (void)postCell:(FLPostCell *)postCell btnCommentDidClick:(NSInteger)friendId
{
    FLLog(@"%s",__func__);
     FLLog(@"%ld",postCell.tag);
    [self performSegueWithIdentifier:@"FLPostDetailVC" sender:@(friendId)];
    
    
    
}
- (void)postCell:(FLPostCell *)postCell btnRetweetDidClick:(NSInteger)friendId
{
     FLLog(@"%s",__func__);
}

- (void)postCell:(FLPostCell *)postCell btnViewDidClick:(NSInteger)friendId
{
     FLLog(@"%s",__func__);
    //跳转到帖子详情
    
    [self performSegueWithIdentifier:@"FLPostDetailVC" sender:@(friendId)];
    
    
    
}

- (void)postCell:(FLPostCell *)postCell btnTopicDidClick:(FLPostCellModel *)cellModel
{
     FLLog(@"%s",__func__);
    //跳转到话题详情
    [self performSegueWithIdentifier:@"FLTopicDetailVC" sender:cellModel];
    
    
}

- (void)postCell:(FLPostCell *)postCell btnOperationDidClick:(FLPostCellModel *)cellModel
{
     FLLog(@"%s",__func__);
    //底部view 更多操作
    
    MMPopupItem *item1 = MMItemMake(@"取消关注", MMItemTypeNormal, ^(NSInteger index) {
        
        
        
        
    });
    
    MMPopupItem *item2 = MMItemMake(@"收藏帖子", MMItemTypeNormal, ^(NSInteger index) {
        
        
        
        
    });

    MMPopupItem *item3 = MMItemMake(@"分享至第三方", MMItemTypeNormal, ^(NSInteger index) {
        
        
        
        
    });

   
    
    MMSheetView *sheet = [[MMSheetView alloc]initWithTitle:nil items:@[item1,item2,item3]];
    
    [sheet show];
    
    
    
    
    
    
    
}

- (void)cancelImgae
{
    [self.imgBrowser removeFromSuperview];
}
- (void)downloadImage
{
    UIImageWriteToSavedPhotosAlbum(_bigImageView.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *photoSave = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [photoSave show];
        [photoSave dismissWithClickedButtonIndex:0 animated:YES];
        photoSave = nil;
        
        
        
    }else{
        UIAlertView *photoSave = [[UIAlertView alloc] initWithTitle:@"\n\n保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [photoSave show];
        [photoSave dismissWithClickedButtonIndex:0 animated:YES];
        photoSave = nil;

    }
}

- (void)postCell:(FLPostCell *)postCell imgViewTapped:(NSArray<Photolist *> *)photoList
{
     FLLog(@"%s",__func__);
    //查看大图
    //btn做背景 加scrollview 装imageview .
    
    if (!_imgBrowser) {
        _imgBrowser = [[UIButton alloc]initWithFrame:FLKeyWindow.bounds];
        _imgBrowser.backgroundColor = [UIColor blackColor];
       // [_imgBrowser addTarget:self action:@selector(cancelImgae)  forControlEvents:UIControlEventTouchUpInside];//不会起到效果
        
        _imageScrollView = [[UIScrollView alloc]initWithFrame:_imgBrowser.bounds];
        _imageScrollView.delegate = self;
        _imageScrollView.minimumZoomScale = 1;
        _imageScrollView.maximumZoomScale = 3.5f;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        [_imgBrowser addSubview:_imageScrollView];
        
        
        UIButton *btnCover = [[UIButton alloc]initWithFrame:_imgBrowser.bounds];
        [btnCover addTarget:self action:@selector(cancelImgae)  forControlEvents:UIControlEventTouchUpInside];
        [_imageScrollView addSubview:btnCover];

        
        
        _bigImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageScrollView addSubview:_bigImageView];

        
        
        UIButton *btnDownload = [[UIButton alloc]initWithFrame:CGRectMake(_imgBrowser.width/4.0-22, _imgBrowser.height-44, 44, 44)];
        [btnDownload setImage:[UIImage imageNamed:@"save_button"] forState:UIControlStateNormal];
        [btnDownload addTarget:self action:@selector(downloadImage) forControlEvents:UIControlEventTouchUpInside];
        [_imgBrowser addSubview:btnDownload];
        
        UIButton *btnCancle = [[UIButton alloc]initWithFrame:CGRectMake(3*_imgBrowser.width/4.0 -22 , _imgBrowser.height-44, 44, 44)];
        [btnCancle setImage:[UIImage imageNamed:@"MBScanCancel"] forState:UIControlStateNormal];
        [btnCancle addTarget:self action:@selector(cancelImgae) forControlEvents:UIControlEventTouchUpInside];
        [_imgBrowser addSubview:btnCancle];
        
        
        
        
        _progressview = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
       
    }
    
     _progressview.center = _imgBrowser.center;
    [_imgBrowser addSubview:_progressview];
    [FLKeyWindow addSubview:_imgBrowser];
    
    NSString *path = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,[photoList firstObject].url];
   // NSString *path1 = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,[cellmodel.photoList firstObject].imgUrl];
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        _progressview.persent = (CGFloat)receivedSize/expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //调整size
        
        CGFloat W = _imgBrowser.width;
        CGFloat H = (W*image.size.height)/image.size.width;
        _bigImageView.frame = CGRectMake(0, 0, W, H);
        _bigImageView.center = _imgBrowser.center;
       
        
        [_progressview removeFromSuperview];
        _progressview.persent = 0;
        
        
    }];
    
}

- (void)postCell:(FLPostCell *)postCell imgHeadTapped:(NSInteger)userId
{
     FLLog(@"%s",__func__);
    //进人用户个人界面

    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLProfileVC"];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FLPostDetailVC"]) {
        id vc = segue.destinationViewController;
        [vc setValue:sender forKeyPath:@"friendId"];
        
        
    }else if ([segue.identifier isEqualToString:@"FLTopicDetailVC"]){
        id vc = segue.destinationViewController;
        [vc setValue:sender forKeyPath:@"cellModel"];
        
        
        
    }
    
    
    
}


@end
