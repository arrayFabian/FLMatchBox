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

@interface FLSelfDataVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,FLEditSexChooseVCDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *quitLoginCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellImg;
@property (weak, nonatomic) IBOutlet UITableViewCell *cityCell;
@property (weak, nonatomic) IBOutlet CustomImageView *imgHead;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbSex;
@property (weak, nonatomic) IBOutlet UILabel *lbSexChoose;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbIntro;


@property (copy, nonatomic) NSString *sexChoose;

@property (copy, nonatomic) NSString *city;

@property (nonatomic, strong)FLUser *user;

@property (weak, nonatomic) UIPickerView *pickView;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *tool;


@property (nonatomic, strong)NSArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, copy) NSString *selectProvince;
@property (nonatomic, copy) NSString *selectCity;

@property (nonatomic, assign) NSInteger indexprovince;
@property (nonatomic, assign) NSInteger indexcity;


@end

@implementation FLSelfDataVC

- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        
        _provinceArr= [[NSArray alloc]initWithContentsOfFile:path];
      
    }
    return _provinceArr;
}


#pragma mark- lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sexChoose = @"异性";
    self.city = @"广东 深圳";
    self.cityArr = [@[] mutableCopy];
     FLLog(@"%s",__func__);
    
    self.indexprovince = 5;
    self.indexcity = 9;
   

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

#pragma mark- UI

- (void)initUI
{
    FLUser *user = [FLAccountTool user];
    self.user = user;
    
    NSString *headImgUrl = [NSString stringWithFormat:@"%@/Matchbox%@",BaseUrl,user.url];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"d1.JPG"]];

    self.lbName.text = user.userName;
    self.lbSex.text = user.sex;
    self.lbIntro.text = user.myInfo;
    
     self.lbSexChoose.text = self.sexChoose;
    self.lbCity.text = self.city;
    
    
    
    
}

#pragma mark- events

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

#pragma mark- tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中之后，取消选中
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
    
    if (self.cityCell.selected == YES) {//选择城市
        
        [self setUpCityChoose];
       
    }
    
    if (self.quitLoginCell.selected == YES) {//退出登录
        
        
        
        FLKeyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"FLWelcomeNaviVC"];
     
    }
    
}

- (void)setUpCityChoose
{
    //cover
    UIView *coverView = [[UIView alloc]initWithFrame:FLKeyWindow.bounds];
    [FLKeyWindow addSubview:coverView];
    self.coverView = coverView;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    
    //pickerview
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,FLKeyWindow.height - 200,  FLKeyWindow.width,200)];
    [FLKeyWindow addSubview:pickerView];
    self.pickView = pickerView;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    
//    [self pickerView:self.pickView didSelectRow:0  inComponent:0];
    [self.pickView selectRow:self.indexprovince inComponent:0 animated:NO];
    [self.pickView selectRow:self.indexcity inComponent:1 animated:NO];
    
    
    //toolbar
    UIView *tool = [[UIView alloc]initWithFrame:CGRectMake(0,FLKeyWindow.height - 260,  FLKeyWindow.width, 60)];
    [FLKeyWindow addSubview:tool];
    self.tool = tool;
    tool.backgroundColor = [UIColor whiteColor];
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    [tool addSubview:btnCancel];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancelCity) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnChoose = [[UIButton alloc]initWithFrame:CGRectMake(tool.width- 20 - 40, 10, 40, 40)];
    [btnChoose setTitle:@"完成" forState:UIControlStateNormal];
    [btnChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tool addSubview:btnChoose];
    [btnChoose addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbCity = [[UILabel alloc]initWithFrame:CGRectMake((tool.width-40)/2.0, 10, 40, 40)];
    [tool addSubview:lbCity];
    lbCity.text = @"城市";
    lbCity.textColor = [UIColor blackColor];
    lbCity.font = [UIFont systemFontOfSize:20 weight:0.2];
    
    

}

- (void)cancelCity
{
    [self.coverView removeFromSuperview];
    [self.pickView removeFromSuperview];
    [self.tool removeFromSuperview];
}

- (void)chooseCity
{
    [self.coverView removeFromSuperview];
    [self.pickView removeFromSuperview];
    [self.tool removeFromSuperview];
    
    self.lbCity.text = self.city;
    
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
       
        if ([responseObject[@"result"] integerValue] == 0) {//修改成功
            //重新获取个人数据
            [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetUserInfoById",BaseUrl] param:@{@"userId":@(user.userId)} success:^(id responseObject) {
                if ([responseObject[@"result"] integerValue] == 0) {
                    
                    
                    //保存模型
                    FLUser *user = [FLUser mj_objectWithKeyValues:responseObject];
                    _user = user;
                    [FLAccountTool saveUser:user];
                    
                     [picker dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
            } failure:^(NSError *error) {
                
                
            }];
          
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];

    
}

#pragma mark- pickerView data source
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
      return  self.provinceArr.count;
        
    }
   
    self.cityArr = [self.provinceArr[self.indexprovince] objectForKey:@"cities"];

    return self.cityArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


#pragma mark- pickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
       return  [self.provinceArr[row] objectForKey:@"state"];
    }
    
    self.cityArr = [self.provinceArr[self.indexprovince] objectForKey:@"cities"];

    return self.cityArr[row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 120;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.selectProvince = [self.provinceArr[row] objectForKey:@"state"];
        self.indexprovince = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.selectCity = [self pickerView:pickerView titleForRow:0 forComponent:1];
        self.indexcity = 0;
    
    }
    
    
    if (component == 1) {
        
        self.selectCity = [self pickerView:pickerView titleForRow:row forComponent:component];
        self.indexcity = row;
    }
    
    self.city = [NSString stringWithFormat:@"%@ %@",self.selectProvince,self.selectCity];
}



@end
