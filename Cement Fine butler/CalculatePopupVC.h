//
//  CalculatePopupVC.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-4.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatePopupVC : UIViewController
@property (nonatomic,strong) NSDictionary *defaultValue;
@end


@interface CalculatePopupView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (nonatomic,strong) IBOutlet UITextField *textRate;
@property (nonatomic,strong) IBOutlet UITextField *textFinancePrice;
@property (nonatomic,strong) IBOutlet UITextField *textApportionRate;
@property (nonatomic,strong) IBOutlet UITextField *textPlanPrice;

@property (nonatomic,strong) IBOutlet UIView *view1;
@property (nonatomic,strong) IBOutlet UIView *view2;
@property (nonatomic,strong) IBOutlet UIView *view3;
@property (nonatomic,strong) IBOutlet UIView *view4;
-(IBAction)save:(id)sender;

-(id)initWithDefaultValue:(NSDictionary *)defaultValue;
@end