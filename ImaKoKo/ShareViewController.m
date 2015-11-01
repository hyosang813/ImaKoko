//
//  ShareViewController.m
//  ImaKoKo
//
//  Created by 大山 孝 on 2015/03/23.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "ShareViewController.h"
#import "TrackingManager.h"

#define MAX_SPACE 60

enum {LINE = 200, TWITTER, FACEBOOK, MAIL, MMS};

@interface ShareViewController ()
@end

@implementation ShareViewController
{
    //iAd用
    ADBannerView *iAdBanner;
    
    //NEND用
    NADView *nadView;
}

#pragma mark - NENDのデリゲートメソッド
// NENDの初回読み込み完了
-(void) nadViewDidFinishLoad:(NADView *)adView
{
}

// NENDの読み込み完了通知
-(void) nadViewDidReceiveAd:(NADView *)adView
{
}

// NENDの読み込み失敗通知
-(void) nadViewDidFailToReceiveAd:(NADView *)adView
{
    nadView.hidden = YES;
}

#pragma mark - iAdデリゲート
//iAdバナー広告のデリゲート：広告読み込み成功
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
}

//iAdバナー広告のデリゲート：広告読み込み失敗
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    iAdBanner.hidden = YES;
}

#pragma mark - 初期化
- (id)init {
    if (self = [super init]) {
        //タブバーのアイコンを設定
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:102];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //カクカクとりあえず回避
    self.view.backgroundColor = [UIColor grayColor];
    
    //ボタン作成用テキストArray
    NSArray *btnText = @[NSLocalizedString(@"LINE de KOKO!", nil), NSLocalizedString(@"Twitter de KOKO!", nil), NSLocalizedString(@"FaceBook de KOKO!", nil), NSLocalizedString(@"Mail de KOKO!", nil), NSLocalizedString(@"SMS/MMS de KOKO!", nil)];
    NSArray *btnTextColor = @[[UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor whiteColor], [UIColor cyanColor]];


    //iphoneの種類によって画面サイズ(高さ)が異なるので間隔を調整　※画面サイズ - (タブバー50＋広告バナー50＋配置開始高さ50＋ボタン５個250＋余白40：合計440) / ボタンとボタンの間4つ
    float kankaku = (self.view.bounds.size.height - 440) / 4;
    
    //iPhone6だと広すぎるから間隔調整
    if(kankaku > MAX_SPACE) kankaku = MAX_SPACE;
    
    //ボタンの作成
    for (int i = 0; i < btnText.count; i++) {
        [self makeButton:CGRectMake(self.view.bounds.size.width / 2 - 150, 50 + (i * (50 + kankaku)), 300, 50) text:btnText[i] tag:i + 200 color:btnTextColor[i]];
    }
    
    //まず言語のリストを取得します。
    NSArray *languages = [NSLocale preferredLanguages];
    // 取得したリストの0番目に、現在選択されている言語の言語コード(日本語なら”ja”)が格納されるので、NSStringに格納します。
    NSString *languageID = languages[0];
    
    // 日本語の場合はNEND、それ以外はiADにする
    if ([languageID isEqualToString:@"ja"]) {
        //NEND
        nadView = [[NADView alloc] init];
        nadView.frame = CGRectMake((self.view.bounds.size.width / 2) - 160 , self.view.bounds.size.height - 99, self.view.bounds.size.width, nadView.bounds.size.height);
        [nadView setIsOutputLog:NO];
        [nadView setNendID:@"46d10daf920d4a0fd97313b7f66c28e73a92090a" spotID:@"344691"]; //本番用
//        [nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"];   //テスト用
        nadView.delegate = self;
        [nadView load];
        nadView.hidden = NO;
        [self.view addSubview:nadView];
    } else {
        //iAd
        iAdBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];//initWithAdType:ADAdTypeBannerって何？
        iAdBanner.frame = CGRectMake(0, self.view.bounds.size.height - 99, self.view.bounds.size.width, iAdBanner.frame.size.height);
        iAdBanner.hidden = NO;
        iAdBanner.delegate = self;
        [self.view addSubview:iAdBanner];
    }
    
    // "アプリ選択画面"が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"アプリ選択画面"];
}

//通常のボタン生成メソッド
- (void)makeButton:(CGRect)rect text:(NSString *)text tag:(int)tag color:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:rect];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal]; //通常時の文字色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted]; //ハイライト時の文字色
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:28]];
    [btn setTag:tag];
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [[btn layer] setBorderColor:[color CGColor]]; // 枠線の色
    [[btn layer] setBorderWidth:5.0]; // 枠線の太さ

    [self.view addSubview:btn];
}

