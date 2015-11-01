//
//  MyTabBarController.h
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/28.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBarController : UITabBarController<UITabBarControllerDelegate>

@end

@protocol MyTabBarControllerDelegate
- (void)didSelect:(MyTabBarController *)tabBarController;
@end