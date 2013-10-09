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

//后台检查登录
-(BOOL)backstageLogin{
    //从用户默认数据中获取用户登录信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoginURL]];
    DDLogCInfo(@"******  Request URL is:%@  ******",kLoginURL);
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:username forKey:@"username"];
    [self.request setPostValue:password forKey:@"password"];
    [self.request startSynchronous];
    NSError *error = [self.request error];
    if (!error) {
        NSString *response = [self.request responseString];
        NSDictionary *dict = [Tool stringToDictionary:response];
        if ([[dict objectForKey:@"error"] intValue]==0) {
            NSDictionary *data = [dict objectForKey:@"data"];
            kSharedApp.accessToken = [data objectForKey:@"accessToken"];
            kSharedApp.expiresIn = [[data objectForKey:@"expiresIn"] intValue];
            kSharedApp.factory = [data objectForKey:@"factory"];
            return YES;
        }else{
//            NSString *msg = [dict objectForKey:@"description"];
            return YES;
        }
        return NO;
    }
}
@end
