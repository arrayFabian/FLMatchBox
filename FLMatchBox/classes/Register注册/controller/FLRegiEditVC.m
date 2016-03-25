//
//  FLRegiEditVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLRegiEditVC.h"

#import <MMPopupView/MMSheetView.h>

#import "FLHttpTool.h"

@interface FLRegiEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

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
    
    if (_tfName.text.length < 2 || _headImage == nil) {
        return;
    }
//    
//    NSDictionary *param = @{@"doc": ,
//                            @"user.id": ,
//                            @"user.userName": ,
//                            @"user.sex": ,
//                            @"user.myInfo": ,
//                            }
//    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] param:param success:^(id responseObject) {
//        
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
//    
    
    
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    
    
}

#pragma mark- textfield delegate



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
