//
//  AppDelegate.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "PLNavigationController.h"
#import "MBGuideViewController.h"
#import "MBConstant.h"
#import "UIImageAdditions.h"
#import "HomeViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"sEw8qvbbjlVz6YxyKKtkRoZP"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //左右侧边栏效果
    HomeViewController * homeVC = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    
    
    
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeVC.title = @"路路帮";
    self.window.rootViewController = navigationController;
    [self setGlogle];
    
    [self.window makeKeyAndVisible];

    
#if 0
    [MBGuideViewController show];//欢迎引导页
#endif
    
    return YES;
}

-(void)setGlogle
{
    //设置应用程序全局外观
    self.window.backgroundColor = [UIColor blackColor];
    if (IOS7_OR_LATER) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: HEX(@"#ffffff"),
                                                                NSFontAttributeName: kBigTitleFont}];
    }else{
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HEX(@"#5ec4fe") size:CGSizeMake(1, kNavigationBarHeight)] forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
             [[UITabBarItem appearance] setTitleTextAttributes:
         @{
           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
           UITextAttributeTextColor: HEX(@"#c20b0d")
           }
                                                 forState:UIControlStateSelected];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes: @{
                                                                UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                                UITextAttributeTextColor: MB_RGB(255, 255, 255) } forState:UIControlStateNormal];
        //        [[UINavigationBar appearance] setTintColor:HEX(@"#c20b0d")];
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                NSFontAttributeName: kBigTitleFont}];
    }

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
