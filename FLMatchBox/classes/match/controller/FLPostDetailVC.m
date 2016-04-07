//
//  FLPostDetailVC.m
//  FLMatchBox
//
//  Created by Mac on 16/4/2.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostDetailVC.h"


#import "FLPostCell.h"
#import "FLPostCellModel.h"

#import "FLHttpTool.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MJExtension.h>

#import <Masonry.h>
#import <UIButton+WebCache.h>
#import "FLCommentCell.h"
#import <HYBNetworking.h>
#import "FLTopUserModel.h"
#import <MJExtension.h>
#import "FLUser.h"
#import "FLCommentModel.h"
#import "TopUserVC.h"
#import "FLHttpTool.h"

@interface FLPostDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


@property (strong, nonatomic) UIView * toolBar;
@property (strong, nonatomic) UIButton * btnSent;
@property (strong, nonatomic) UIButton * btnLike;
@property (strong, nonatomic) UILabel * lbTips;
@property (strong, nonatomic) NSString * contentStr;
@property (strong, nonatomic) UIButton * btnTips;
@property (strong, nonatomic) UITextView * textview;
@property (strong, nonatomic) UITableView * tableview;
//-----------------------------------
// headView
@property (strong, nonatomic) UIView * tableHeadView;
@property (strong, nonatomic) UIButton  * btnTitle;
@property (strong, nonatomic) UIButton * btnHead;
@property (strong, nonatomic) UILabel * lbName;
@property (strong, nonatomic) UIButton * btnImage;
@property (strong, nonatomic) UILabel * lbContent;
@property (strong, nonatomic) UIView * headImgeView;// 放点赞用户头像的view
@property (strong, nonatomic) UIButton * btnHeadImgeView;// 在该view上添加一个btn

@property (strong, nonatomic) UIView * sectionHeadView;

//-----------------------------------
// 数据
@property (strong, nonatomic) NSMutableArray * commentArr;
@property (strong, nonatomic) NSMutableArray * topUserArr;

@end

@implementation FLPostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topUserArr = [@[] mutableCopy];
    _commentArr = [@[] mutableCopy];
    
    [self initUI];
    [self loadData];
    
    
}

- (void)initUI
{
    
    self.title =  @"详情";
    
    //tableview
    
    UITableView *tableview = [UITableView new];
    _tableview = tableview;
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.estimatedRowHeight = 96;
    tableview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
                        
    [self.view addSubview:tableview];
   
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        
    }];
    
    
    //toolBar
    
    [self initToolBar];

    //------------------------------
    // tableHeadView
    _tableHeadView = [UIView new];
    [self.view addSubview:_tableHeadView];
    [_tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
    }];
    
    
    _btnTitle = [UIButton new];
    [_tableHeadView addSubview:_btnTitle];
    [_btnTitle setTitle:_cellModel.topicName forState:UIControlStateNormal];
    _btnTitle.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnTitle setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [_btnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableHeadView).offset(8);
        make.centerX.mas_equalTo(_tableHeadView);
    }];

    NSString * url = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,_cellModel.imgUrl];
    
    _btnHead = [UIButton new];
    [_tableHeadView addSubview:_btnHead];
    _btnHead.layer.cornerRadius = 25;
    _btnHead.layer.masksToBounds = YES;
    [_btnHead sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"like"]];
    [_btnHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnTitle.mas_bottom).offset(8);
        make.centerX.mas_equalTo(_tableHeadView);
        make.width.height.mas_equalTo(@50);
    }];
    
    
    
    _lbName = [UILabel new];
    [_tableHeadView addSubview:_lbName];
    _lbName.text = _cellModel.userName;
    _lbName.textColor = MAINCOLOR;
    _lbName.font = [UIFont systemFontOfSize:10];
    [_lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnHead.mas_bottom).offset(8);
        make.centerX.mas_equalTo(_tableHeadView);
    }];
    
    //-----------------------------------
    //  类型是2 且有图片。。。
    if (_cellModel.type == 2 && _cellModel.photoList.count > 0) {
        _btnImage = [UIButton new];
        Photolist * photo = [_cellModel.photoList firstObject];
        NSString * url1 = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,photo.imgUrl];
        [_btnImage sd_setImageWithURL:[NSURL URLWithString:url1] forState:UIControlStateNormal];
        
        [_tableHeadView addSubview:_btnImage];
        [_btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_tableHeadView);
            make.top.mas_equalTo(_lbName.mas_bottom).offset(8);
            make.height.mas_equalTo(300);
        }];
    }
    
    //-----------------------------------
    // 如果有图片
    _lbContent = [UILabel new];
    [_tableHeadView addSubview:_lbContent];
    _lbContent.textColor = MAINCOLOR;
    _lbContent.text = _cellModel.msg;
    _lbContent.font = [UIFont systemFontOfSize:14];
    _lbContent.numberOfLines = 0;
    if (_btnImage) {
        [_lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_tableHeadView).offset(8);
            make.trailing.mas_equalTo(_tableHeadView).offset(-8);
            make.top.mas_equalTo(_btnImage.mas_bottom).offset(8).priorityHigh();
        }];
    }else{
        [_lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_tableHeadView).offset(8);
            make.trailing.mas_equalTo(_tableHeadView).offset(-8);
            make.top.mas_equalTo(_lbName.mas_bottom).offset(8).priorityHigh();
        }];
    }
    
    _headImgeView = [UIView new];
    [_tableHeadView addSubview:_headImgeView];
    [_headImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(_tableHeadView);
        make.top.mas_equalTo(_lbContent.mas_bottom).offset(8);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(_tableHeadView.mas_bottom).offset(-8);
    }];
    
    
    UIImageView * like = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12, 20, 20)];
    like.image = [UIImage imageNamed:@"liked"];
    [_headImgeView addSubview:like];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-38, 8, 20, 20)];
    arrow.image = [UIImage imageNamed:@"RightArrow"];
    [_headImgeView addSubview:arrow];
    
    _btnHeadImgeView = [UIButton new];
    [_headImgeView addSubview:_btnHeadImgeView];
    [_btnHeadImgeView addTarget:self action:@selector(btnHeadImgeViewCLick) forControlEvents:UIControlEventTouchUpInside];
    // 这里会引起约束混乱
    //[_btnHeadImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.edges.mas_equalTo(_headImgeView).priorityLow();
    //}];
    
    
    //-----------------------------------
    // 设置 tableView headerView  要先计算整个headView 高度
    
    [_tableHeadView layoutIfNeeded];
    CGFloat totalHeight = CGRectGetMaxY(_headImgeView.frame);
    [_tableHeadView removeFromSuperview];
    _tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, totalHeight);
    tableview.tableHeaderView = _tableHeadView;
    // 在这里调整frame
    _btnHeadImgeView.frame = _headImgeView.bounds;
    
    //-----------------------------------
    // sectionHeader
    _sectionHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _sectionHeadView.layer.borderWidth = 1.f;
    _sectionHeadView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    


    
}






