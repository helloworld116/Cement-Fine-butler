//
//  RawMaterialsSettingViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsSettingViewController.h"

@interface RawMaterialsSettingViewController ()
@property BOOL isKeyboardShow;
@end

@implementation RawMaterialsSettingViewController

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
    //设置navagtionbar
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    UIBarButtonItem *calBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = calBarButtonItem;
    self.title = @"原材料成本项设置";
    
    self.lblName.text = [self.data objectForKey:@"name"];
    self.textRate.text = [self.data objectForKey:@"rate"];
    self.textRate.clearsOnInsertion = YES;
    self.textFinancePrice.text = [self.data objectForKey:@"financePrice"];
    self.textFinancePrice.clearsOnInsertion = YES;
    self.textPlanPrice.text = [self.data objectForKey:@"planPrice"];
    self.textPlanPrice.clearsOnInsertion = YES;
    self.textApportionRate.text = [self.data objectForKey:@"apporitionRate"];
    self.textApportionRate.clearsOnInsertion = YES;
    self.switchLocked.on = NO;
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblName:nil];
    [self setTextRate:nil];
    [self setTextFinancePrice:nil];
    [self setTextPlanPrice:nil];
    [self setTextApportionRate:nil];
    [self setSwitchLocked:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(id)sender{
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
    NSDictionary *newValues = @{@"name":self.lblName.text,@"rate":rate,@"financePrice":financePrice,@"planPrice":planPrice,@"apporitionRate":apportionRate,@"isLocked":[NSNumber numberWithBool:self.switchLocked.on]};
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    self.isKeyboardShow = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    self.isKeyboardShow = NO;
}
- (IBAction)textRateTouch:(id)sender {
    if (self.isKeyboardShow) {
        [self.textRate resignFirstResponder];
    }
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor grayColor];
//    if (indexPath.row==1) {
//        [self.textRate becomeFirstResponder];
//    }else if (indexPath.row==2){
//        [self.textFinancePrice becomeFirstResponder];
//    }
//}
@end
