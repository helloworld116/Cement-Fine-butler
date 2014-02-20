//
//  EnergyView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyView.h"
@interface EnergyView()
@property (nonatomic,retain) NSDictionary *data;

@property (nonatomic,strong) IBOutlet UIView *leftTopView;
@property (nonatomic,strong) IBOutlet UILabel *lblRealValue;
@property (nonatomic,strong) IBOutlet UILabel *lblRealText;


@property (nonatomic,strong) IBOutlet UIView *leftBottomView;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingValue;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingText;

@property (nonatomic,strong) IBOutlet UIView *rightView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewType;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblValue;
@property (nonatomic,strong) IBOutlet UILabel *lblSuggestion;
@end

@implementation EnergyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setupValue:(NSDictionary *)data withType:(int)type{
    self.data = data;
    if (type==0) {
        //煤耗
        double coalUnitAmount = [Tool doubleValue:[data objectForKey:@"coalUnitAmount"]];
        double compareUnitAmount = [Tool doubleValue:[data objectForKey:@"compareUnitAmount"]];
        double lossCost = [Tool doubleValue:[data objectForKey:@"lossCost"]];
        self.lblRealText.text=@"煤耗（公斤/吨）";
        self.lblRealValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalUnitAmount]];
        self.lblBenchmarkingText.text=@"对标煤耗（公斤/吨）";
        self.lblBenchmarkingValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:compareUnitAmount]];
        if (lossCost>=0) {
            self.lblStatus.text =@"损失";
            self.rightView.backgroundColor = [Tool hexStringToColor:@"#f58383"];
            self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:lossCost]];
        }else{
            self.lblStatus.text =@"节约";
            self.rightView.backgroundColor = [Tool hexStringToColor:@"#70dea9"];
            self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:-lossCost]];
        }
        self.imgViewType.image = [UIImage imageNamed:@"coal_consumption_icon_new"];
        self.lblSuggestion.text = @"";
    }else if (type==1){
        //电耗
        double elecUnitAmount = [Tool doubleValue:[data objectForKey:@"elecUnitAmount"]];
        double compareUnitAmount = [Tool doubleValue:[data objectForKey:@"compareUnitAmount"]];
        double lossCost = [Tool doubleValue:[data objectForKey:@"lossCost"]];
        self.lblRealText.text=@"电耗（度/吨）";
        self.lblRealValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecUnitAmount]];
        self.lblBenchmarkingText.text=@"对标电耗（度/吨）";
        self.lblBenchmarkingValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:compareUnitAmount]];
        if (lossCost>=0) {
            self.lblStatus.text =@"损失";
            self.rightView.backgroundColor = [Tool hexStringToColor:@"#f58383"];
            self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:lossCost]];
        }else{
            self.lblStatus.text =@"节约";
            self.rightView.backgroundColor = [Tool hexStringToColor:@"#70dea9"];
            self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:-lossCost]];
        }
        self.imgViewType.image = [UIImage imageNamed:@"power_consumption_icon_new"];
        self.lblSuggestion.text = @"";
    }
}

@end
