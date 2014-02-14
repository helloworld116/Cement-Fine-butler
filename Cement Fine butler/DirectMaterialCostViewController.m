//
//  DirectMaterialCostViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-13.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "DirectMaterialCostViewController.h"
#import "DropDownView.h"

@interface DirectMaterialCostViewController ()<DropDownViewDeletegate>
//顶部控件
@property (nonatomic,strong) IBOutlet UIView *topView;//头部容器
@property (nonatomic,strong) IBOutlet UILabel *lblTime;//指示时间
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的箭头
@property (nonatomic,strong) IBOutlet UIImageView *imgViewStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//指示节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//节约或损失的数值

@property (nonatomic,strong) IBOutlet UILabel *lblDetail;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewDetail;

//中间部分控件
@property (nonatomic,strong) IBOutlet UIView *middleView;

//底部控件
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScorllView;


-(IBAction)changeDate:(id)sender;
-(IBAction)showDetail:(id)sender;

@property (nonatomic,strong) DropDownView *dropDownView;
@end

@implementation DirectMaterialCostViewController

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
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"直接材料成本";
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 7, kScreenWidth-14, 38) items:@[@{@"text":@"Face"},                                                                          @{@"text":@"Linkedin"},
        @{@"text":@"Twitter"}] iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
    segmented.color=[UIColor whiteColor];
    segmented.borderWidth=1;
    segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                               NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                       NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.middleView addSubview:segmented];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeDate:(id)sender {
    if (self.dropDownView) {
        [self.dropDownView hideDropDown:sender];
        self.dropDownView = nil;
    }else{
        self.dropDownView = [[DropDownView alloc] initWithDropDown:sender height:120.f list:@[@"今天",@"昨天",@"本月",@"本年"]];
        self.dropDownView.delegate = self;
    }
}


-(IBAction)showDetail:(id)sender {

}

-(void)dropDownDelegateMethod:(DropDownView *)sender{
    self.dropDownView = nil;
}
@end
