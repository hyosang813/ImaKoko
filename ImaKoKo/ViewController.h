//
//  ViewController.h
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h> //GoogleMapSDK用
#import <CoreGraphics/CoreGraphics.h> //イメージ保存用
#import <QuartzCore/QuartzCore.h> //イメージ保存用
#import "MyTabBarController.h"
#import "AppDelegate.h"


@interface ViewController : UIViewController<CLLocationManagerDelegate, MyTabBarControllerDelegate>

@property (nonatomic, strong) GMSMapView *mapView; //GoogleMap用
@property (nonatomic, strong) CLLocationManager *locationManager; //GoogleMap用

@end


