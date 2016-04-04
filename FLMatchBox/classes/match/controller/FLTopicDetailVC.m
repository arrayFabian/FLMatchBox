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
#import "FLTopicModel.h"

#import <MJRefresh.h>
#import <MJExtension.h>

#import <UIImageView+WebCache.h>

#import "FLHttpTool.h"
#import <MBProgressHUD.h>
#import <MMSheetView.h>
#import "ProgressView.h"
#import "FLPostDetailVC.h"
#import "FLOtherUserVC.h"


@interface FLTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,FLPostCellModelDelegate>

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

@property (nonatomic, strong)UIButton *btnCare;
@property (nonatomic, strong)UIButton *btnMore;

@property (strong, nonatomic) UIButton  * imgBrowser;
@property (strong, nonatomic) UIScrollView * imageScrollView;
@property (strong, nonatomic) UIImageView * bigImageView;
@property (strong, nonatomic) ProgressView * progressview;

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
   
    NSLog(@"%@",_cellModel);

    [self initData];
    [self initUI];
    
    
    

}


- (void)initData
{
    _lastArr = [@[] mutableCopy];
    _hotArr = [@[] mutableCopy];
    
    
    
}

- (void)initUI
{
    [self initNavigationBar];
    
    [self initScrollViewAndTableView];
    
    [self setUpRefresh];
    
    [self initToolBar];
    
}

- (void)initToolBar
{
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void)initScrollViewAndTableView
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
    lastTableview.rowHeight = UITableViewAutomaticDimension;
    lastTableview.estimatedRowHeight = 400;
    lastTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITableView *hotTableview = [[UITableView alloc] initWithFrame:CGRectMake(scrollview.width, 0, scrollview.width, scrollview.height)];
    [self.scrollView addSubview:hotTableview];
    self.hotTableview = hotTableview;
    hotTableview.backgroundColor = [UIColor blackColor];
    hotTableview.dataSource = self;
    hotTableview.delegate = self;
    hotTableview.rowHeight = UITableViewAutomaticDimension;
    hotTableview.estimatedRowHeight = 400;
    hotTableview.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)initNavigationBar
{
    
    self.title = _cellModel.topicName.length?_cellModel.topicName:_topicModel.name;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn setImage:[UIImage imageNamed:@"careList_care"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"careList_uncare"] forState:UIControlStateSelected];
    [btn setAdjustsImageWhenHighlighted:NO];
    [btn addTarget:self action:@selector(btnCareCLick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.btnCare = btn;
    
    //请求数据看是否关注了话题
    //因为接口问题 默认未关注 online进行
    self.btnCare.selected = NO;
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn2 setImage:[UIImage imageNamed:@"simpleTopicMore_sel"] forState:UIControlStateNormal];
    [btn2 setAdjustsImageWhenHighlighted:NO];
    [btn2 addTarget:self action:@selector(btnMoreCLick:) forControlEvents:UIControlEventTouchUpInside];
     btn2.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    self.btnMore = btn2;
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    
    
    
}

- (void)btnCareCLick:(UIButton *)btn
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = btn.selected?@"取消关注成功":@"关注成功";
        
        self.btnCare.selected = !self.btnCare.selected;
        
        [hud hide:YES afterDelay:0.3];
    });
    
    
    
    /*
    NSString *path;
    if (self.btnCare.selected) {
        path = @"/Matchbox/useraddFocusTopic";
    }else{
        path = @"/Matchbox/usercancleFocusTopic";
    }
    
    //网络请求
    
    NSDictionary *param = @{@"userTopic.user.id":@(kUserModel.userId),
                            @"userTopic.topic.id":@(self.cellModel.topicId)};
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@",BaseUrl] param:param success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            self.btnCare.selected = !self.btnCare.selected;
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    */
    
}

