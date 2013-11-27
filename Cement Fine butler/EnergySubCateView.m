//
//  EnergySubCateView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergySubCateView.h"

@interface EnergySubCateView ()
@property (strong, nonatomic) IBOutlet UILabel *lblTextFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAverage;
@property (strong, nonatomic) IBOutlet UILabel *lblTextIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblValueIndustry;
@end

@implementation EnergySubCateView

-(void)awakeFromNib
{
    [super awakeFromNib];
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
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (coalAmount/10000>1) {
            coalAmount/=10000;
            textAmount = [time stringByAppendingString:@"煤耗(万吨)"];
        }else{
            textAmount = [time stringByAppendingString:@"煤耗(吨)"];
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
        self.lblValueFee.text = amountString;
        
        self.lblTextAverage.text = [time stringByAppendingString:@"吨煤耗"];
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalUnitAmount]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryCoalUnitAmount]];
        self.lblValueIndustry.text = industryString;
        
    }else if(self.type==1){
        double electricityFee = [[self.product objectForKey:@"electricityFee"] doubleValue];
        double electricityAmount = [[self.product objectForKey:@"electricityAmount"] doubleValue];
        double electricityUnitAmount = [[self.product objectForKey:@"electricityUnitAmount"] doubleValue];
        double industryElectricityUnitAmount = [[self.product objectForKey:@"industryElectricityUnitAmount"] doubleValue];
        
        NSString *textFee = @"";
        if (electricityFee/10000>1) {
            electricityFee/=10000;
            textFee = [time stringByAppendingString:@"电费(万元)"];
        }else{
            textFee = [time stringByAppendingString:@"电费(元)"];
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (electricityAmount/10000>1) {
            electricityAmount/=10000;
            textAmount = [time stringByAppendingString:@"电耗(万度)"];
        }else{
            textAmount = [time stringByAppendingString:@"电耗(度)"];
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
        self.lblValueFee.text = amountString;
        
        self.lblTextAverage.text = [time stringByAppendingString:@"吨电耗"];
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityUnitAmount]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryElectricityUnitAmount]];
        self.lblValueIndustry.text = industryString;
    }
    self.lblTextIndustry.text = @"业界均耗";
}


@end
