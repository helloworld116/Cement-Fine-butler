//
//  ProductDirectMaterialCosts.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-13.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductDirectMaterialCosts.h"
#import "DirectMaterialCostViewController.h"
@interface ProductDirectMaterialCosts()
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingPrice;//对标成本
@property (nonatomic,strong) IBOutlet UILabel *lblQuotationPrice;//行情成本
@property (nonatomic,strong) IBOutlet UILabel *lblRealPrice;//实际成本

@property (nonatomic,strong) IBOutlet UIView *viewStatus;//右边view，根据损失或节约显示不同的背景颜色
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//状态，节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblStatusValue;//节约或损失的数值
@property (nonatomic,strong) IBOutlet UILabel *lblSuggestion;//建议

-(IBAction)showPopupView:(id)sender;
@end
@implementation ProductDirectMaterialCosts

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ProductDirectMaterialCosts" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
    }
    return self;
}


-(IBAction)showPopupView:(id)sender{
    DirectMaterialCostViewController *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[DirectMaterialCostViewController class]]) {
            viewController = (DirectMaterialCostViewController *)nextResponder;
        }
    }
    [viewController showPopupView:sender];
}
    
-(void)setupValue:(NSDictionary *)product{
    double compareCost = [[product objectForKey:@"compareCost"] doubleValue];//对标成本
    double quotesCosts = [[product objectForKey:@"quotesCosts"] doubleValue];//行情成本
    double actualCosts = [[product objectForKey:@"actualCosts"] doubleValue];//实际成本
    double totalActualCost = [[product objectForKey:@"totalActualCost"] doubleValue];//实际总成本（财务总成本）
    double usedQuantity = [[product objectForKey:@"usedQuantity"] doubleValue];//使用量
    NSString *suggestion = [Tool stringToString:[product objectForKey:@"suggestion"]];
    
    
    self.lblBenchmarkingPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:compareCost]];
    self.lblQuotationPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:quotesCosts]];
    self.lblRealPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:actualCosts]];
//    totalActualCost – compareCost * usedQuantity 计算公式
    double value = totalActualCost-compareCost*usedQuantity;
    if (value>=0) {
        //损失
        self.viewStatus.backgroundColor = [Tool hexStringToColor:@"#f58383"];
        self.lblStatus.text = @"损失 (元)";
        self.lblStatusValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:value]];
    }else{
        //节约
        self.viewStatus.backgroundColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblStatus.text = @"节约 (元)";
        self.lblStatusValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:(-value)]];
    }
    self.lblSuggestion.text = suggestion;
}

-(void)updateValue:(NSDictionary *)product{
    double compareCost = [[product objectForKey:@"compareCost"] doubleValue];//对标成本
    double totalActualCost = [[product objectForKey:@"totalActualCost"] doubleValue];//实际总成本（财务总成本）
    double usedQuantity = [[product objectForKey:@"usedQuantity"] doubleValue];//使用量
    double value = totalActualCost-compareCost*usedQuantity;
    self.lblBenchmarkingPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:compareCost]];
    if (value>=0) {
        //损失
        self.viewStatus.backgroundColor = [Tool hexStringToColor:@"#f58383"];
        self.lblStatus.text = @"损失";
        self.lblStatusValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:value]];
    }else{
        //节约
        self.viewStatus.backgroundColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblStatus.text = @"节约";
        
        self.lblStatusValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:(-value)]];
    }
}
@end
