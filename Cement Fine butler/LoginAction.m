//
//  LoginAction.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LoginAction.h"

@implementation LoginAction

//后台检查登录
-(BOOL)backstageLogin{
    //清空登录信息
//    self.uid = nil;
//    self.username = nil;
//    self.email = nil;
//    self.ticket = nil;
//    self.password = nil;
//    //从用户默认数据中获取用户登录信息
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.email = [defaults objectForKey:@"email"];
//    self.password = [defaults objectForKey:@"password"];
//    //执行登录操作
//    NSDictionary *result = [NSDictionary dictionaryWithContentsOfJSONURLString:kUrlOfLogin];
//    if (1==[[result objectForKey:@"status"] intValue]) {
//        self.uid = [result objectForKey:@"uid"];
//        self.username = [result objectForKey:@"uname"];
//        self.email = [result objectForKey:@"email"];
//        self.ticket = [result objectForKey:@"ticket"];
//        return YES;
//    }else {
//        return NO;
//    }
}
@end
