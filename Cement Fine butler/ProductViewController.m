//
//  ProductViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblTextQuotesCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblValueQuotesCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblTextTotalLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblValueTotalLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblTextActualCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblValueActualCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblTextStandardCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblValueStandardCosts;
@property (strong, nonatomic) IBOutlet UILabel *lblSuggestion;
@property (strong, nonatomic) IBOutlet UILabel *lblSuggestionTip;
@end

@implementation ProductViewController

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
//    [UIColor colorWithRed:31/255.0 green:32/255.0 blue:38/255.0 alpha:1]
    self.view.backgroundColor = kRelativelyColor;
    UIColor *textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    self.lblTextActualCosts.backgroundColor = [UIColor clearColor];
    self.lblTextQuotesCosts.backgroundColor = [UIColor clearColor];
    self.lblTextStandardCosts.backgroundColor = [UIColor clearColor];
    self.lblTextTotalLoss.backgroundColor = [UIColor clearColor];
    self.lblTextActualCosts.textColor = textColor;
    self.lblTextQuotesCosts.textColor = textColor;
    self.lblTextStandardCosts.textColor = textColor;
    self.lblTextTotalLoss.textColor = textColor;
    UIColor *valueColor = kGeneralColor;
    self.lblValueActualCosts.backgroundColor = [UIColor clearColor];
    self.lblValueQuotesCosts.backgroundColor = [UIColor clearColor];
    self.lblValueStandardCosts.backgroundColor = [UIColor clearColor];
    self.lblValueTotalLoss.backgroundColor = [UIColor clearColor];
    self.lblValueActualCosts.textColor = valueColor;
    self.lblValueQuotesCosts.textColor = valueColor;
    self.lblValueStandardCosts.textColor = valueColor;
    
    NSString *lblStr = @"";
    self.lblTextQuotesCosts.text = @"行情成本(元/吨)";
    self.lblTextActualCosts.text = @"实际成本(元/吨)";
    self.lblTextStandardCosts.text = @"标准成本(元/吨)";
    self.lblSuggestionTip.text = @"建议：";
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    double quotesCosts = [Tool doubleValue:[self.product objectForKey:@"quotesCosts"]];
    double totalLoss = [Tool doubleValue:[self.product objectForKey:@"totalLoss"]];
    double actualCosts = [Tool doubleValue:[self.product objectForKey:@"actualCosts"]];
    double standardCosts = [Tool doubleValue:[self.product objectForKey:@"standardCosts"]];
    NSString *suggestion = [Tool stringToString:[self.product objectForKey:@"suggestion"]];
    if(totalLoss>=0){
        lblStr = [lblStr stringByAppendingString:@"已节约"];
        self.lblValueTotalLoss.textColor = [Tool hexStringToColor:@"#52d596"];
    }else{
        lblStr = [lblStr stringByAppendingString:@"已损失"];
        totalLoss = -totalLoss;
        self.lblValueTotalLoss.textColor = [UIColor redColor];
    }
    if (totalLoss/100000>1) {
        totalLoss/=10000;
        lblStr = [lblStr stringByAppendingString:@"(万元)"];
    }else{
        lblStr = [lblStr stringByAppendingString:@"(元)"];
    }
    self.lblTextTotalLoss.text = lblStr;
    
    NSString *quotesCostsStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:quotesCosts]];
    NSString *totalLossStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalLoss]];
    NSString *actualCostsStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:actualCosts]];
    NSString *standardCostsStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:standardCosts]];
    
    self.lblValueQuotesCosts.text = quotesCostsStr;
    self.lblValueTotalLoss.text = totalLossStr;
    self.lblValueActualCosts.text = actualCostsStr;
    self.lblValueStandardCosts.text = standardCostsStr;
    self.lblSuggestion.text = suggestion;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
