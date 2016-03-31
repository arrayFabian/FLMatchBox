//
//  FLEditPSWChangeVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLEditPSWChangeVC.h"
#import "FLAccountTool.h"
#import "FLAccount.h"

#import "FLHttpTool.h"
#import <MBProgressHUD.h>

@interface FLEditPSWChangeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfOldPSW;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPSW;
@property (weak, nonatomic) IBOutlet UITextField *tfSureNewPSW;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (copy, nonatomic) NSString *OldPSW;
@property (copy, nonatomic) NSString *NewPSW;
@property (copy, nonatomic) NSString *SureNewPSW;

@end

@implementation FLEditPSWChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tfOldPSW.delegate = self;
    self.tfNewPSW.delegate = self;
    self.tfSureNewPSW.delegate = self;
   
    self.btnSave.enabled = NO;
    [self.btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];



}
- (IBAction)editingdidend:(id)sender
{
    NSLog(@"%s",__func__);
}
- (IBAction)idtingdidbegin:(id)sender
{
    NSLog(@"%s",__func__);
}
- (IBAction)editingchanged:(id)sender
{
    NSLog(@"%s",__func__);
}
- (IBAction)didendonexit:(id)sender
{
    NSLog(@"%s",__func__);
}



- (IBAction)saveNewPSW:(id)sender
{
    [self.view endEditing:YES];
    if (![self.NewPSW isEqualToString:self.SureNewPSW]) {
        
       // [self sentAlert:@"新密码两次输入不一致" detail:nil];
        
       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:FLKeyWindow animated:YES];
        hud.labelText = @"新密码两次输入不一致";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.f];
        
        
    }else{
        
        FLAccount *account = [FLAccountTool account];
        if (![self.OldPSW isEqualToString:account.password]) {
         //   [self sentAlert:@"旧密码错误" detail:nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:FLKeyWindow animated:YES];
            hud.labelText = @"旧密码错误";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.f];
            
        }else{
            
            NSDictionary *param = @{@"oldPassWord":self.OldPSW ,
                                        @"newPassWord":self.NewPSW ,
                                    @"userId":@([account.userId integerValue]) };
            [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdatePassWordByUserId",BaseUrl] param:param success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                
                if ([responseObject[@"result"] integerValue] == 0) {
                    
                    account.password = self.NewPSW;
                    [FLAccountTool saveAccount:account];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:FLKeyWindow animated:YES];
                    hud.labelText = @"修改成功";
                    hud.mode = MBProgressHUDModeText;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    });
                    
                    
                    
                    
                }
                
            } failure:^(NSError *error) {
                
                
            }];
            
            
        }
        
    }
    
    
}


#pragma mark- tf delegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.tfOldPSW) {
        self.OldPSW = tempStr;
    }else if (textField == self.tfNewPSW){
        self.NewPSW = tempStr;
    }else if (textField == self.tfSureNewPSW){
        self.SureNewPSW = tempStr;
    }
    
//    if (self.tfOldPSW.text.length >= 6 && self.tfNewPSW.text.length >= 6 && self.tfSureNewPSW.text.length >= 6) {
//        self.btnSave.enabled = YES;
//        
//    }else{
//        self.btnSave.enabled = NO;
//    }
//    
    
    
    if (self.OldPSW.length >= 6 && self.NewPSW.length >= 6 && self.SureNewPSW.length >= 6) {
        self.btnSave.enabled = YES;
        
    }else{
        self.btnSave.enabled = NO;
    }
    
    
    return YES;
}


@end
