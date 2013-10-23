//
//  CostReductionViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//成本还原
@interface CostReductionViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) NSString *chartTitle;
@end
