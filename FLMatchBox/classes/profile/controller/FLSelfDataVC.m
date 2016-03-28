//
//  FLSelfDataVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/28.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSelfDataVC.h"
#import <MMSheetView.h>

#import "FLHttpTool.h"
#import "FLUser.h"
#import "FLAccountTool.h"

@interface FLSelfDataVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *cellImg;
@property (weak, nonatomic) IBOutlet CustomImageView *imgHead;

@end

@implementation FLSelfDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
   

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    if (self.cellImg.selected == YES) {
        MMPopupItem *item1 = MMItemMake(@"图片", MMItemTypeNormal, ^(NSInteger index) {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc]init];
            picker1.delegate = self;
            picker1.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker1.allowsEditing = YES;
            [self.navigationController presentViewController:picker1 animated:YES completion:nil];
            
        });
        MMPopupItem *item2 = MMItemMake(@"拍照", MMItemTypeNormal, ^(NSInteger index) {
            UIImagePickerController *picker2 = [[UIImagePickerController alloc]init];
            picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker2.allowsEditing = YES;
            picker2.delegate = self;
            [self.navigationController presentViewController:picker2 animated:YES completion:nil];
            
        });
       
        
        MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"选择图片" items:@[item1,item2]];
        [sheetView show];

        
        
        
    }
}


#pragma mark- image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //UIImage *imgHead = info[@"UIImagePickerControllerOriginalImage"];
    
    UIImage *imgHead = info[@" UIImagePickerControllerEditedImage"];
   
    
    NSLog(@"%@ ",info);
    
    self.imgHead.image = imgHead;
    
    FLUser *user = [FLAccountTool user];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
//        NSDictionary *param = @{@"user.id":user.userId
//                                    @"user.userName":@"asdsd"
//                                    @"user.sex":@"男"
//                                    @"user.myInfo":
//                                    
//                                };
        
        [FLHttpTool uploadWithImage:imgHead url:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] filename:@"imagedas.jpg" name:@"doc" mimeType:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
            
            
        } success:^(id responseObject) {
            FLLog(@"%@",responseObject);
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
    }];
    
}




@end
