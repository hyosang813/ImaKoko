//
//  AppDelegate.m
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//
/********google map iOS SDK情報**************
 Key for iOS apps (with bundle identifiers)
 API key:AIzaSyBA9IHvCGQwkfnFSr0AFBc3h3OiPu52b4Y
 iOS apps:
 com.raksam.ImaKoKo
 Activated on:	Mar 23, 2015 3:52 AM
 Activated by:	hyosang.chong@gmail.com – you
 ********************************************/

#import "AppDelegate.h"
#import "GAI.h" //googleアナリティクス

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    // Google Analyticsの初期化
    [self initializeGoogleAnalytics];
    
    //google map iOS SDKのAPIキー設定
    [GMSServices provideAPIKey:@"AIzaSyBA9IHvCGQwkfnFSr0AFBc3h3OiPu52b4Y"];
    
    //グローバル変数の初期化
//    self.message = [NSString stringWithFormat:NSLocalizedString(@"I am here now!!", nil)];
    self.url = [NSString new];
    self.img = [UIImage new];
//    self.address = [NSString new];
    
    //タブの中身（UIViewController）をインスタンス化
    tab1 = [ViewController new]; // タブ1
    tab2 = [ShareViewController new]; // タブ2
    
    
    tab1.tabBarItem = [UITabBarItem new];
    tab2.tabBarItem = [UITabBarItem new];
    
    //タブバーの画像変更
    tab1.tabBarItem.image = [[UIImage imageNamed:@"tab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    tab2.tabBarItem.image = [[UIImage imageNamed:@"tab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //タブバー画像の位置調整
    tab1.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tab2.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    //まとめてセットするためにArrayに格納
    NSArray *tabs = @[tab1, tab2];
    
    //タブコントローラをインスタンス化
    tabController = [MyTabBarController new];
    
    //タブコントローラにタブの中身をセット
    [tabController setViewControllers:tabs animated:NO];
    
    //rootViewをタブバーコントローラにする
    self.window.rootViewController = tabController;
    
    //タブコントローラのビューをウィンドウに貼付ける
    [self.window addSubview:tabController.view];
    [self.window makeKeyAndVisible];
  
    return YES;
}

//googleアナリティクス用初期化メソッド
- (void)initializeGoogleAnalytics
{
    // トラッキングIDを設定
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60009261-3"];
    
    // 例外を Google Analytics に送る
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
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
