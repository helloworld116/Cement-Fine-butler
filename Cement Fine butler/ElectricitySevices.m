//
//  ElectricitySevices.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-13.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectricitySevices.h"
@interface ElectricitySevices()
@property (retain, nonatomic) ASIFormDataRequest *request;
@end

@implementation ElectricitySevices
//-(BOOL)addEle{
//}
//-(BOOL)updateEle{
//}
//-(BOOL)deleteEle{
//}
//
//-(NSArray *)queryEles{
//    DDLogCInfo(@"******  Request URL is:%@  ******",kElectricityList);
//    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kElectricityList]];
//    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
//    [self.request setUseCookiePersistence:YES];
//    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
//    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
//    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
//    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
//    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"rows"];
//    [self.request setDelegate:self];
//    [self.request setDidFailSelector:@selector(requestFailed:)];
//    [self.request setDidFinishSelector:@selector(requestSuccess:)];
//    [self.request startAsynchronous];
//}
@end
