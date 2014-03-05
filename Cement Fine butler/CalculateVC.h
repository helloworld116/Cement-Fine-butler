//
//  CalculateVC.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-27.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculateCell: UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblMaterialName;//原材料名称
@property (nonatomic,strong) IBOutlet UISlider *slider;//滑竿
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//滑竿下面的文字
@property (nonatomic,strong) IBOutlet UIButton *btnLock;//锁定按钮

@property (nonatomic,strong) IBOutlet UILabel *lblRatio;//比率
@property (nonatomic,strong) IBOutlet UILabel *lblAssessmentRate;//分摊比率
@property (nonatomic,strong) IBOutlet UILabel *lblFinancePrice;//财务价格
@property (nonatomic,strong) IBOutlet UILabel *lblPlanPrice;//计划价格

@property (nonatomic) BOOL isLocked;
@property (nonatomic,strong) NSDictionary *data;

-(IBAction)lockStateChange:(id)sender;
-(IBAction)showUpdateView:(id)sender;

-(void)setDefaultStyle;
-(void)setValueWithData:(NSDictionary *)data withSliderMaxValue:(double)maxValue;
@end

@interface CalculateHeaderView : UIView
@property (nonatomic,strong) IBOutlet UILabel *lblUnitPrice;
@property (nonatomic,strong) IBOutlet UILabel *lblPlanUnitPrice;
@end

@interface CalculateVC : UIViewController
-(void)setHeaderViewValue;
-(NSArray *)updateData:(NSDictionary *)data atIndex:(NSInteger)index withArrary:(NSArray *)array;
@end
