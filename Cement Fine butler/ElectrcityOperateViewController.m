//
//  ElectrcityOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectrcityOperateViewController.h"

@interface ElectrcityOperateViewController ()

@end

@implementation ElectrcityOperateViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    [self.textElectricityPrice becomeFirstResponder];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateValue;
    if (self.electricityInfo) {
        self.title = @"修改电力价格";
        self.textElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[self.electricityInfo objectForKey:@"value"] floatValue]];
         dateValue = [self.electricityInfo objectForKey:@"createTime_str"];
    }else{
        self.title = @"添加电力价格";
        dateValue =  [dateFormatter stringFromDate:[NSDate date]];
    }
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.tableView.bounces = NO;
    self.datePicker.hidden = YES;
    self.lblDate.text = dateValue;
    self.datePicker.date = [dateFormatter dateFromString:dateValue];
//    self.tableView.sectionFooterHeight = 100.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save:(id)sender{
    
}

#pragma mark tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self.textElectricityPrice becomeFirstResponder];
        self.datePicker.hidden = YES;
    }else{
        [self.lblDate becomeFirstResponder];
        self.datePicker.hidden = NO;
        [self.textElectricityPrice resignFirstResponder];
    }
}

- (IBAction)dateChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *select = [self.datePicker date];
    NSString *dateString =  [dateFormatter stringFromDate:select];
    self.lblDate.text = dateString;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
