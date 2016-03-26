//
//  FLRegiEditVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLRegiEditVC.h"

#import <MMPopupView/MMSheetView.h>
#import <MMPopupView/MMAlertView.h>

#import "FLHttpTool.h"
#import "FLAccount.h"
#import "FLAccountTool.h"

#import <AFNetworking/AFNetworking.h>

@interface FLRegiEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet CunstomButton *btnGotoMatchbox;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UILabel *lbTip;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet CustomImageView *imgCamera;
@property (weak, nonatomic) IBOutlet CunstomButton *btnHeadImg;

@property (nonatomic, strong)UIImage *headImage;



@end

@implementation FLRegiEditVC
- (IBAction)btnheadImgDidClick:(id)sender
{
    
    [self.view endEditing:YES];
    
    MMPopupItem *item1 = MMItemMake(@"相册", MMItemTypeNormal, ^(NSInteger index) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
       // picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        [self.navigationController presentViewController:picker animated:YES completion:nil];
        
    });
    MMPopupItem *item2 = MMItemMake(@"拍照", MMItemTypeNormal, ^(NSInteger index) {
        UIImagePickerController *picker2 = [[UIImagePickerController alloc]init];
        picker2.delegate = self;
        picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController presentViewController:picker2 animated:YES completion:nil];
        
    });

    MMSheetView *sheetView = [[MMSheetView alloc]initWithTitle:@"从相册选取图片或拍照" items:@[item1,item2]];
    
    [sheetView show];
   
    
    
    
}
- (IBAction)btnGotoMatchboxDidClick:(id)sender
{
    
    [self.view endEditing:YES];
    
   
    if (_headImage == nil) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择图片" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
       
        [alertview show];

        
        return;
    }
    
    
    FLAccount *account = [FLAccountTool account];
    
    
    NSDictionary *param = @{
                            @"user.id": account.userId,
                            @"user.userName":_tfName.text};
    NSString *urlsting = [NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl];
    
    __weak __typeof(&*self) weakself = self;
    [FLHttpTool uploadWithImage:_headImage url:urlsting filename:@"doc" name:@"imghead.jpg" mimeType:@"image/jpeg" params:param progress:^(NSProgress *uploadProgress) {
      // FLLog(@"%@",uploadProgress);
      //  FLLog(@"%lf",uploadProgress.fractionCompleted);
     
      dispatch_async(dispatch_get_main_queue(), ^{
          self.progressView.hidden = NO;
          self.progressView.progress = uploadProgress.fractionCompleted;
        
      });
        
    } success:^(id responseObject) {
        self.progressView.hidden = YES;
        NSDictionary *resultDict = responseObject;
        if ([resultDict[@"result"] integerValue] == 0) {
            
            //跳转
            [weakself performSegueWithIdentifier:@"FLLikeTopicVC" sender:nil];
            
            
        }
        
        
    } failure:^(NSError *error) {
        self.progressView.hidden = YES;
        
        
        
    }];
 
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tfName.delegate = self;
    
    
}

#pragma mark- textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length < 2 || str.length > 20) {
        self.btnGotoMatchbox.enabled = NO;
        self.btnGotoMatchbox.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.btnGotoMatchbox.enabled = YES;
        self.btnGotoMatchbox.backgroundColor = [UIColor colorWithRed:58/255.0 green:68/255.0 blue:70/255.0 alpha:1.f];
        
    }
    
    
    
    
    return YES;
}

#pragma mark- imagepicker vc delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    FLLog(@"%@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    _headImage = image;
    
    [self.btnHeadImg setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark- navigatin vc delegate





@end
