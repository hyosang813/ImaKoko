//
//  MyTabBarController.m
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/28.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// タブ選択delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(MyTabBarControllerDelegate)]) {
        [(UIViewController < MyTabBarControllerDelegate > *) viewController didSelect : self];
    }
}

@end