- (void)btnMoreCLick:(UIButton *)btn
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0,64, 35, 35)];
    tip.text = @"one more thing";
    vc.title = @"涂鸦的世界";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)setUpRefresh
{
    
    MJRefreshNormalHeader *mj_header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadLastData];
        
    }];
    self.lastTableview.mj_header = mj_header1;
    [mj_header1 beginRefreshing];
    
    MJRefreshAutoNormalFooter *mj_footer1 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [self loadLastData];
    }];
    self.lastTableview.mj_footer = mj_footer1;
    
    MJRefreshNormalHeader *mj_header2 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadHotData];
        
    }];
    self.hotTableview.mj_header = mj_header2;
    [mj_header2 beginRefreshing];
    
    MJRefreshAutoNormalFooter *mj_footer2 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
       
        [self loadHotData];
    }];
    self.hotTableview.mj_footer = mj_footer2;
    
}

//lasttableview
- (void)loadLastData
{
   
//    NSDictionary *param = @{@"userId":@(kUserModel.userId),
//                            @"topicId":self.topicId,
//                            @"pageModel.pageSize":@(_pageSize),
//                            @"pageModel.pageIndex":@(_pageLatestIndex)};

    
    NSInteger topicId = _cellModel == nil?_topicModel.topicId:_cellModel.topicId;
NSDictionary *param = @{@"userId":@(kUserModel.userId),
                        @"topicId":@(topicId)
                        };
///Matchbox/usergetIsNewFriendCircle
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetFriendCircles",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"List"];
            
           
            if (arr.count == 0) {
                [weakSelf.lastTableview.mj_header endRefreshing];
                [weakSelf.lastTableview.mj_footer endRefreshing];
                
                return ;
            }
            
            
            _lastArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
            
            
            [weakSelf.lastTableview reloadData];
                
           
            
        }
        
        [weakSelf.lastTableview.mj_header endRefreshing];
        [weakSelf.lastTableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.lastTableview.mj_header endRefreshing];
        [weakSelf.lastTableview.mj_footer endRefreshing];
        
    }];
    
    
}

//hottableview
- (void)loadHotData
{
    NSInteger topicId = _cellModel == nil?_topicModel.topicId:_cellModel.topicId;

    NSDictionary *param = @{@"userId":@(kUserModel.userId),
                            @"topicId":@(topicId)
                            };
    ///Matchbox/usergetFriendCircleIsHot
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetFriendCircles",BaseUrl];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"List"];
            if (arr.count == 0) {
                [weakSelf.hotTableview.mj_header endRefreshing];
                [weakSelf.hotTableview.mj_footer endRefreshing];
                
                return ;
            }
            
            _hotArr = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
           
            [weakSelf.hotTableview reloadData];
                
            
        }
        [weakSelf.hotTableview.mj_header endRefreshing];
        [weakSelf.hotTableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.hotTableview.mj_header endRefreshing];
        [weakSelf.hotTableview.mj_footer endRefreshing];
        
    }];
    
  
}





#pragma mark- tableview delegate

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.lastTableview) {
        return self.lastArr.count;
    }
    
        return self.hotArr.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLPostCellModel *cellModel = tableView == self.lastTableview? self.lastArr[indexPath.row]:self.hotArr[indexPath.row];
    
    
    FLPostCell *cell = [FLPostCell cellWithTableView:tableView model:cellModel];
    cell.isCellInTopicDetail = YES;
    cell.delegate = self;
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



#pragma mark- postcell delegate

- (void)postCell:(FLPostCell *)postCell btnCommentDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    FLLog(@"%ld",postCell.tag);
    //跳转到帖子详情
    FLPostDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLPostDetailVC"];
    vc.cellModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
- (void)postCell:(FLPostCell *)postCell btnRetweetDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    MMPopupItem *item1 = MMItemMake(@"推荐", MMItemTypeNormal, ^(NSInteger index) {
        
        
        
        
    });
    
    MMPopupItem *item2 = MMItemMake(@"转发并描述", MMItemTypeNormal, ^(NSInteger index) {
        
        
        
        
    });
    
    
    MMSheetView *sheet = [[MMSheetView alloc]initWithTitle:nil items:@[item1,item2]];
    
    [sheet show];
    
    
    
}

- (void)postCell:(FLPostCell *)postCell btnViewDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    //跳转到帖子详情
    
    FLPostDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLPostDetailVC"];
    vc.cellModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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

- (void)postCell:(FLPostCell *)postCell imgHeadTapped:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    //进人用户个人界面
    
    FLOtherUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLOtherUserVC"];
    vc.cellModel = cellModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}





@end
