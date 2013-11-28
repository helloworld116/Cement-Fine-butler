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
@property (strong, nonatomic) IBOutlet UIImageView *imgLine1;
@property (strong, nonatomic) IBOutlet UIImageView *imgLine2;
@property (strong, nonatomic) IBOutlet UIImageView *imgLine3;

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

-(void)drawLines{
//    UIGraphicsBeginImageContext(self.imgLine1.frame.size);
//    [self.imgLine1.image drawInRect:CGRectMake(0, 0, self.imgLine1.frame.size.width, self.imgLine1.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 15.0);  //线宽
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
//    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 100, 100);  //起点坐标
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 200, 100);   //终点坐标
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    self.imgLine1.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawLines];
    NSString *time = @"今日";
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    
    if (self.type==0) {
        double coalFee = [[self.product objectForKey:@"coalFee"] doubleValue];
        double coalAmount = [[self.product objectForKey:@"coalAmount"] doubleValue];
        double coalUnitAmount = [[self.product objectForKey:@"coalUnitAmount"] doubleValue];
        double industryCoalUnitAmount = [[self.product objectForKey:@"industryCoalUnitAmount"] doubleValue];
        NSString *textFee = @"";
        if (coalFee/100000>1) {
            coalFee/=10000;
            textFee = [time stringByAppendingString:@"煤费(万元)"];
        }else{
            textFee = [time stringByAppendingString:@"煤费(元)"];
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (coalAmount/100000>1) {
            coalAmount/=10000;
            textAmount = [time stringByAppendingString:@"煤耗(万吨)"];
        }else{
            textAmount = [time stringByAppendingString:@"煤耗(吨)"];
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
        self.lblValueAmount.text = amountString;
        
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
        if (electricityFee/100000>1) {
            electricityFee/=10000;
            textFee = [time stringByAppendingString:@"电费(万元)"];
        }else{
            textFee = [time stringByAppendingString:@"电费(元)"];
        }
        self.lblTextFee.text = textFee;
        NSString *feeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
        self.lblValueFee.text = feeString;
        
        NSString *textAmount = @"";
        if (electricityAmount/100000>1) {
            electricityAmount/=10000;
            textAmount = [time stringByAppendingString:@"电耗(万度)"];
        }else{
            textAmount = [time stringByAppendingString:@"电耗(度)"];
        }
        self.lblTextAmount.text = textAmount;
        NSString *amountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
        self.lblValueAmount.text = amountString;
        
        self.lblTextAverage.text = [time stringByAppendingString:@"吨电耗"];
        NSString *averageString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityUnitAmount]];
        self.lblValueAverage.text = averageString;
        
        NSString *industryString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:industryElectricityUnitAmount]];
        self.lblValueIndustry.text = industryString;
    }
    self.lblTextIndustry.text = @"业界均耗";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
