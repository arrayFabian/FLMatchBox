//
//  FLEditIntroVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLEditIntroVC.h"
#import "FLUser.h"
#import "FLAccountTool.h"
#import "FLHttpTool.h"

@interface FLEditIntroVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewIntro;
@property (weak, nonatomic) IBOutlet UILabel *lbTextNum;

@property (nonatomic, strong)FLUser *user;

@end

@implementation FLEditIntroVC
- (IBAction)saveIntro:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] param:@{@"user.id":@(_user.userId),@"user.userName":_user.userName,@"user.sex":_user.sex,@"user.myInfo":self.textViewIntro.text}success:^(id responseObject) {
        if ([responseObject[@"result"] integerValue] == 0) {
            
            _user.myInfo = self.textViewIntro.text;
            [FLAccountTool saveUser:_user];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.textViewIntro.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    FLUser *user = [FLAccountTool user];
    _user = user;
    
    self.textViewIntro.text = user.myInfo;
    self.lbTextNum.text = [NSString stringWithFormat:@"%ld",30-self.textViewIntro.text.length];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textViewIntro becomeFirstResponder];
}

#pragma mark- textview delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 30) {
        self.textViewIntro.text = [textView.text substringToIndex:30];
    }
    
    self.lbTextNum.text = [@(30 -self.textViewIntro.text.length) stringValue];
}



@end
