//
//  LossReportViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-12.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LossReportViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,retain) NSDictionary *data;
@property (nonatomic,retain) NSString *dateDesc;
@property (nonatomic) NSInteger type;//0表示物流损耗，1表示原材料，2表示半成品，3表示成品
@end
