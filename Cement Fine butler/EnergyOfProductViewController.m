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
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    
    if (self.type==0) {
        double coalLoss = [Tool doubleValue:[self.product objectForKey:@"totalCoalLoss"]];
        double coalFee = [Tool doubleValue:[self.product objectForKey:@"totalCoalCost"]];
        double coalUnitFee = [Tool doubleValue:[self.product objectForKey:@"coalUnitFee"]];
        double industryCoalUnitAmount = [Tool doubleValue:[self.product objectForKey:@"industryCoalUnitFee"]];
        NSString *textFee = @"";
        NSString *lossType;
        if (coalLoss>=0) {
            lossType = @"损失";
            self.lblValueFee.textColor = [UIColor redColor];
        }else{
            lossType = @"节约";
            coalLoss=-coalLoss;
            self.lblValueFee.textColor = [Tool hexStringToColor:@"#52d596"];
        }
        if (coalLoss/100000>1) {
            coalLoss/=10000;
            textFee = [NSString stringWithFormat:@"已%@(万元)",lossType];
        }else{
            textFee = [NSString stringWithFormat:@"已%@(元)",lossType];
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalLoss]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (coalFee/100000>1) {
            coalFee/=10000;
            textAmount = @"煤耗(万元)";
        }else{
            textAmount = @"煤耗(元)";
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueAmount.text = amountString;
        
        self.lblTextAverage.text = @"吨煤耗(元/吨)";
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalUnitFee]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryCoalUnitAmount]];
        self.lblValueIndustry.text = industryString;
        
    }else if(self.type==1){
        double electricityLoss = [Tool doubleValue:[self.product objectForKey:@"totalElecLoss"]];
        double electricityFee = [Tool doubleValue:[self.product objectForKey:@"totalElecCost"]];
        double electricityUnitFee = [Tool doubleValue:[self.product objectForKey:@"electricityUnitFee"]];
        double industryElectricityUnitAmount = [Tool doubleValue:[self.product objectForKey:@"industryElectricityUnitFee"]];
        
        NSString *textFee = @"";
        NSString *lossType;
        if (electricityLoss>=0) {
            lossType = @"损失";
            self.lblValueFee.textColor = [UIColor redColor];
        }else{
            lossType = @"节约";
            electricityLoss = -electricityLoss;
            self.lblValueFee.textColor = [Tool hexStringToColor:@"#52d596"];
        }
        if (electricityLoss/100000>1) {
            electricityLoss/=10000;
//            textFee = @"电费(万元)";
            textFee = [NSString stringWithFormat:@"已%@(万元)",lossType];
        }else{
            textFee = [NSString stringWithFormat:@"已%@(元)",lossType];
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityLoss]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (electricityFee/100000>1) {
            electricityFee/=10000;
            textAmount = @"电耗(万元)";
        }else{
            textAmount = @"电耗(元)";
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
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
