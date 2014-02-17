//
//  EnergyView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyView : UIView
@property (nonatomic,strong) IBOutlet UIView *leftTopView;
@property (nonatomic,strong) IBOutlet UILabel *lblRealValue;
@property (nonatomic,strong) IBOutlet UILabel *lblRealText;


@property (nonatomic,strong) IBOutlet UIView *leftBottomView;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingValue;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingText;

@property (nonatomic,strong) IBOutlet UIView *rightView;

@property (nonatomic,strong) IBOutlet UILabel *lblStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblValue;
@property (nonatomic,strong) IBOutlet UILabel *lblSuggestion;
@end
