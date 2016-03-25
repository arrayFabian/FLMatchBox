//
//  FLSignUpVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSignUpVC.h"
#import "FLThreeSignInView.h"
#import "FLSignInVC.h"
#import "FLLogin.h"

#import "FLHttpTool.h"

#import "FLAccount.h"
#import "FLAccountTool.h"

#import <SVProgressHUD.h>
#import <MJExtension/MJExtension.h>




@interface FLSignUpVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pswtf;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (copy, nonatomic) NSString *psw;
@property (copy, nonatomic) NSString *phoneNum;

@property (weak, nonatomic) IBOutlet FLLogin *customCountryView;



@end

@implementation FLSignUpVC
- (IBAction)request:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self isMobileNumber:self.customCountryView.phoneNum.text]) {//是手机号
        
        NSString *urlstring = [NSString stringWithFormat:@"%@/Matchbox/userregist",BaseUrl];
        
        __weak FLSignUpVC *weakSelf = self;
        
        [FLHttpTool postWithUrlString:urlstring param:@{@"user.passWord":self.pswtf.text  ,@"user.name":self.customCountryView.phoneNum.text}  success:^(id responseObject) {
            
            NSDictionary *dict = responseObject;
            if ([dict[@"result"] integerValue] == 0) {
                FLLog(@"注册成功");
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:dict[@"userId"] forKey:@"userId"];
                
                NSDictionary *dict1 = @{@"userId":dict[@"userId"],
                                        @"password":self.customCountryView.phoneNum.text,
                                       @"name":self.pswtf.text};
                
                FLAccount *account = [FLAccount accountWithDict:dict1];
                [FLAccountTool saveAccount:account];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
                    
                    [SVProgressHUD resetOffsetFromCenter];
                    
                    //跳转
                    [weakSelf performSegueWithIdentifier:@"FLRegiEditVC" sender:nil];
                    
                    
                });

                
            }
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
                
                [SVProgressHUD resetOffsetFromCenter];
                               
                
            });
            
        } failure:^(NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
                
                [SVProgressHUD resetOffsetFromCenter];
            });

            
        }];

        
    }else{//不是手机号
        
        [self.view endEditing:YES];
       
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:@"不是正确的手机号" maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD resetOffsetFromCenter];
        });
        
        
    }
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customCountryView.phoneNum.delegate = self;
    self.pswtf.delegate = self;
    
    
//    FLThreeSignInView *threeView = [[[NSBundle mainBundle]loadNibNamed:@"FLThreeSignInView" owner:nil options:nil] lastObject];
//  threeView.frame = CGRectMake(0,self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
//   
//    [self.view addSubview:threeView];
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
     btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn sizeToFit];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem.customView.hidden = self.hideRightBarItem;
    
}

- (void)gotoLogin
{
    FLSignInVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLSignInVC"];
    [vc setValue:@YES forKey:@"hideRightBarItem"];
    [self.navigationController pushViewController:vc animated:YES];

}


// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)dealloc
{
     FLLog(@"%s",__func__);
}




#pragma mark- tf delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.pswtf) {
        self.psw = tempStr;
    }else if (textField == self.customCountryView.phoneNum){
        self.phoneNum = tempStr;
    
    }
    
        
    if (self.psw.length >= 6 && self.phoneNum.length == 11) {
        
        self.sendBtn.enabled = YES;
        self.sendBtn.backgroundColor = [UIColor colorWithRed:66/255.0 green:83/255.0 blue:86/255.0 alpha:1];

        
    }else{
        self.sendBtn.enabled = NO;
        self.sendBtn.backgroundColor = [UIColor colorWithRed:196/255.0 green:204/255.0 blue:203/255.0 alpha:1];

    }
    
    
    return YES;
}



@end
