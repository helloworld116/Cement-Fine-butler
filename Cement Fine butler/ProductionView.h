//
//  ProductionView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-28.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductionView : UIView
@property (nonatomic,strong) IBOutlet UIView *viewTop;
@property (nonatomic,strong) IBOutlet UIButton *btnToday;
@property (nonatomic,strong) IBOutlet UIButton *btnYestaday;
@property (nonatomic,strong) IBOutlet UIButton *btnCurrentMonth;
@property (nonatomic,strong) IBOutlet UIButton *btnCurrentYear;

@property (nonatomic,strong) IBOutlet UIScrollView *scrollVBttom;

/**
 *  <#Description#>
 *
 *  @param index 0表示今天，1表示昨天，2表示本月，3是本年
 */
-(void)showSelectedIndx:(NSInteger)selectedIndex;

/**
 *  取消网络请求
 */
-(void)cancelRequest;
@end
