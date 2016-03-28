//
//  AppDelegate.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/14.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "AppDelegate.h"
#import "FLWelcomeViewController.h"
#import "FLWelcomeNaviVC.h"
#import "FLTabBarController.h"

#import "FLAccountTool.h"
#import "FLAccount.h"
#import "FLUser.h"

#import "FLHttpTool.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import <MJExtension.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setUpIQKeyboard];
    
    [self autoLogin];
    
   
    
    
   
    

    
    return YES;
}



- (void)autoLogin
{
    FLAccount *account = [FLAccountTool account];
    
    if (account.password && account.name) {
        
        FLTabBarController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLTabBarController"];
        self.window.rootViewController = tabBarVC;
        
        //登入请求
     
        NSDictionary *param = @{@"password":account.password,
                                @"name":account.name };
        
        
        [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/useruserlogin",BaseUrl] param:param success:^(id responseObject) {
          
            NSDictionary *result = responseObject;
            if ([result[@"result"] integerValue] == 0) {
                
                NSDictionary *accountDict = @{@"password":account.password,
                                              @"name":account.name,
                                              @"userId":result[@"userId"]};
                FLAccount *account = [FLAccount accountWithDict:accountDict];
                [FLAccountTool saveAccount:account];
                
                
                // 登录成功后拿到的数据不全 利用userId重新请求
                
                [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/usergetUserInfoById",BaseUrl] param:@{@"userId":result[@"userId"]} success:^(id responseObject) {
                    
                    NSDictionary *dict = responseObject;
                    FLUser *user = [FLUser mj_objectWithKeyValues:dict];
                    [FLAccountTool saveUser:user];
                    
                    
                 
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
                
                
            }
            
            
        } failure:^(NSError *error) {
            
           
        }];
        
        
        
    }else{
        FLWelcomeNaviVC *navi = [[UIStoryboard storyboardWithName:@"Login" bundle:nil]instantiateInitialViewController];
        self.window.rootViewController = navi;
    }
    
    
    
    
}

- (void)setUpIQKeyboard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.keyboardDistanceFromTextField = 100;
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    keyboardManager.shouldShowTextFieldPlaceholder = NO;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
