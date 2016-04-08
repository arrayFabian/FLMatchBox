//
//  FLProfileVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLProfileVC.h"

#import "FLTopicCell.h"
#import "FLTopicModel.h"

#import "FLAccountTool.h"
#import "FLUser.h"

#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import "FLHttpTool.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MMSheetView.h>
#import <MJPhotoBrowser.h>
#import <MJExtension.h>
#import <MJRefresh.h>

@interface FLProfileVC ()

@property (weak, nonatomic) IBOutlet CustomImageView *imgHeadView;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbUserId;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnFans;

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIButton *btnIntroduce;

@property (nonatomic, strong)NSMutableArray *topics;
@property (nonatomic, strong)NSMutableArray *posts;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureImgHead;

@property (nonatomic, strong) UIView *sectionHeadView;

@property (nonatomic, assign) BOOL isPostCellFirstLoad;

@end

@implementation FLProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self setUpSectionHeadView];

    //refresh
    [self setUpRefresh];
    
    [self loadData];
    
}

- (void)loadData
{
    __weak __typeof(&*self)weakSelf = self;
    
    
    NSDictionary *param = @{@"userId":@(kUserModel.userId)};
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetTopicList",BaseUrl] param:param success:^(id responseObject) {
        if ([responseObject[@"result"] integerValue] == 0) {
            
            NSArray *arr = responseObject[@"list"];
            if (arr.count) {
                weakSelf.topics = [FLTopicModel mj_objectArrayWithKeyValuesArray:arr];
                
                weakSelf.tableView.rowHeight = 60;
                
                [weakSelf.tableView reloadData];
                
            }
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
    }];


    
        
        NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetMyFriendPost",BaseUrl];
        NSDictionary *param2 = @{@"userId":@(kUserModel.userId)};
        
        
        [FLHttpTool postWithUrlString:urlstring param:param2 success:^(id responseObject) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([dict[@"result"] integerValue] == 0) {
                
                NSArray *arr = dict[@"List"];
                if (arr.count) {
                    
                    weakSelf.posts = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                    
                   
                }
                
                
            }
            
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
        }];
        

   
    
    
}

- (IBAction)btnFollowDidClick:(id)sender
{
    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLAddressVC"];
    [vc setValue:@(YES) forKey:@"isFollowVC"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnFansDidClick:(id)sender
{
    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLAddressVC"];
    [vc setValue:@(YES) forKey:@"isFansVC"];

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self initUI];
    
    
}



- (IBAction)tapGesture:(UITapGestureRecognizer *)sender
{
    UIImageView *tapView = (UIImageView *)sender.view;
    
    MJPhoto *p = [[MJPhoto alloc]init];
    p.srcImageView = tapView;
    p.index = 0;
      FLUser *user = [FLAccountTool user];
    NSString *headImgUrl = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,user.url];
    p.url = [NSURL URLWithString:headImgUrl];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]init];
    browser.photos = @[p];
    browser.currentPhotoIndex = 0;
    [browser show];
    
    
}

- (void)initUI
{
    
    FLUser *user = [FLAccountTool user];
    NSLog(@"%@",user);
    
    NSString *headImgUrl = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,user.url];
    [self.imgHeadView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"d1.JPG"]];
    self.lbName.text = user.userName;
    
    if ([user.myInfo isEqualToString:@""]) {
        [self.btnIntroduce setTitle:@"点此处设置签名" forState:UIControlStateNormal];
    }else{
         [self.btnIntroduce setTitle:user.myInfo forState:UIControlStateNormal];
    }
   
    self.lbUserId.text = [NSString stringWithFormat:@"ID:%ld",user.userId];
    [self.btnFollow setTitle:[NSString stringWithFormat:@"%ld 关注",[user.myActionCount integerValue]] forState:UIControlStateNormal];
    [self.btnFans setTitle:[NSString stringWithFormat:@"%ld 粉丝",[user.fansCount integerValue]] forState:UIControlStateNormal];
    
    
   
    
 
    
   
    
}

