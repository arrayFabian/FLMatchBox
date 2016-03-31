//
//  FLEditNameVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLEditNameVC.h"
#import "FLAccountTool.h"
#import "FLUser.h"
#import "FLAccount.h"
#import "FLHttpTool.h"

#import <MJExtension/MJExtension.h>


@interface FLEditNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (copy, nonatomic) NSString *userName;


@property (nonatomic, strong)FLUser *user;

@end

@implementation FLEditNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
     FLLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FLUser *user = [FLAccountTool user];
    _user = user;
    self.tfName.text = user.userName;
    [self.tfName becomeFirstResponder];
    self.saveBtn.enabled = NO;
    self.userName = user.userName;
    NSLog(@"%@",self.userName);
     FLLog(@"%s",__func__);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    FLLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    FLLog(@"%s",__func__);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    FLLog(@"%s",__func__);
};

- (IBAction)editingchange:(id)sender
{
    
    if ([_tfName.text isEqualToString:self.userName]) {
        self.saveBtn.enabled = NO;
    }else{
        self.saveBtn.enabled = YES;
    }

    
    
    
}

- (IBAction)saveName:(UIButton *)sender
{
    [self.view endEditing:YES];
    
   
    __weak __typeof(&*self) weakSelf = self;
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] param:@{@"user.id":@(_user.userId),@"user.userName":self.tfName.text,@"user.sex":_user.sex,@"user.myInfo":_user.myInfo} success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        
        if ([responseObject[@"result"] integerValue] == 0) {
            
            _user.userName = self.tfName.text;
            [FLAccountTool saveUser:_user];
            //跳转
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}



@end
