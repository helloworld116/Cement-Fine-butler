//
//  CommonViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonVCDataSource<NSObject>

@required
-(void)responseCode0;
-(void)responseWithOtherCode;

@optional
-(void)setRequestParams;

@end

@interface CommonViewController : UIViewController<MBProgressHUDDelegate,CommonVCDataSource>
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSDictionary *responseData;
@property (retain, nonatomic) PromptMessageView *messageView;//请求出错或没有响应数据时响应页面
@end