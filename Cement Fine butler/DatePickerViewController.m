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
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:currentDate];
    self.lblStartDate.text = dateAndTime;
    self.lblEndDate.text = dateAndTime;
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
    NSLog(@"before controller is %@",self.presentingViewController);
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sureDate:(id)sender {
    self.datePickerOfStart.hidden = YES;
    self.datePickerOfEnd.hidden = YES;
    NSLog(@"before presentingViewController  is %@",self.presentingViewController );
    NSLog(@"before presentedViewController  is %@",self.presentedViewController);
    NSLog(@"before parentViewController is %@",self.parentViewController);
    NSLog(@"before splitViewController is %@",self.splitViewController);
    NSLog(@"before searchDisplayController is %@",self.searchDisplayController);
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
}

- (IBAction)updateEndDate:(id)sender {
    NSDate *select = [self.datePickerOfEnd date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.lblEndDate.text = dateAndTime;
}
@end
