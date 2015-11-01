//
//  ViewController.m
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "ViewController.h"
#import "TrackingManager.h"

@interface ViewController ()
@end

@implementation ViewController
{
    UIButton *reload ;
}
- (id)init {
    if (self = [super init]) {
        //タブバーのアイコンを設定
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:101];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //GPS保存状態スイッチ用
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    //GPSの利用可否判断(端末の位置情報サービス)
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [CLLocationManager new]; //ロケーションマネージャをnew
        self.locationManager.delegate = self;           //デリゲートセット
        self.locationManager.distanceFilter = 2000.0;    //位置情報取得間隔を指定する
        [self verDispatch];
        app.OnOff = YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"Please try again <Location Services> on iPhone is set to <ON>", nil)
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        app.OnOff = NO;
    }

    //リロードボタン
    reload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reload.frame = CGRectMake(self.view.bounds.size.width - 60, self.view.bounds.size.height - 110, 50, 50);
    UIImage *img = [UIImage imageNamed:@"reload.png"];
    [reload setBackgroundImage:img forState:UIControlStateNormal];
    [reload addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    // "地図画面"が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"地図画面"];
}



//バージョン別挙動ディスパッチメソッド
- (void)verDispatch
{
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        // iOS バージョンが 8 以上
        [self.locationManager requestAlwaysAuthorization];// 位置情報測位の許可を求めるメッセージを表示する
    } else {
        // iOS バージョンが 8 未満
        [self.locationManager startUpdatingLocation];   //現在地取得開始
        //NSLog(@"Start updating location.");
    }

}

//ユーザ承認チェック
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //GPS保存状態スイッチ用
    AppDelegate *app = [[UIApplication sharedApplication] delegate];

    //GPSの利用可否判断(アプリの位置情報可否)
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 位置情報測位の許可状態が「常に許可」または「使用中のみ」の場合、
        // 測位を開始する（iOS バージョンが 8 以上の場合のみ該当する）
        // ※iOS8 以上の場合、位置情報測位が許可されていない状態で
        // startUpdatingLocation メソッドを呼び出しても、何も行われない。
        [self.locationManager startUpdatingLocation];
        app.OnOff = YES;
    } else {
        //初回起動判定用UserDeaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // 日時が設定済みなら初回起動でない
        if ([userDefaults objectForKey:@"firstRunDate"]) {
            //GPSが使えなかったらアラート表示
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"Please try again in a position information to <Allow> in the setting", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            app.OnOff = NO;
        }
        
        // 初回起動日時を設定して保存
        [userDefaults setObject:[NSDate date] forKey:@"firstRunDate"];
        [userDefaults synchronize];
    }
}

//GPS機能が使えるのが確認できたらこのメソッドを実行
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //位置情報を取り出す
    CLLocation *newLocation = [locations lastObject];
    
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;

    //GMSCameraPositionインスタンスの作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:18.0];
    
    //GMSMapViewインスタンスの作成
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //self.viewをmapViewに差し替え　後でaddSubViewに変えるかも
    self.view = self.mapView;
    
    //現在地にマーカーを落とす
    GMSMarker *marker = [GMSMarker new];
    //marker.title = @"逆ジオコードの結果";
    //marker.snippet = @"逆ジオコードの結果";
    marker.icon = [UIImage imageNamed:@"imakokopin.png"];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.map = self.mapView;
    
    //リロードボタンの配置
    [self.mapView addSubview:reload];
    
    //取得した経度緯度の共有用googlemapのurlを生成してグローバル変数に格納
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSString *latiLong = [@"http://maps.google.com/maps?q=" stringByAppendingString:[[NSString stringWithFormat:@"%f,", latitude] stringByAppendingString:[NSString stringWithFormat:@"%f", longitude]]];

    //上記で生成したurl文字列を短縮アドレスに変換する
    app.url = [self getShortUrl:latiLong];
    
    /********次回のアップデート時でいいかな？*************************************/
    //簡易逆ジオコードサービス(http://www.finds.jp/wsdocs/rgeocode/)を使って経度緯度から大体の住所を取得し、XMLPerserつかってNSStringにしよう
    //自宅の場合「http://www.finds.jp/ws/rgeocode.php?lat=35.719726&lon=140.112299」
    
    //全部終わったら止める
    [self.locationManager stopUpdatingLocation];
}

//短縮URLのゲットメソッド
- (NSString *)getShortUrl:(NSString *)getUrl
{
    //各種情報
    NSString *userName = @"o_15opifnst";
    NSString *apiKey = @"R_c68d9a2793264066a2954631b7262f9e";
    NSString *baseURLString=@"http://api.bit.ly/v3/shorten?&login=%@&apiKey=%@&longUrl=%@&format=txt";
    
    //utf8
    NSString *encodedLongURL = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //url
    NSString *urlString = [NSString stringWithFormat:baseURLString, userName, apiKey, encodedLongURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // bit.lyのAPIをコールする
    NSString *shortenURL = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //NSLog(@"%@", getUrl);
    //NSLog(@"%@", shortenURL);
    
    return shortenURL;
}

//リロードボタン押下時
- (void)reload
{
    [self.locationManager startUpdatingLocation];
    
    //googleアナリティクス用
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"RELOAD" value:nil screen:@"地図画面"];
}

// 測位失敗時や、位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"didFailWithError");
    //設定でGPSをOFFにしてる場合はONにしてください的なメッセージ表示しようかね
}

// タブ選択delegate
- (void)didSelect:(MyTabBarController *)tabBarController {
}

//uiviewが閉じる(タブで遷移する)タイミングで地図を画像化してグローバル変数に保存
- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.img = [self selfViewImageSnapShot];
}

//その時点の地図を画像化して、暗めに調整して返すメソッド
- (UIImage *)selfViewImageSnapShot {
    
    // キャプチャ画像を描画する対象を生成します。
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Windowの現在の表示内容を１つずつ描画して行きます。
    [self.view.layer renderInContext:context];
    
    // 描画した内容をUIImageとして受け取ります。
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画を終了します。
    UIGraphicsEndImageContext();
    
    // イメージを読み込む
    CIImage *ciImage = [[CIImage alloc] initWithImage:capturedImage];
    
    // フィルタで暗さを調節
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, @"inputBrightness", [NSNumber numberWithFloat:-0.55] ,nil];
    
    // 白黒にフィルタした内容をイメージとしてリターン
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgimg scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cgimg);
    
    return returnImage;
}

//メモリワーニング
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
