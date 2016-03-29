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
#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "FLEditSexChooseVC.h"

@interface FLSelfDataVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,FLEditSexChooseVCDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *quitLoginCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellImg;
@property (weak, nonatomic) IBOutlet CustomImageView *imgHead;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbSex;
@property (weak, nonatomic) IBOutlet UILabel *lbSexChoose;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbIntro;


@property (copy, nonatomic) NSString *sexChoose;




@end

@implementation FLSelfDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sexChoose = @"异性";
   
    
     FLLog(@"%s",__func__);
   

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initUI];
    
    FLLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    FLLog(@"%s",__func__);
};

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

- (void)initUI
{
    FLUser *user = [FLAccountTool user];
    
    
    NSString *headImgUrl = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,user.url];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"d1.JPG"]];

    self.lbName.text = user.userName;
    self.lbSex.text = user.sex;
   
    self.lbIntro.text = user.myInfo;
     self.lbSexChoose.text = self.sexChoose;
    
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sexChoose"]) {
        
       FLEditSexChooseVC  *vc = (FLEditSexChooseVC *)segue.destinationViewController;
        vc.delegate = self;
        
       [vc setValue:self.sexChoose forKey:@"sexChoose"];
     
    }
}

- (void)passValue:(NSString *)sexChoose
{
    self.sexChoose = sexChoose;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    if (self.cellImg.selected == YES) {//编辑头像
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
    
    if (self.quitLoginCell.selected == YES) {//退出登录
        
        
        FLKeyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"FLWelcomeNaviVC"];
        
        
    }
    
    
    
}


#pragma mark- image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //UIImage *imgHead = info[@"UIImagePickerControllerOriginalImage"];
    
    UIImage *imgHead = info[@"UIImagePickerControllerEditedImage"];
   
    
    NSLog(@"%@ ",info);
    
    self.imgHead.image = imgHead;
    
    FLUser *user = [FLAccountTool user];
    NSDictionary *param = @{@"user.id":@(user.userId),
                            @"user.userName":user.userName,
                            @"user.sex":user.sex,
                            @"user.myInfo":user.myInfo};

    [FLHttpTool uploadWithImage:imgHead url:[NSString stringWithFormat:@"%@/Matchbox/userupdateUserInfo",BaseUrl] filename:@"imagedas.jpg" name:@"doc" mimeType:@"image/jpeg" params:param progress:^(NSProgress *uploadProgress) {
        
        
    } success:^(id responseObject){
        FLLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {//修改成功
            
            //重新获取个人数据
            [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetUserInfoById",BaseUrl] param:@{@"userId":@(user.userId)} success:^(id responseObject) {
                if ([responseObject[@"result"] integerValue] == 0) {
                    
                    FLLog(@"%@",responseObject);

                    //保存模型
                    FLUser *user = [FLUser mj_objectWithKeyValues:responseObject];
                    [FLAccountTool saveUser:user];
                    
                }
                
            } failure:^(NSError *error) {
                
                
            }];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];

    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}




@end
