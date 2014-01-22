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
//正确响应时后续处理
-(void)responseCode0WithData;
//错误响应时后续处理
-(void)responseWithOtherCode;
@optional
//设置请求参数
-(void)setRequestParams;
//清除发送请求时界面或数据
-(void)clear;
//响应码为0,但是数据为空，data is null
-(void)responseCode0WithNOData;
@end

@interface CommonViewController : BaseViewController<MBProgressHUDDelegate,CommonVCDataSource>
@property (retain, nonatomic) NSString *URL;
@property (retain, nonatomic) SearchCondition *condition;//请求条件
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSDictionary *responseData;//响应的最原始数据
@property (strong, nonatomic) NSDictionary *data;//响应数据的data部分
@property (retain, nonatomic) PromptMessageView *messageView;//请求出错或没有响应数据时响应页面
@property (retain, nonatomic) RightViewController *rightVC;
@property (retain, nonatomic) LeftViewController *leftVC;
-(void) sendRequest;
@end