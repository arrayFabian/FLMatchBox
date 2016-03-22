//
//  FLWelcomeVCViewController.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/14.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLWelcomeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FLScrollView.h"
#import "FLSignInVC.h"
#import "FLSignUpVC.h"

@interface FLWelcomeViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic, strong) FLScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIButton *signInBtn;

@property (nonatomic, weak) IBOutlet UIButton *signUpBtn;

@end

@implementation FLWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
  
    
    [self setUpMoviePlayer];
    
    [self setUpScrollView];
   
    [self initBtns];
    
  
    

}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
}

- (void)initBtns
{
    //signIN
   
    [self.view bringSubviewToFront:self.signInBtn];
    [_signInBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _signInBtn.backgroundColor =[UIColor whiteColor];
    _signInBtn.alpha = 0.5;
    
    
    
    //signUp
    [self.view bringSubviewToFront:self.signUpBtn];
    [_signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_signUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _signUpBtn.backgroundColor =[UIColor whiteColor];
    _signUpBtn.alpha = 0.5;
    
    
}



- (void)setUpScrollView
{
    FLScrollView *scrollview = [[FLScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView = scrollview;
    [self.view addSubview:scrollview];
    _scrollView.itemsArr = @[@"火柴盒欢迎页面1",@"火柴盒欢迎页面2",@"火柴盒欢迎页面3",@"火柴盒欢迎页面4",@"火柴盒欢迎页面5"];


}


- (void)setUpMoviePlayer
{
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"welcomeVideo" ofType:@"mp4"]]];
    
    _moviePlayer.view.frame = self.view.bounds;
    _moviePlayer.view.backgroundColor = [UIColor whiteColor];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.repeatMode = MPMovieRepeatModeOne;
    
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer play];
    
    
    
    
}



- (void)dealloc
{
    FLLog(@"%s",__func__);
}


@end
