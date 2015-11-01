//
//  TrackingManager.h
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/04/11.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingManager : NSObject

// スクリーン名計測用メソッド
+ (void)sendScreenTracking:(NSString *)screenName;

// イベント計測用メソッド
+ (void)sendEventTracking:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value screen:(NSString *)screen;

@end