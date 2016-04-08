//
//  FLBoxVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLBoxVC.h"

#import "FLPostCell.h"
#import "FLPostCellModel.h"
#import "FLUser.h"
#import "FLAccountTool.h"

#import <MJRefresh/MJRefresh.h>

#import <MJExtension/MJExtension.h>

#import "FLHttpTool.h"
#import <MMPopupView.h>
#import <MMSheetView.h>
#import "ProgressView.h"
#import <UIImageView+WebCache.h>
#import "FLOtherUserVC.h"
#import "FLPostDetailVC.h"
#import "FLTopicDetailVC.h"

#import <UMSocialSnsService.h>
#import <UMSocialSnsPlatformManager.h>


@interface FLBoxVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FLPostCellModelDelegate,UMSocialUIDelegate>




@property (nonatomic, strong)UITableView *friendTableView;

@property (nonatomic, strong)NSMutableArray *friendsArr;


@property (strong, nonatomic) UIButton  * imgBrowser;
@property (strong, nonatomic) UIScrollView * imageScrollView;
@property (strong, nonatomic) UIImageView * bigImageView;
@property (strong, nonatomic) ProgressView * progressview;



@end

@implementation FLBoxVC



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
    
    [self.friendTableView.mj_header beginRefreshing];
    
   
   
    
}



- (void)initUI
{
   
    
    
    
    //tableview
    UITableView *friendTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:friendTableview];
    _friendTableView = friendTableview;
    
    friendTableview.dataSource = self;
    friendTableview.delegate = self;
    friendTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendTableview.rowHeight = UITableViewAutomaticDimension;
    friendTableview.estimatedRowHeight = 400;
    
    
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
                
                //-----------
                //归档
                [FLAccountTool saveBoxPostCellModelArr:_friendsArr];
                
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


#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return self.friendsArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLPostCellModel *model =  self.friendsArr[indexPath.row];
    
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
    
    
    _friendsArr = [@[] mutableCopy];
    
    [self initUI];
    
    _friendsArr = [FLAccountTool getBoxPostCellModelArr];
    
    if (_friendsArr) {
        
        [self.friendTableView reloadData];
    }
    
    [self setUpRefresh];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // [self.friendTableView.mj_header beginRefreshing];
    
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

- (void)postCell:(FLPostCell *)postCell btnFollowDidClick:(FLPostCellModel *)cellModel
{
    
    NSDictionary *param = @{@"friend.user.id":@(kUserModel.userId),
                            @"friend.beuser.id":@(cellModel.userId)};
    NSString *path = cellModel.isAction ? @"/Matchbox/usercancleFocus":@"/Matchbox/useraddFocus";
    __weak __typeof(self) weakSelf = self;
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@%@",BaseUrl,path] param:param success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {
            
            
                for (FLPostCellModel *model in self.friendsArr) {
                    if (model.userId == cellModel.userId) {
                        model.isAction = !model.isAction;
                    }
                }
            [FLAccountTool saveBoxPostCellModelArr:_friendsArr];
                [weakSelf.friendTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (void)postCell:(FLPostCell *)postCell btnCommentDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
        
    //跳转到帖子详情
    FLPostDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLPostDetailVC"];
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
    FLPostDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLPostDetailVC"];
    vc.cellModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];

   
    
    
    
}

- (void)postCell:(FLPostCell *)postCell btnTopicDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    //跳转到话题详情
    FLTopicDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLTopicDetailVC"];
    vc.cellModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)postCell:(FLPostCell *)postCell btnOperationDidClick:(FLPostCellModel *)cellModel
{
    FLLog(@"%s",__func__);
    //底部view 更多操作
    __weak __typeof(self) weakSelf = self;
    MMPopupItem *item1 = MMItemMake(cellModel.isAction? @"取消关注":@"关注TA", MMItemTypeNormal, ^(NSInteger index) {
        
        NSString *path = cellModel.isAction ? @"/Matchbox/usercancleFocus":@"/Matchbox/useraddFocus";
        NSDictionary *param = @{@"friend.user.id":@(kUserModel.userId),
                                @"friend.beuser.id":@(cellModel.userId)};
        
        
        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@%@",BaseUrl,path] param:param success:^(id responseObject) {
            if ([responseObject[@"result"] integerValue] == 0) {
                
                
                    for (FLPostCellModel *model in self.friendsArr) {
                        if (model.userId == cellModel.userId) {
                            model.isAction = !model.isAction;
                        }
                    }
                
                [FLAccountTool saveBoxPostCellModelArr:_friendsArr];
                    [weakSelf.friendTableView reloadData];
                               
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
        
        
        
    });
    
    MMPopupItem *item2 = MMItemMake(cellModel.isCollection?@"取消收藏":@"收藏帖子", MMItemTypeNormal, ^(NSInteger index) {
        
        NSString *path = cellModel.isCollection?@"/Matchbox/usercanclecollection":@"/Matchbox/useraddCollection";
        
        NSDictionary *param = @{@"collection.user.id":@(kUserModel.userId),
                                @"collection.friendCircle.id":@(cellModel.friendId)};
        
        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@%@",BaseUrl,path] param:param success:^(id responseObject) {
            
            if ([responseObject[@"result"] integerValue] == 0) {
                
                cellModel.isCollection = !cellModel.isCollection;
                [FLAccountTool saveBoxPostCellModelArr:_friendsArr];
            }
            
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
    });
    
    MMPopupItem *item3 = MMItemMake(@"分享至第三方", MMItemTypeNormal, ^(NSInteger index) {
        
        //分享帖子内容  获取要分享的 图片  如果帖子没有图片 则分享 应用icon
        UIImage *shareImage;
        Photolist *photo = [cellModel.photoList lastObject];
        shareImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
        
        //判断是否合法
        if ([photo.imgUrl hasSuffix:@".jpg"] || [photo.imgUrl hasSuffix:@".png"] ) {
            NSString *path1 = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,photo.imgUrl];
            //查看是否有缓存这张图片
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            if ([manager diskImageExistsForURL:[NSURL URLWithString:path1]]) {
                shareImage = [[manager imageCache] imageFromDiskCacheForKey:path1];
            }
        }
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = cellModel.topicName;
        
        [UMSocialData defaultData].extConfig.wechatFavoriteData.title = cellModel.topicName;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = cellModel.topicName;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://weibo.com/1748921590/profile?topnav=1&wvr=6&is_all=1";
        
        [UMSocialData defaultData].extConfig.wechatFavoriteData.url = @"http://weibo.com/1748921590/profile?topnav=1&wvr=6&is_all=1";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://weibo.com/1748921590/profile?topnav=1&wvr=6&is_all=1";
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMentAppKey shareText:cellModel.msg shareImage:shareImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite] delegate:self];
        
        
        
        
    });
    
    
    
    MMSheetView *sheet = [[MMSheetView alloc]initWithTitle:nil items:@[item1,item2,item3]];
    
    [sheet show];
    
    
    
}

//实现回调方法（可选）：
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"%@",response);
    
    
    
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
        UIAlertView *photoSave = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
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
