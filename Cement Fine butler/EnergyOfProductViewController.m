//
//  EnergyOfProductViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-2.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyOfProductViewController.h"

@interface EnergyOfProductViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblTextFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblTextIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblValueIndustry;
@end

@implementation EnergyOfProductViewController

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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    
    if (self.type==0) {
        double coalFee = [Tool doubleValue:[self.product objectForKey:@"totalCoalLoss"]];
        double coalAmount = [Tool doubleValue:[self.product objectForKey:@"coalAmount"]];
        double coalUnitFee = [Tool doubleValue:[self.product objectForKey:@"coalUnitFee"]];
        double industryCoalUnitAmount = [Tool doubleValue:[self.product objectForKey:@"industryCoalUnitFee"]];
        NSString *textFee = @"";
        if (coalFee/100000>1) {
            coalFee/=10000;
//            textFee = @"煤费(万元)";
            textFee = @"已损失(万元)";
        }else{
//            textFee = @"煤费(元)";
            textFee = @"已损失(元)";
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (coalAmount/100000>1) {
            coalAmount/=10000;
            textAmount = @"煤耗(万吨)";
        }else{
            textAmount = @"煤耗(吨)";
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
        self.lblValueAmount.text = amountString;
        
        self.lblTextAverage.text = @"吨煤耗(元/吨)";
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalUnitFee]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryCoalUnitAmount]];
        self.lblValueIndustry.text = industryString;
        
    }else if(self.type==1){
        double electricityFee = [Tool doubleValue:[self.product objectForKey:@"totalElecLoss"]];
        double electricityAmount = [Tool doubleValue:[self.product objectForKey:@"electricityAmount"]];
        double electricityUnitFee = [Tool doubleValue:[self.product objectForKey:@"electricityUnitFee"]];
        double industryElectricityUnitAmount = [Tool doubleValue:[self.product objectForKey:@"industryElectricityUnitFee"]];
        
        NSString *textFee = @"";
        if (electricityFee/100000>1) {
            electricityFee/=10000;
//            textFee = @"电费(万元)";
            textFee = @"已损失(万元)";
        }else{
            textFee = @"已损失(元)";
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (electricityAmount/100000>1) {
            electricityAmount/=10000;
            textAmount = @"电耗(万度)";
        }else{
            textAmount = @"电耗(度)";
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
        self.lblValueAmount.text = amountString;
        
        self.lblTextAverage.text = @"吨电耗(元/吨)";
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityUnitFee]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryElectricityUnitAmount]];
        self.lblValueIndustry.text = industryString;
    }
    self.lblTextIndustry.text = @"业界均耗(元/吨)";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