- (void)initToolBar
{
    UIView *toolbar = [UIView new];
    _toolBar = toolbar;
    toolbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolbar];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(@44);
        
    }];
    
    UITextView *tv = [UITextView new];
    _textview = tv;
    tv.delegate = self;
    [toolbar addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(toolbar).offset(20);
        make.centerY.mas_equalTo(toolbar);
        make.top.mas_equalTo(toolbar).offset(8);
        make.width.mas_equalTo(toolbar).offset(-100);//放发送按钮
    }];
    
    UILabel *lb = [UILabel new];
    _lbTips = lb;
    lb.font = [UIFont systemFontOfSize:12];
    lb.text = @"点此评论";
    lb.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [toolbar addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(tv).offset(-2);
        make.leading.mas_equalTo(tv).offset(8);
    }];
    
    
    UIButton *btn = [UIButton new];
    _btnTips = btn;
    [toolbar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.centerY.mas_equalTo(tv);
    }];
    [btn addTarget:self action:@selector(btnTipsCLick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSent = [UIButton new];
    _btnSent = btnSent;
    [btnSent addTarget:self action:@selector(btnSentCLick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSent setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [toolbar addSubview:btnSent];
    [btnSent setTitle:@"发布" forState:UIControlStateNormal];
    [btnSent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(toolbar).offset(-8);
        make.leading.mas_equalTo(tv.mas_trailing).offset(8);
        make.height.mas_equalTo(@28);
    }];
    
    UIButton * btnLike = [UIButton new];
    _btnLike = btnLike;
    btnLike.backgroundColor = [UIColor whiteColor];
    [toolbar addSubview:btnLike];
    [btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    btnLike.selected = self.cellModel.isTop;
    [btnLike addTarget:self action:@selector(btnLikeCLick:) forControlEvents:UIControlEventTouchUpInside];
    [btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(toolbar).offset(-8);
        make.leading.mas_equalTo(tv.mas_trailing).offset(8);
        make.height.mas_equalTo(@28);
    }];
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    [toolbar addSubview:line];
    [toolbar bringSubviewToFront:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(toolbar);
        make.height.mas_equalTo(@1);
    }];
    
    
}
- (void)btnHeadImgeViewCLick
{
    TopUserVC *vc = [[TopUserVC alloc]init];
    vc.topUserModelArr = _topUserArr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)btnTipsCLick
{
    _btnTips.hidden = YES;
    [_textview becomeFirstResponder];
}

- (void)btnSentCLick:(UIButton *)btn
{
    if (_textview.text.length<1) {
        return;
    }
    //    /useraddDiscuss  //评论帖子
    //    discuss.content  //评论内容
    //    discuss.friendCircle.id  //帖子id
    //    discuss.user.id  //评论者id
    
    
    NSDictionary * param = @{
                             @"discuss.content":_textview.text,
                             @"discuss.friendCircle.id":[NSNumber numberWithInteger:self.cellModel.friendId],
                             @"discuss.user.id":@([kUserModel userId])
                             };
    __weak __typeof(&*self) weakSelf = self;
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/useraddDiscuss",BaseUrl] param:param success:^(id responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict[@"result"]integerValue] == 0) {
            [weakSelf loadData];
            weakSelf.textview.text = @"";
            [weakSelf.view endEditing:YES];
        }

        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)btnLikeCLick:(UIButton *)btn
{
    NSString * url;
    if (btn.selected) {
        url = @"/Matchbox/usercancleTop";
    }else{
        url = @"/Matchbox/useraddTopForFriend";
    }
    NSDictionary * param = @{
                             @"userId":@([kUserModel userId]),
                             @"friendId":@(_cellModel.friendId)
                             };
    [HYBNetworking postWithUrl:url params:param success:^(id response) {
        NSDictionary * dict = response;
        if ([dict[@"result"]integerValue] == 0) {
            // 更改模型
            _cellModel.isTop = !_cellModel.isTop;
            // 更改样式
            btn.selected = !btn.selected;
            
            if (_cellModel.isTop) {
                _cellModel.topCount++;
            }else
            {
                _cellModel.topCount--;
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)loadData
{
    
    NSLog(@"%ld",_cellModel.friendId);
    __weak __typeof(&*self) weakSelf = self;
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetDiscussByFriendId",BaseUrl] param:@{@"friendCircle.id":@(_cellModel.friendId)} success:^(id responseObject) {
        
        NSDictionary * dict = responseObject;
        if ([dict[@"result"]integerValue]==0) {
            NSArray * list = dict[@"List"];
            if (list.count == 0) {
                return ;
            }else
            {
                [_commentArr removeAllObjects];
            }
            for (NSDictionary * modelDict in list) {
                FLCommentModel * model = [FLCommentModel mj_objectWithKeyValues:modelDict];
                [_commentArr addObject:model];
            }
            [weakSelf.tableview reloadData];
        }

        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    //-----------------------------------
    // Matchbox/usergetTopUrlByFriendId?friendCircle.id=1  //根据帖子id获取点赞的头像
    NSLog(@"%ld",_cellModel.friendId);
    
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetTopUrlByFriendId",BaseUrl] param:@{@"friendCircle.id":@(_cellModel.friendId)} success:^(id responseObject) {
        
        NSDictionary * dict = responseObject;
        if ([dict[@"result"]integerValue]==0) {
            NSArray * list = dict[@"List"];
            if (list.count == 0) {
                return ;
            }else
            {
                [_topUserArr removeAllObjects];
            }
            
            NSInteger count = list.count>8?8:list.count;
            for (int i = 0 ;i< count;i++) {
                NSDictionary * userDict =  list[i];
                FLTopUserModel * model = [FLTopUserModel mj_objectWithKeyValues:userDict];
                [_topUserArr addObject:model];
                //i+1 因为前面有一个 ❤️
                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((i+1) * (28+8)+8, 8, 28, 28)];
                [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,model.userImg]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
                btn.layer.cornerRadius = 14;
                btn.layer.masksToBounds = YES;
                [_headImgeView insertSubview:btn atIndex:0];
            }
            
            //            [weakSelf.tableview reloadData];

        }
    } failure:^(NSError *error) {
        
        
    }];
    
}


/******************** textviewDelegate *********************/


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    _lbTips.hidden =YES;
    textView.text = _contentStr;
    _btnLike.hidden = YES;
    [self textViewDidChange:textView];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _lbTips.hidden =NO;
    _contentStr = textView.text;
    textView.text = nil;
    _btnLike.hidden = NO;
    [_toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
    }];
    _btnTips.hidden = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //-----------------------------------
    // 提示
    _lbTips.hidden = textView.text.length;
    //-----------------------------------
    // 1.算高度
    CGSize size = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(self.view.bounds.size.width-120, MAXFLOAT)];
    if (size.height>120) {
        size.height = 120;
    }
    if (size.height<28) {
        size.height = 28;
    }
    //-----------------------------------
    // 2.调整 toolbar的高度
    [_toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height+28);
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FLCommentCell cellWithTableView:tableView AndModel:_commentArr[indexPath.row]];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headImgeView;
    
}





@end
