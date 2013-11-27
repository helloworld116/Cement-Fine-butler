//
//  SubCateViewController.m
//  ExpansionTableViewByZQ
//
//  Created by 郑 琪 on 13-2-27.
//  Copyright (c) 2013年 郑 琪. All rights reserved.
//

#import "SubCateViewController.h"

@interface SubCateViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblTextFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblTextIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblValueIndustry;

@end

@implementation SubCateViewController


#pragma ViewController
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
    // Do any additional setup after loading the view from its nib.
    NSString *time = @"今日";
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];

    if (self.type==0) {
        double coalFee = [[self.product objectForKey:@"coalFee"] doubleValue];
        double coalAmount = [[self.product objectForKey:@"coalAmount"] doubleValue];
        double coalUnitAmount = [[self.product objectForKey:@"coalUnitAmount"] doubleValue];
        double industryCoalUnitAmount = [[self.product objectForKey:@"industryCoalUnitAmount"] doubleValue];
        NSString *textFee = @"";
        if (coalFee/10000>1) {
            coalFee/=10000;
            textFee = [time stringByAppendingString:@"煤费(万元)"];
        }else{
            textFee = [time stringByAppendingString:@"煤费(元)"];
        }
        self.lblTextFee.text = textFee;
        
        NSString *textAmount = @"";
        if (coalAmount/10000>1) {
            coalAmount/=10000;
            textAmount = [time stringByAppendingString:@"煤耗(万吨)"];
        }else{
            textAmount = [time stringByAppendingString:@"煤耗(吨)"];
        }
        self.lblTextFee.text = textAmount;
        
        self.lblTextAmount.text = [time stringByAppendingString:@"煤耗"];
        self.lblTextAverage.text = [time stringByAppendingString:@"吨煤耗"];
        
    }else if(self.type==1){
        double electricityFee = [[self.product objectForKey:@"electricityFee"] doubleValue];
        double electricityAmount = [[self.product objectForKey:@"electricityAmount"] doubleValue];
        double electricityUnitAmount = [[self.product objectForKey:@"electricityUnitAmount"] doubleValue];
        double industryElectricityUnitAmount = [[self.product objectForKey:@"industryElectricityUnitAmount"] doubleValue];
        
        self.lblTextFee.text = [time stringByAppendingString:@"电费"];
        self.lblTextAmount.text = [time stringByAppendingString:@"电耗"];
        self.lblTextAverage.text = [time stringByAppendingString:@"吨电耗"];
    }
    self.lblTextIndustry.text = @"业界均耗";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
