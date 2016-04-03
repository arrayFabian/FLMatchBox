//
//  FLUploadTopicVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLUploadTopicVC.h"

#import "FLUser.h"
#import "FLHttpTool.h"



@interface FLUploadTopicVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbPlaceHolder;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lbTextCount;

@property (weak, nonatomic) IBOutlet CunstomButton *btnApply;


@property (nonatomic, copy) NSString *textString;


@end

@implementation FLUploadTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = self.topicName;
    self.btnApply.enabled = NO;
    self.btnApply.backgroundColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (IBAction)btnApplyDidClick:(id)sender
{
    [self.textView resignFirstResponder];
    
    //提交话题申请审核
    //网络请求
    NSLog(@"%@",self.textView.text);
    
    __weak typeof (&*self) weakSelf = self;
    NSDictionary *param = @{@"userId":@(kUserModel.userId),
                            @"name":self.topicName};
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usersaveTopic",BaseUrl] param:param success:^(id responseObject) {//次接口有问题，创建成功但没有返回
        FLLog(@"%@",responseObject);
        
        //跳转
   
        [weakSelf performSegueWithIdentifier:@"FLSetupCompleteVC" sender:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  

}




#pragma mark- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.lbPlaceHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    
    
    self.lbTextCount.text = [NSString stringWithFormat:@"%ld",textView.text.length];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textView.text.length < 1) {
        self.lbPlaceHolder.hidden = NO;
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length < 1) {
        
        self.btnApply.enabled = NO;
        self.btnApply.backgroundColor = [UIColor lightGrayColor];

    }else{
        self.lbPlaceHolder.hidden = YES;
        self.btnApply.enabled = YES;
        self.btnApply.backgroundColor = MAINCOLOR;
        
       
    }
    
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
