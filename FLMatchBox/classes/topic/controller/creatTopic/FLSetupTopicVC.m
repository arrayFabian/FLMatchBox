//
//  FLSetupTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSetupTopicVC.h"
#import "CunstomButton.h"

#import "FLTopicCell.h"
#import "FLTopicModel.h"

#import "FLHttpTool.h"
#import <MBProgressHUD.h>
#import "FLUser.h"
#import <MJExtension/MJExtension.h>

@interface FLSetupTopicVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet CunstomButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITableView *ktableView;


@property (weak, nonatomic) IBOutlet CunstomButton *btnContinueCreat;

@property (weak, nonatomic) IBOutlet CunstomButton *btnReInput;


@property (nonatomic, strong) NSMutableArray *searchTopicArr;



@end

@implementation FLSetupTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTopicArr = [NSMutableArray array];
    
    [self initUI];
    
    
}

- (void)initUI
{
    [self.searchBar becomeFirstResponder];
    self.ktableView.hidden = YES;
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = [UIColor lightGrayColor];
    self.searchBar.delegate = self;
}

- (IBAction)nextBtnClick:(id)sender
{
    [self.searchBar resignFirstResponder];
    //先判断此话题名是否存在
     //这里先混略此步
    
    //请求数据
    [self searchTopic];
   
}

#pragma mark- 网络请求
- (void)searchTopic
{
    
    __weak typeof (&*self) weakSelf = self;
    NSDictionary *param = @{@"userId":@(kUserModel.userId),
                            @"user.name":self.searchBar.text};
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetTopicList",BaseUrl] param:param success:^(id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] integerValue] == 0) {//请求成功
            NSArray *list = dict[@"list"];
            if (list.count) {//有相关的话题
                weakSelf.searchTopicArr = [FLTopicModel mj_objectArrayWithKeyValuesArray:list];
//                for (FLTopicModel *model in _searchTopicArr) {
//                    if ([model.name isEqualToString:weakSelf.searchBar.text]) {
//                        
//                        [weakSelf sentAlert:@"话题重复" detail:@"去看看"];
//                        return ;
//                        
//                    }
//                }
                
                [weakSelf.ktableView reloadData];
                
            }else{//没有相关的话题
                weakSelf.searchTopicArr = [@[] mutableCopy];
                [weakSelf.ktableView reloadData];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"没有相似话题";
                [hud hide:YES afterDelay:0.5];
                
            }
            weakSelf.ktableView.hidden = NO;
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (IBAction)continueBtnClick:(id)sender
{
    //创建话题
    [self performSegueWithIdentifier:@"FLUploadTopicVC" sender:@(_isPicType)];
    
    
    
}
- (IBAction)reInputBtnClick:(id)sender
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.ktableView.hidden = YES;
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = [UIColor lightGrayColor];
    
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark- tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchTopicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLTopicCell *cell = [FLTopicCell cellWithTableView:tableView];
    
    cell.topicModel = self.searchTopicArr[indexPath.row];
    return cell;
}


#pragma mark- searchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    FLLog(@"%@",searchText);
   
    if (!self.ktableView.hidden) {
        self.ktableView.hidden = YES;
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = MAINCOLOR;

        
    }
    
    
    if (searchText.length> 0) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = MAINCOLOR;
    }else{
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [UIColor lightGrayColor];
        
        self.ktableView.hidden = YES;
        [self.searchBar becomeFirstResponder];
    }
    
    
    
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请输入搜索内容!";
        [hud hide:YES afterDelay:0.5];
        
        
    }else{
        [self.searchBar resignFirstResponder];
        //先判断此话题名是否存在
        
        
        //请求数据
        
        [self searchTopic];
        
        
        
    }
    
  
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FLUploadTopicVC"]) {
        id vc = segue.destinationViewController;
        [vc setValue:sender forKeyPath:@"isPicType"];
        [vc setValue:self.searchBar.text forKeyPath:@"topicName"];
        
    }
    
    
}


@end
