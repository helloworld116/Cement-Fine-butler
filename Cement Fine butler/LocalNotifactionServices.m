//
//  LocalNotifactionServices.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LocalNotifactionServices.h"
@interface LocalNotifactionServices()
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@end

static int first=0;

@implementation LocalNotifactionServices

-(void)getNotifactions{
    [self sendRequest];
}

#pragma mark 发送网络请求
-(void) sendRequest{
    DDLogCInfo(@"******  Request URL is:%@  ******",kMessageList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMessageList]];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:1] forKey:@"page"];
    [self.request setPostValue:[NSNumber numberWithInt:1] forKey:@"count"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.request setPostValue:[defaults objectForKey:@"latestMessage"] forKey:@"latestMessage"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{

}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long long latestMessage = [[defaults objectForKey:@"latestMessage"] longLongValue];
        [defaults setObject:[NSNumber numberWithLongLong:latestMessage+30*60*1000] forKey:@"latestMessage"];
        
        NSArray *msgs = [[dict objectForKey:@"data"] objectForKey:@"msgs"];
        for (NSDictionary *msg in msgs) {
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification) {
                NSDate *now=[NSDate new];
                notification.fireDate=[now dateByAddingTimeInterval:10];
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber += 1;
                int msgType = [[msg objectForKey:@"msgType"] intValue];
                if (msgType==0) {
                    notification.alertAction = kMessageType0;
                }else if (msgType==1){
                    notification.alertAction = kMessageType1;
                }else if (msgType==2){
                    notification.alertAction = kMessageType2;
                }else if (msgType==3){
                    notification.alertAction = kMessageType3;
                }
                notification.alertBody=[Tool stringToString:[msg objectForKey:@"msg"]];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            }
        }
    }else{

    }
}
@end
