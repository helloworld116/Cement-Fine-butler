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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnStartDate:nil];
    [self setBtnEndDate:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (IBAction)back:(id)sender {
}

- (IBAction)sureDate:(id)sender {
}

- (IBAction)choiceStartDate:(id)sender {
}

- (IBAction)choiceEndDate:(id)sender {
}
@end