- (void)setUpRefresh
{
    //上拉刷新 下拉加载
    
    __weak __typeof(&*self) weakSelf = self;
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.leftBtn.selected) {
            [weakSelf loadTopicData];
        }else{
            [weakSelf loadPostData];
        }
            
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
   
    
}

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftBtn.selected ? self.topics.count:self.posts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftBtn.selected) {
        
        FLTopicCell *cell = [FLTopicCell cellWithTableView:tableView];
        
        cell.topicModel = self.topics[indexPath.row];
        
        return cell;
    }
    
    
    FLPostCellModel *cellModel = self.posts[indexPath.row];
    
    FLPostCell *cell = [FLPostCell cellWithTableView:tableView model:cellModel];
    cell.isCellInUserDetail = YES;
    
    return cell;
}


- (void)setUpSectionHeadView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    self.sectionHeadView = view;
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, self.view.width/2.0 - 15, 30)];
    [view addSubview:btn1];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"Social_Private_Topic.png" ] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"Social_Private_Topic_Select"] forState:UIControlStateSelected];
    //[btn1 setTitle:@"话题" forState:UIControlStateNormal];
    //[btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.selected = YES;
    self.leftBtn = btn1;
    btn1.tag = 100;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(btn1.width-16, 11, 8, 8)];
    img1.image = [UIImage imageNamed:@"segment_arrow"];
    [btn1 addSubview:img1];
    
    
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2.0, 5, self.view.width/2.0 - 15, 30)];
    [view addSubview:btn2];
    // [btn2 setTitle:@"帖子" forState:UIControlStateNormal];
    // [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"Social_Private_Tip"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"Social_Private_Tip_Select"] forState:UIControlStateSelected];
    self.rightBtn = btn2;
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(btn2.width-16, 11, 8, 8)];
    img2.image = [UIImage imageNamed:@"segment_arrow"];
    [btn2 addSubview:img2];
    
    
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark- tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    return self.sectionHeadView;
    
}

- (void)loadTopicData
{
    __weak __typeof(&*self)weakSelf = self;
    
    
    NSDictionary *param = @{@"userId":@(kUserModel.userId)};
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetTopicList",BaseUrl] param:param success:^(id responseObject) {
        if ([responseObject[@"result"] integerValue] == 0) {
            
            NSArray *arr = responseObject[@"list"];
            if (arr.count) {
                weakSelf.topics = [FLTopicModel mj_objectArrayWithKeyValuesArray:arr];
                
                weakSelf.tableView.rowHeight = 60;
                
                [weakSelf.tableView reloadData];

            }
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
    }];
    
    
    
}

- (void)loadPostData
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/usergetMyFriendPost",BaseUrl];
     NSDictionary *param = @{@"userId":@(kUserModel.userId)};
    

    [FLHttpTool postWithUrlString:urlstring param:param success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([dict[@"result"] integerValue] == 0) {
            
            NSArray *arr = dict[@"List"];
            if (arr.count) {
              
                weakSelf.posts = [FLPostCellModel mj_objectArrayWithKeyValuesArray:arr];
                
                weakSelf.tableView.rowHeight = UITableViewAutomaticDimension;
                weakSelf.tableView.estimatedRowHeight = 400;
                
                [weakSelf.tableView reloadData];
            }
            
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
       
        [self.tableView.mj_header endRefreshing];
    }];
    

}

- (void)btnClick:(UIButton *)btn
{
    self.leftBtn.selected = self.rightBtn.selected = NO;
    btn.selected = YES;
    
    if (self.leftBtn.selected) {
        self.tableView.rowHeight = 60;
        
        [self.tableView reloadData];
        
        
    }else{
     
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 400;
        [self.tableView reloadData];
        
    }
  
    
    
    if (btn.tag == 100) {
        
        
        if (btn == self.rightBtn) {
            MMPopupItem *item1 = MMItemMake(@"1 所有帖子", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            MMPopupItem *item2 = MMItemMake(@"0 图片帖", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            MMPopupItem *item3 = MMItemMake(@"0 文字帖", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            
            MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil items:@[item1,item2,item3]];
            [sheetView show];
        
            
        }else{
            
            MMPopupItem *item1 = MMItemMake(@"1 所有话题", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            MMPopupItem *item2 = MMItemMake(@"0 创建的话题", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            MMPopupItem *item3 = MMItemMake(@"0 关注的话题", MMItemTypeNormal, ^(NSInteger index) {
                
                
            });
            
            MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:nil items:@[item1,item2,item3]];
            [sheetView show];
         

            
        }
    }
    
    self.leftBtn.tag = 101;
    self.rightBtn.tag = 102;
    btn.tag = 100;
     
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}







@end
