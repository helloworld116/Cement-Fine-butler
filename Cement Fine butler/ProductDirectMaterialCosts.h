//
//  ProductDirectMaterialCosts.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-13.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDirectMaterialCosts : UIView
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingPrice;//对标成本
@property (nonatomic,strong) IBOutlet UILabel *lblQuotationPrice;//行情成本
@property (nonatomic,strong) IBOutlet UILabel *lblRealPrice;//实际成本

@property (nonatomic,strong) IBOutlet UIView *viewStatus;//右边view，根据损失或节约显示不同的背景颜色
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//状态，节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblStatusValue;//节约或损失的数值
@property (nonatomic,strong) IBOutlet UILabel *lblSuggestion;//建议
@end