//ボタンクリック時の挙動
- (void)clickButton:(UIButton *)sender
{
    //AppDelegateで保存してあるurlを抽出
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    //　※連係の文字列にアプリのタグ入れる？？？「#ImaKoKo」とか？？？
    
    //冒頭の文字列を生成
    NSString *string = [[NSLocalizedString(@"I am here now!!", nil) stringByAppendingString:@"\n"] stringByAppendingString:app.url];
    
    //TwitterとFBの場合はタグを最後につけようかね
    NSString *stringTF = [[string stringByAppendingString:@"\n"] stringByAppendingString:NSLocalizedString(@"#ImaKoKo", nil)];
    
    //LINEの場合
    if(sender.tag == LINE){
        //エンコードしてLINE文字列を生成
        NSString *LINEUrlString = [NSString stringWithFormat:@"line://msg/text/%@", [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //LINEインストールチェック
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:LINEUrlString]]) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"<LINE> app is not installed", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINEUrlString]];
        
        //googleアナリティクス用
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"LINE" value:nil screen:@"アプリ選択画面"];
    
    //Twitterの場合
    } else if (sender.tag == TWITTER) {
        //アカウント設定チェック
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"Please set the Twitter account in the iPhone settings screen", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:stringTF];
        [self presentViewController:twitter animated:YES completion:nil];
        
        //googleアナリティクス用
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"Twitter" value:nil screen:@"アプリ選択画面"];
    
    //FACEBOOKの場合
    } else if (sender.tag == FACEBOOK) {
        //アカウント設定チェック
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"Please set the Facebook account in the iPhone settings screen", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebook setInitialText:stringTF];
        [self presentViewController:facebook animated:YES completion:nil];
        
        //googleアナリティクス用
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"Facebook" value:nil screen:@"アプリ選択画面"];
    
    //メールの場合
    } else if (sender.tag == MAIL) {
        //メール送信可能？チェック
        if (![MFMailComposeViewController canSendMail]) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"Please check the settings of <Mail>", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        //メールコントローラ生成
        MFMailComposeViewController *pickerCtl = [MFMailComposeViewController new];
        pickerCtl.mailComposeDelegate = self;
        
        //件名設定
        [pickerCtl setSubject:NSLocalizedString(@"I am here now!!", nil)];
        
        //モーダル画面遷移
        [self presentViewController:pickerCtl animated:YES completion:nil];
        
        //メールテキストの指定
        [pickerCtl setMessageBody:string isHTML:NO];

        //googleアナリティクス用
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"Mail" value:nil screen:@"アプリ選択画面"];
        
    //SMS/MMSの場合
    } else if (sender.tag == MMS) {
        //メール送信可能？チェック
        if (![MFMessageComposeViewController canSendText]) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"Please check the settings of <SMS/MMS>", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
    
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = string;
        //モーダル画面遷移
        [self presentViewController:picker animated:YES completion:nil];
        
        //googleアナリティクス用
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"SMS/MMS" value:nil screen:@"アプリ選択画面"];
    
    }
}

// タブ選択delegate
- (void)didSelect:(MyTabBarController *)tabBarController {
    //GPSが使えなかったらボタン非活性
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.OnOff) {
        NSArray *btnTextColor = @[[UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor whiteColor]];
        for (int i = 200; i < 204; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i];
            btn.enabled = YES;
            [btn setTitleColor:btnTextColor[i - 200] forState:UIControlStateNormal]; //通常時の文字色
            [[btn layer] setBorderColor:[btnTextColor[i - 200] CGColor]]; // 枠線の色
        }
    } else {
        for (int i = 200; i < 204; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i];
            btn.enabled = NO;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal]; //通常時の文字色
            [[btn layer] setBorderColor:[[UIColor lightGrayColor] CGColor]]; // 枠線の色
        }
        //GPSが使えなかったらアラート表示
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"Please check the location information setting of iPhone or application", nil)
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    //画像を背景に設定
    self.view.backgroundColor = [UIColor colorWithPatternImage:app.img];

}

//メモリワーニング
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//メール送信終了時にコール
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //オープン中のメール送信画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

//SMS/MMS連携用デリゲートプロトコルの必須メソッド
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //オープン中のSMS/MMS画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
