//
//  AppDelegate.h
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h> //GoogleMapSDK用
#import "ViewController.h" //地図画面
#import "ShareViewController.h" //アプリ選択画面
#import "MyTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController *tab1; //タブの１つめ（地図画面）
    UIViewController *tab2; //タブの２つめ（アプリ選択画面）
    MyTabBarController *tabController; //タブバーコントローラー
}

@property (strong, nonatomic) UIWindow *window;

//グローバル変数的な？
//@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *url;
//@property (strong, nonatomic) NSString *address;

@property BOOL OnOff; //GPS使えるか使えないか
@property (strong, nonatomic) UIImage *img; //地図画面のスナップショット

@end

