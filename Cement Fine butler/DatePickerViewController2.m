//
//  DatePickerViewController2.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "DatePickerViewController2.h"

@interface DatePickerViewController2 ()
@end

@implementation DatePickerViewController2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    self.navigationItem.title = @"选择起止日期";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithText:@"确定" target:self action:@selector(sureDate:)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *startDate = [defaults valueForKey:@"startDate"];
    NSDictionary *endDate = [defaults valueForKey:@"endDate"];
    self.lblStartDate.text = [NSString stringWithFormat:@"%d-%d-%d",[[startDate objectForKey:@"year"] intValue],[[startDate objectForKey:@"month"] intValue],[[startDate objectForKey:@"day"] intValue]];
    self.lblEndDate.text = [NSString stringWithFormat:@"%d-%d-%d",[[endDate objectForKey:@"year"] intValue],[[endDate objectForKey:@"month"] intValue],[[endDate objectForKey:@"day"] intValue]];
    self.datePicker.hidden = YES;
    self.tableView.bounces = NO;
    if (IS_IPHONE_5) {
        self.tableView.sectionFooterHeight+=88;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.datePicker.hidden = NO;
    self.datePicker.maximumDate = nil;
    self.datePicker.minimumDate = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = nil;
    if (indexPath.row==0) {
        date = [dateFormat dateFromString:self.lblStartDate.text];
        self.datePicker.maximumDate = [dateFormat dateFromString:self.lblEndDate.text];
    }else{
        date = [dateFormat dateFromString:self.lblEndDate.text];
        self.datePicker.minimumDate = [dateFormat dateFromString:self.lblStartDate.text];
        self.datePicker.maximumDate = [NSDate date];
    }
    self.datePicker.date = date;
}

- (void)viewDidUnload {
    [self setLblStartDate:nil];
    [self setLblEndDate:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (IBAction)dateChanged:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *select = [self.datePicker date];
    NSString *dateString =  [dateFormatter stringFromDate:select];
    if (indexPath.row==0) {
        self.lblStartDate.text = dateString;
    }else{
        self.lblEndDate.text = dateString;
    }

}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sureDate:(id)sender {
    self.datePicker.hidden = YES;
    
    NSArray *startDate = [self.lblStartDate.text componentsSeparatedByString:@"-"];
    int beginYear = [[startDate objectAtIndex:0] intValue];
    int beginMonth = [[startDate objectAtIndex:1] intValue];
    int beginDay = [[startDate objectAtIndex:2] intValue];
    
    NSArray *endDate = [self.lblEndDate.text componentsSeparatedByString:@"-"];
    int endYear = [[endDate objectAtIndex:0] intValue];
    int endMonth = [[endDate objectAtIndex:1] intValue];
    int endDay = [[endDate objectAtIndex:2] intValue];
    
    NSDictionary *beginDateDict = @{@"year":[NSNumber numberWithInt:beginYear],@"month":[NSNumber numberWithInt:beginMonth],@"day":[NSNumber numberWithInt:beginDay]};
    NSDictionary *endDateDict = @{@"year":[NSNumber numberWithInt:endYear],@"month":[NSNumber numberWithInt:endMonth],@"day":[NSNumber numberWithInt:endDay]};
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:beginDateDict forKey:@"startDate"];
    [userDefault setObject:endDateDict forKey:@"endDate"];
    [self dismissModalViewControllerAnimated:YES];
}
@end
