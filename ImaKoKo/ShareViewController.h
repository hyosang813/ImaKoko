//
//  ShareViewController.h
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> //ボタンの枠線用
#import <Social/Social.h> //SNS連携用
#import <MessageUI/MessageUI.h> //メール用
#import <MessageUI/MFMessageComposeViewController.h> //SMS/MMS用
#import <iAd/iAd.h> //iAd用
#import "NADView.h" //Nend用
#import "AppDelegate.h"
#import "MyTabBarController.h"

@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, MyTabBarControllerDelegate, ADBannerViewDelegate, NADViewDelegate>

@end
