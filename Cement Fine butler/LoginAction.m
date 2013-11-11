//
//  LoginAction.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LoginAction.h"
@interface LoginAction()
@property (retain, nonatomic) ASIFormDataRequest *request;
@end

@implementation LoginAction

static int loginCount=0;
static int loginCount2=0;

//后台检查登录
-(BOOL)backstageLoginWithSync:(BOOL)sync{
    BOOL loginResult = NO;
    //从用户默认数据中获取用户登录信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoginURL]];
    DDLogCInfo(@"******  Request URL is:%@  ******",kLoginURL);
    [self.request setPostValue:username forKey:@"username"];
    [self.request setPostValue:password forKey:@"password"];
    if (sync) {
        [self.request startSynchronous];
        NSError *error = [self.request error];
        if (!error) {
            NSString *response = [self.request responseString];
            NSDictionary *dict = [Tool stringToDictionary:response];
            if ([[dict objectForKey:@"error"] intValue]==0) {
                NSDictionary *data = [dict objectForKey:@"data"];
                kSharedApp.accessToken = [data objectForKey:@"accessToken"];
                kSharedApp.expiresIn = [[data objectForKey:@"expiresIn"] intValue];
                kSharedApp.factory = [data objectForKey:@"factorys"][0];
                kSharedApp.startFactoryId=kSharedApp.finalFactoryId=[[kSharedApp.factory objectForKey:@"id"] intValue];
                kSharedApp.factorys = [data objectForKey:@"factorys"];
                kSharedApp.user = [data objectForKey:@"user"];
                NSArray *permissions = [data objectForKey:@"permissions"];
                for (NSDictionary *permission in permissions) {
                    if([kMultiGroupCode isEqualToString:[permission objectForKey:@"code"]]){
                        kSharedApp.multiGroup=YES;
                        break;
                    }
                }
                loginResult = YES;
                DDLogCInfo(@"登录成功");
                //防止session过期自动登录
                if (loginCount==0) {
                    [self checkLogin];
                    loginCount++;
                }
            }else{
                //            NSString *msg = [dict objectForKey:@"description"];
                DDLogCError(@"登录失败，%@",@"用户名或密码错误");
            }
        }else{
            DDLogCError(@"登录失败，%@",[error localizedDescription]);
        }
    }else{
        self.request.delegate = self;
        [self.request setDidFailSelector:@selector(requestFailed:)];
        [self.request setDidFinishSelector:@selector(requestSuccess:)];
        [self.request startAsynchronous];
    }
    return loginResult;
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    //    [SVProgressHUD showErrorWithStatus:@"网络请求出错"];
    DDLogCError(@"网络请求出错,%@",[request error]);
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        NSDictionary *data = [dict objectForKey:@"data"];
        kSharedApp.accessToken = [data objectForKey:@"accessToken"];
        kSharedApp.expiresIn = [[data objectForKey:@"expiresIn"] intValue];
        if (loginCount2==0) {
            loginCount2++;
            [self checkLogin];
        }
    }else{
        DDLogCWarn(@"登录失败，errorCode is %d",errorCode);
        //        NSString *msg = [dict objectForKey:@"message"];
    }
}


-(void)checkLogin{
    [NSTimer scheduledTimerWithTimeInterval:kSharedApp.expiresIn-10 target:self selector:@selector(backstageLoginWithSync:) userInfo:nil repeats:YES];
}
@end
