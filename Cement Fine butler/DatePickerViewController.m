//
//  DatePickerViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-9.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

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
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateAndTime =  [dateFormatter stringFromDate:currentDate];
    self.navigationItem.title = @"选择起止日期";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *startDate = [defaults valueForKey:@"startDate"];
    NSDictionary *endDate = [defaults valueForKey:@"endDate"];
    self.lblStartDate.text = [NSString stringWithFormat:@"%d-%d-%d",[[startDate objectForKey:@"year"] intValue],[[startDate objectForKey:@"month"] intValue],[[startDate objectForKey:@"day"] intValue]];
    self.lblEndDate.text = [NSString stringWithFormat:@"%d-%d-%d",[[endDate objectForKey:@"year"] intValue],[[endDate objectForKey:@"month"] intValue],[[endDate objectForKey:@"day"] intValue]];
    if (IS_IPHONE_5) {
//        self.datePickerOfStart.frame = CGRectMake
        CGRect datePickerFrame = self.datePickerOfStart.frame;
        datePickerFrame.origin.y += 88.f;
        self.datePickerOfStart.frame = datePickerFrame;
        self.datePickerOfEnd.frame = datePickerFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDatePickerOfStart:nil];
    [self setDatePickerOfEnd:nil];
    [self setLblStartDate:nil];
    [self setLblEndDate:nil];
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sureDate:(id)sender {
    self.datePickerOfStart.hidden = YES;
    self.datePickerOfEnd.hidden = YES;
    NSDate *beginDate = self.datePickerOfStart.date;
    NSDate *endDate = self.datePickerOfEnd.date;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *beginComponents = [calendar components: unitFlags fromDate: beginDate];
    int beginYear = [beginComponents year];
    int beginMonth = [beginComponents month];
    int beginDay = [beginComponents day];
    
    NSDateComponents *endComponents = [calendar components: unitFlags fromDate: endDate];
    int endYear = [endComponents year];
    int endMonth = [endComponents month];
    int endDay = [endComponents day];
    
    NSDictionary *beginDateDict = @{@"year":[NSNumber numberWithInt:beginYear],@"month":[NSNumber numberWithInt:beginMonth],@"day":[NSNumber numberWithInt:beginDay]};
    NSDictionary *endDateDict = @{@"year":[NSNumber numberWithInt:endYear],@"month":[NSNumber numberWithInt:endMonth],@"day":[NSNumber numberWithInt:endDay]};
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:beginDateDict forKey:@"startDate"];
    [userDefault setObject:endDateDict forKey:@"endDate"];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backgroundTouch:(id)sender {
    self.datePickerOfStart.hidden = YES;
    self.datePickerOfEnd.hidden = YES;
}

- (IBAction)choiceStartDate:(id)sender {
    self.datePickerOfStart.hidden = NO;
    self.datePickerOfEnd.hidden = YES;
}

- (IBAction)choiceEndDate:(id)sender {
    self.datePickerOfEnd.hidden = NO;
    self.datePickerOfStart.hidden = YES;
}

- (IBAction)updateStartDate:(id)sender {
    NSDate *select = [self.datePickerOfStart date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.lblStartDate.text = dateAndTime;
    //更新enddate的最小值
//    self.datePickerOfEnd.minimumDate = self.datePickerOfStart.date;
}

- (IBAction)updateEndDate:(id)sender {
    NSDate *select = [self.datePickerOfEnd date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.lblEndDate.text = dateAndTime;
    //更新startdate的最大值
//    self.datePickerOfStart.maximumDate = self.datePickerOfEnd.date;
}
@end
