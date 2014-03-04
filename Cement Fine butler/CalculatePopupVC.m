//
//  CalculatePopupVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-4.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CalculatePopupVC.h"
@implementation CalculatePopupView

-(id)initWithDefaultValue:(NSDictionary *)defaultValue{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CalculatePopupView" owner:self options:nil] objectAtIndex:0];
        self.view1.layer.borderColor = [[Tool hexStringToColor:@"#49bbed"] CGColor];
        self.view1.layer.borderWidth = 1.0f;
        self.view1.layer.cornerRadius = 2.0f;
        self.view2.layer.borderColor = [[Tool hexStringToColor:@"#49bbed"] CGColor];
        self.view2.layer.borderWidth = 1.0f;
        self.view2.layer.cornerRadius = 2.0f;
        self.view3.layer.borderColor = [[Tool hexStringToColor:@"#49bbed"] CGColor];
        self.view3.layer.borderWidth = 1.0f;
        self.view3.layer.cornerRadius = 2.0f;
        self.view4.layer.borderColor = [[Tool hexStringToColor:@"#49bbed"] CGColor];
        self.view4.layer.borderWidth = 1.0f;
        self.view4.layer.cornerRadius = 2.0f;
        
        self.textRate.delegate = self;
        self.textFinancePrice.delegate = self;
        self.textApportionRate.delegate = self;
        self.textPlanPrice.delegate = self;
        self.lblName.text = [defaultValue objectForKey:@"name"];
        self.textRate.text = [NSString stringWithFormat:@"%.2f",[[defaultValue objectForKey:@"rate"] doubleValue]];
        self.textFinancePrice.text = [NSString stringWithFormat:@"%.2f",[[defaultValue objectForKey:@"financePrice"] doubleValue]];
        self.textApportionRate.text = [NSString stringWithFormat:@"%.2f",[[defaultValue objectForKey:@"apportionRate"] doubleValue]];
        self.textPlanPrice.text = [NSString stringWithFormat:@"%.2f",[[defaultValue objectForKey:@"planPrice"] doubleValue]];
    }
    return self;

}

-(IBAction)save:(id)sender{
    NSString *rate = [self.textRate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!rate) {
        rate = @"";
    }
    NSString *financePrice = [self.textFinancePrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!financePrice) {
        financePrice = @"";
    }
    NSString *planPrice = [self.textPlanPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!planPrice) {
        planPrice = @"";
    }
    NSString *apportionRate = [self.textApportionRate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!apportionRate) {
        apportionRate = @"";
    }
    
    NSDictionary *updateData = @{@"name":self.lblName.text,@"rate":[NSNumber numberWithDouble:[Tool doubleValue:rate]],@"financePrice":[NSNumber numberWithDouble:[Tool doubleValue:financePrice]],@"planPrice":[NSNumber numberWithDouble:[Tool doubleValue:planPrice]],@"apportionRate":[NSNumber numberWithDouble:[Tool doubleValue:apportionRate]]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalculateData" object:nil];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:self];
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.superview.frame;
    //如果屏幕已经上移过，就不上移。
    if (frame.origin.y < 80){
        return;
    }
    frame.origin.y -=100;
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.superview.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.superview.frame;
    frame.origin.y +=80;
    //    frame.size. height -=216;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.superview.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

@end


@interface CalculatePopupVC ()

@end

@implementation CalculatePopupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CalculatePopupView *popupView = [[CalculatePopupView alloc] initWithDefaultValue:self.defaultValue];
    self.view.frame = popupView.frame;
    self.view.layer.cornerRadius = 5;
    [self.view addSubview:popupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
