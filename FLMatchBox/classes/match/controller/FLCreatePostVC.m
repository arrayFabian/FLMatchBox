//
//  FLCreatePostVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/4/6.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLCreatePostVC.h"


#import <Masonry.h>
#import <HYBNetworking.h>
#import <MMSheetView.h>
#import "ProgressView.h"
#import "FLUser.h"

@interface FLCreatePostVC ()<UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) UIScrollView * scroll;
@property (strong, nonatomic) UITextView * tv;
@property (strong, nonatomic) UIButton * btnPost;
@property (strong, nonatomic) UIButton * btnSelect;
@property (strong, nonatomic) UIImage * selectImage;





@end

@implementation FLCreatePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     [self initUI];
    
    
    
}


- (void)initUI
{
    //-----------------------------------
    // 1.titleView
    UIView * titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@44);
        make.top.mas_equalTo(self.view).offset(20);
    }];
    
    
    UIButton * btnCancle = [UIButton new];
    [btnCancle addTarget:self action:@selector(btncancleCLick) forControlEvents:UIControlEventTouchUpInside];
    [btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancle setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [titleView addSubview:btnCancle];
    btnCancle.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleView.mas_leading).offset(10);
        make.centerY.mas_equalTo(titleView);
    }];
    
    UILabel * lbtitle = [UILabel new];
    [titleView addSubview:lbtitle];
    lbtitle.text = self.topicName;
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(titleView);
    }];
    
    UIButton * btnPost = [UIButton new];
    _btnPost = btnPost;
    [btnPost setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [btnPost setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnPost setTitle:@"发布" forState:UIControlStateNormal];
    btnPost.enabled = NO;
    btnPost.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleView addSubview:btnPost];
    [btnPost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(titleView).offset(-10);
        make.centerY.mas_equalTo(titleView);
    }];
    [btnPost addTarget:self action:@selector(btnPostCLick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor grayColor];
    [titleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.leading.trailing.bottom.mas_equalTo(titleView);
    }];
    
    
    //-----------------------------------
    // scrollview
    UIScrollView * scroll = [UIScrollView new];
    _scroll = scroll;
    
    _scroll.delegate = self;
    
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    // 创建一个子view
    UIView * contentView = [UIView new];
    // 将一个contentview添加到scroll中
    [scroll addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(scroll);
        make.width.mas_equalTo(self.view);
    }];
    
    
    //-----------------------------------
    // uitextview
    UITextView * tv = [UITextView new];
    _tv = tv;
    tv.scrollEnabled = NO;
    tv.tintColor = MAINCOLOR;
    [contentView addSubview:tv];
    tv.delegate = self;
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView).offset(8);
        make.trailing.mas_equalTo(contentView).offset(-8);
        make.top.mas_equalTo(contentView).offset(8);
        make.height.mas_greaterThanOrEqualTo(@100);
    }];
    
    
    UIButton * btn = [UIButton new];
    _btnSelect = btn;
    [contentView addSubview:btn];
    [btn addTarget:self action:@selector(selectImg) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.leading.mas_equalTo(tv).offset(8);
        make.top.mas_equalTo(tv.mas_bottom).offset(8);
        make.bottom.mas_equalTo(contentView).offset(-8);
    }];
    
    UILabel * lb = [UILabel new];
    [self.view addSubview:lb];
    lb.text = @"添加图片";
    lb.font = [UIFont systemFontOfSize:10];
    lb.textColor = [UIColor grayColor];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn);
        make.leading.mas_equalTo(btn.mas_trailing).offset(8);
    }];
    
    
    
}

- (void)selectImg
{
    
    [self.tv resignFirstResponder];
    
    MMPopupItem * item1 = MMItemMake(@"相册", MMItemTypeNormal, ^(NSInteger index) {
        UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    });
    
    MMPopupItem * item2 = MMItemMake(@"拍照", MMItemTypeHighlight, ^(NSInteger index) {
        UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    });
    MMSheetView * sheetView = [[MMSheetView alloc]initWithTitle:@"选择一张图片" items:@[item1,item2]];
    [sheetView show];
    sheetView.showCompletionBlock = ^(MMPopupView * popView,BOOL isfinish)
    {
        
    };
    
}


- (void)btncancleCLick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnPostCLick {
    [self.view endEditing:YES];
    
    if (_tv.text.length < 1) {
        return;
    }
    
    NSMutableDictionary * dict = [@{
                                    @"friendCircle.user.id":@([kUserModel userId]),
                                    @"friendCircle.topic.id":@(self.topicId),
                                    @"friendCircle.msg":_tv.text
                                    } mutableCopy];
    
    //    ProgressView * view = [[ProgressView alloc]init];
    //    view.backgroundColor = [UIColor blackColor];
    //    [view mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(50, 50));
    //        make.center.mas_equalTo(self.view);
    //    }];
    //    [self.view addSubview:view];
    
    
    __weak __typeof(&*self) weakSelf = self;
    if (_selectImage) {
        [dict setObject:@2 forKey:@"type"];
        [HYBNetworking uploadWithImage:_selectImage url:@"/Matchbox/userpostFriendCircle" filename:@"abc.jpg" name:@"pic" mimeType:@"image/jpeg" parameters:dict progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
            //            view.persent = (CGFloat)bytesWritten/totalBytesWritten;
        } success:^(id response) {
            NSDictionary * dict = response;
            if ([dict[@"result"]integerValue] == 0) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
        } fail:^(NSError *error) {
            FLLog(@"%@",error);
        }];
    }else
    {
        [dict setObject:@1 forKey:@"type"];
        [HYBNetworking postWithUrl:@"/Matchbox/userpostFriendCircle" params:dict success:^(id response) {
            NSDictionary * dict = response;
            if ([dict[@"result"]integerValue] == 0) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        } fail:^(NSError *error) {
            
        }];
    }
    
    
    
    
    
    
}


/******************** tv delegate *********************/
- (void)textViewDidChange:(UITextView *)textView
{
    _btnPost.enabled =  textView.text.length>0?YES:NO;
    
    
    CGSize size = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(self.view.bounds.size.width-16, MAXFLOAT)];
    if (size.height<100) {
        size.height = 100;
    }
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(size.height+20));
    }];
    // 要求高度 - 实际显示高度  == 应该偏移量
    CGFloat shuldOffsex = size.height - (self.view.bounds.size.height/2.0 - 64);
    NSLog(@"%f",shuldOffsex);
    if (shuldOffsex > 0) {
        [_scroll setContentOffset:CGPointMake(0, shuldOffsex)];
        
    }
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _scroll.contentInset = UIEdgeInsetsMake(0, 0, self.view.bounds.size.height/2.0, 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_scroll == scrollView) {
        [self.view endEditing:YES];
    }
    
}

/******************** 选择图片的代理 *********************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"--> %@",info);
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _selectImage = image;
    [self.btnSelect setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



@end
