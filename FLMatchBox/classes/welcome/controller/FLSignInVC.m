//
//  FLSignInVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSignInVC.h"
#import "FLSignUpVC.h"

#import "FLThreeSignInView.h"


#define APPW [UIScreen mainScreen].bounds.size.width
#define APPH [UIScreen mainScreen].bounds.size.height

@interface FLSignInVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *chooceCountryBtn;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UITextField *shortCutTf;
@property (weak, nonatomic) IBOutlet UITextField *photoNumTf;
@property (weak, nonatomic) IBOutlet UITextField *PSWtf;

@property (weak, nonatomic) IBOutlet UIButton *LogInBtn;

@property (weak, nonatomic) IBOutlet UIButton *pswHelpBtn;





@property (nonatomic, weak) FLThreeSignInView *threeView;

@end

@implementation FLSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    
   // [self setUpThreeView];
    
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem.customView.hidden = self.hideRightBarItem;
   
}


- (void)gotoRegister
{
    FLSignUpVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLSignUpVC"];
    [vc setValue:@YES forKey:@"hideRightBarItem"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setUpThreeView
{
    FLThreeSignInView *threeView = [[[NSBundle mainBundle]loadNibNamed:@"FLThreeSignInView" owner:nil options:nil] lastObject];
    threeView.frame = CGRectMake(0,self.view.bounds.size.height - 100 ,self.view.bounds.size.width , 100);
    self.threeView = threeView;
    [self.view addSubview:threeView];
}
- (IBAction)loginBtnClick:(id)sender
{
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
}

- (IBAction)pswHelpBtnClick:(id)sender {
}

- (void)dealloc
{
     FLLog(@"%s",__func__);
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
