//
//  AboutVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-21.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "AboutVC.h"
#import "VersionService.h"

@interface AboutVC ()<MBProgressHUDDelegate>
@property (nonatomic,retain) IBOutlet UIImageView *imgViewIcon;
@property (nonatomic,retain) IBOutlet UILabel *lblVersion;
@property (nonatomic,retain) IBOutlet UILabel *lblBuildVersion;

@property (nonatomic,copy) NSString *trackViewURL;
@property (nonatomic,copy) NSString *appVersionShortString;
@property (nonatomic,retain) MBProgressHUD *HUD;

-(IBAction)exit:(id)sender;
-(IBAction)checkVersion:(id)sender;
@end

@implementation AboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.title = @"关于";
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    self.appVersionShortString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"版本 v%@",self.appVersionShortString];
    self.lblBuildVersion.text = [NSString stringWithFormat:@"(%@)",appVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)exit:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 778899;
    [alertView show];
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 778899) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"password"];
                //        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                //        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                kSharedApp.accessToken=nil;
                kSharedApp.expiresIn=0;
                kSharedApp.factorys=nil;
                kSharedApp.factory=nil;
                kSharedApp.user=nil;
                kSharedApp.multiGroup=NO;
                //取消自动登录服务
                [kSharedApp.loginTimer invalidate];
                //取消定时获取消息服务
                [kSharedApp.messageTimer invalidate];
                //取消所有本地通知
                NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                }
                LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                kSharedApp.window.rootViewController = loginViewController;
            }
                break;
            default:
                break;
        }
    }else if(alertView.tag == 778900){
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewURL]];
                break;
            default:
                break;
        }
    }
}

-(IBAction)checkVersion:(id)sender{
    [self onCheckVersion:self.appVersionShortString];
}

-(void)onCheckVersion:(NSString *)currentVersion
{
    NSString *URL = kAPPURL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [Tool stringToDictionary:results];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            self.trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新",nil];
            alert.tag = 778900;
            [alert show];
        } else{
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            CGRect rect = HUD.frame;
            rect.size = CGSizeMake(96, 96);
            HUD.frame = rect;
            HUD.color = [Tool hexStringToColor:@"#2f3843"];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = @"已是最新版本";
            HUD.labelFont = [UIFont systemFontOfSize:12];
            
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        }
   }
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[self.HUD removeFromSuperview];
	self.HUD = nil;
}


//NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:self.HUD];
//    CGRect rect = self.HUD.frame;
//    rect.size = CGSizeMake(96, 96);
//    self.HUD.frame = rect;
//    self.HUD.delegate = self;
//    self.HUD.color = [Tool hexStringToColor:@"#2f3843"];
//    self.HUD.labelText = @"正在检查";
//    [self.HUD show:YES];
//}];
//NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//[queue addOperation:operation];
//[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//    NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [Tool stringToDictionary:results];
//    NSArray *infoArray = [dic objectForKey:@"results"];
//    if ([infoArray count]) {
//        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
//        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
//        
//        if (![lastVersion isEqualToString:currentVersion]) {
//            self.trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新",nil];
//            [alert show];
//        } else{
//            
//            
//            self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//            
//            // Set custom view mode
//            self.HUD.mode = MBProgressHUDModeCustomView;
//            self.HUD.labelText = @"已是最新版本";
//            self.HUD.labelFont = [UIFont systemFontOfSize:12];
//            
//            [self.HUD hide:YES afterDelay:3];
//        }
//    }
//}];
@end
