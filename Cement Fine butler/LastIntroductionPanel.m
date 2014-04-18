//
//  LastIntroductionPanel.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-4-14.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "LastIntroductionPanel.h"
#import "LoginAction.h"

@implementation LastIntroductionPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [[NSBundle mainBundle] loadNibNamed:@"LastIntroductionPanel" owner:self options:nil][0];
    if (self) {
        // Initialization code
//        [self.btn setBackgroundColor:[Tool hexStringToColor:@"#49ceff"] forUIControlState:UIControlStateNormal];
//        [self.btn setBackgroundColor:[Tool hexStringToColor:@"#06b5f5"] forUIControlState:UIControlStateHighlighted];
        [self.btn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"intr_button" ofType:@".png"]] forState:UIControlStateNormal];
        [self.btn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"intr_buttonclick" ofType:@".png"]] forState:UIControlStateHighlighted];
        [self.btn.layer setCornerRadius:5.f];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Interaction Methods
//Override them if you want them!

-(void)panelDidAppear{
    //You can use a MYIntroductionPanel subclass to create custom events and transitions for your introduction view
    [self.parentIntroductionView setEnabled:NO];
}
//
//-(void)panelDidDisappear{
//    NSLog(@"Panel Did Disappear");
//    
//    //Maybe here you want to reset the panel in case someone goes backward and the comes back to your panel
////    CongratulationsView.alpha = 0;
//}

#pragma mark Outlets
- (IBAction)didPressEnable:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [UIView animateWithDuration:0.3 animations:^{
        //从用户默认数据中获取用户登录信息
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:@"username"];
        NSString *password = [defaults objectForKey:@"password"];
        if([Tool isNullOrNil:username]||[Tool isNullOrNil:password]){
            self.window.rootViewController = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        }else{
            LoginAction *loginAction = [[LoginAction alloc] init];
            if ([loginAction backstageLoginWithSync:YES]) {
                //自动登录成功
                self.window.rootViewController = [kSharedApp showViewControllers];
                //预警消息
                [kSharedApp.notifactionServices performSelector:@selector(getNotifactions) withObject:nil afterDelay:10];
                kSharedApp.messageTimer = [NSTimer scheduledTimerWithTimeInterval:kGetMessageSeconds target:kSharedApp.notifactionServices selector:@selector(getNotifactions) userInfo:nil repeats:YES];
            }else{
                //自动登录失败
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误消息" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                self.window.rootViewController = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            }
        }
    }];
}

@end
