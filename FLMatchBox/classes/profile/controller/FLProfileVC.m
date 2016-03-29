//
//  FLProfileVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/20.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLProfileVC.h"

#import "FLTopicCell.h"
#import "FLAccountTool.h"
#import "FLUser.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MMSheetView.h>

#import <MJPhotoBrowser.h>

@interface FLProfileVC ()

@property (weak, nonatomic) IBOutlet CustomImageView *imgHeadView;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbUserId;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnFans;

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UILabel *lbIntroduce;

@property (nonatomic, strong)NSMutableArray *topics;
@property (nonatomic, strong)NSMutableArray *posts;

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureImgHead;



@end

@implementation FLProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
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
    self.lbIntroduce.text = user.myInfo;
    self.lbUserId.text = [NSString stringWithFormat:@"ID:%ld",user.userId];
    [self.btnFollow setTitle:[NSString stringWithFormat:@"%ld 关注",[user.myActionCount integerValue]] forState:UIControlStateNormal];
    [self.btnFans setTitle:[NSString stringWithFormat:@"%ld 粉丝",[user.fansCount integerValue]] forState:UIControlStateNormal];
    
}

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLTopicCell *cell = [FLTopicCell cellWithTableView:tableView];
    
    cell.topicModel = self.topics[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark- tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
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
    return view;
}
- (void)btnClick:(UIButton *)btn
{
    self.leftBtn.selected = self.rightBtn.selected = NO;
    btn.selected = YES;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}




@end
