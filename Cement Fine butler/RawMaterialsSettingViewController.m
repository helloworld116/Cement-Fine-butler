//
//  RawMaterialsSettingViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsSettingViewController.h"
#import "RawMaterialsCalViewController.h"

@interface RawMaterialsSettingViewController ()<UITextFieldDelegate>
@property BOOL isKeyboardShow;
@property (nonatomic,retain) NSString *tempApportionRate;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithText:@"保存" target:self action:@selector(save:)];
    self.title = @"原材料成本项设置";
    
    NSDictionary *rawMaterialsInfo = [self.data objectAtIndex:self.index];
    self.lblName.text = [rawMaterialsInfo objectForKey:@"name"];
    self.textRate.text = [NSString stringWithFormat:@"%.2f",[[rawMaterialsInfo objectForKey:@"rate"] doubleValue]];
//    self.textRate.clearsOnInsertion = YES;
    self.textFinancePrice.text = [NSString stringWithFormat:@"%.2f",[[rawMaterialsInfo objectForKey:@"financePrice"] doubleValue]];
//    self.textFinancePrice.clearsOnInsertion = YES;
    self.textPlanPrice.text = [NSString stringWithFormat:@"%.2f",[[rawMaterialsInfo objectForKey:@"planPrice"] doubleValue]];
//    self.textPlanPrice.clearsOnInsertion = YES;
    double apporitionRate = [[rawMaterialsInfo objectForKey:@"apportionRate"] doubleValue];
    if (apporitionRate!=0) {
        self.textApportionRate.text = [NSString stringWithFormat:@"%.2f",apporitionRate];
    }
//    self.textApportionRate.clearsOnInsertion = YES;
    self.switchLocked.on = [[rawMaterialsInfo objectForKey:@"locked"] boolValue];
    if (self.switchLocked.on) {
        self.textApportionRate.enabled = NO;
    }
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    self.textApportionRate.delegate = self;
    self.textFinancePrice.delegate = self;
    self.textPlanPrice.delegate = self;
    self.textRate.delegate = self;
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

    NSDictionary *updateData = @{@"name":self.lblName.text,@"rate":[NSNumber numberWithDouble:[rate doubleValue]],@"financePrice":[NSNumber numberWithDouble:[financePrice doubleValue]],@"planPrice":[NSNumber numberWithDouble:[planPrice doubleValue]],@"apportionRate":[NSNumber numberWithDouble:[apportionRate doubleValue]],@"locked":[NSNumber numberWithBool:self.switchLocked.on]};
    NSUInteger count = self.navigationController.viewControllers.count;
    RawMaterialsCalViewController *parentController = [self.navigationController.viewControllers objectAtIndex:count-2];
    NSMutableArray *newData = [NSMutableArray array];
    //
    double beginRate = [[[self.data objectAtIndex:self.index] objectForKey:@"rate"] doubleValue];
    double endRate = [rate doubleValue];
    double diff = beginRate-endRate;
    int j=0;//没有锁定并未设置分摊比率的个数
    double sureApporitionRate=0;//已经确定的
    double otherTotalRate = 0;//外部已经占有的比率
    for (int i=0; i<self.data.count; i++) {
        if (i!=self.index) {
            NSDictionary *rawMaterialsInfo = [self.data objectAtIndex:i];
            BOOL locked = [[rawMaterialsInfo objectForKey:@"locked"] boolValue];
            if (!locked) {
                double apportionRate = [[rawMaterialsInfo objectForKey:@"apportionRate"] doubleValue];
                otherTotalRate += [Tool doubleValue:[rawMaterialsInfo objectForKey:@"rate"]];
                if (apportionRate==0) {//分摊比不为0，则按改比率添加
                    j++;
                }else{
                    sureApporitionRate += apportionRate;
                }
            }
        }
    }
    int k=0;
    double otherValues=0;//已经分配了的
    for (int i=0; i<self.data.count; i++) {
        if (i!=self.index) {
            NSDictionary *rawMaterialsInfo = [self.data objectAtIndex:i];
            BOOL locked = [[rawMaterialsInfo objectForKey:@"locked"] boolValue];
            if (locked) {
                //锁定了不修改直接添加
                [newData addObject:rawMaterialsInfo];
            }else{
                NSMutableDictionary *newRawMaterialsInfo = [rawMaterialsInfo mutableCopy];
                double _apportionRate = [[rawMaterialsInfo objectForKey:@"apportionRate"] doubleValue];
                double defaultRate = [[rawMaterialsInfo objectForKey:@"rate"] doubleValue];
                double newRate = 0;
                if (_apportionRate!=0) {//分摊比不为0，则按改比率添加
                    newRate = defaultRate+_apportionRate/100*diff;
//                    otherValues += (_apportionRate/100*diff);
                    newRate = [[NSString stringWithFormat:@"%.2f",newRate] doubleValue];
                    otherValues += newRate;
                }else{
                    //分摊为空则其余的平摊
                    k++;
                    if (j==k) {
                        newRate = 100 - endRate - otherValues;
                    }else{
                        if (otherTotalRate) {
                            newRate = defaultRate+(100-sureApporitionRate)/100*diff/j;
                        }else{
                            newRate = defaultRate+((100-otherTotalRate)+diff)/j;
                        }
                        newRate = [[NSString stringWithFormat:@"%.2f",newRate] doubleValue];
                        otherValues += newRate;
                        
                    }
                }
                [newRawMaterialsInfo setObject:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",newRate] doubleValue]] forKey:@"rate"];
                [newData addObject:newRawMaterialsInfo];
            }
        }else{
            [newData addObject:updateData];
        }
    }
    
    parentController.data = newData;
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)changeLocked:(id)sender {
    if (self.switchLocked.on) {
        self.tempApportionRate = self.textApportionRate.text;
        self.textApportionRate.text=@"";
        self.textApportionRate.enabled = NO;
    }else{
        self.textApportionRate.text = self.tempApportionRate;
        self.textApportionRate.enabled = YES;
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
#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}
@end
