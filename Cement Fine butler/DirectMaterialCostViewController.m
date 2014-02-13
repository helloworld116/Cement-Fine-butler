//
//  DirectMaterialCostViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-13.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "DirectMaterialCostViewController.h"

@interface DirectMaterialCostViewController ()
//顶部控件
@property (nonatomic,strong) IBOutlet UIView *topView;//头部容器
@property (nonatomic,strong) IBOutlet UILabel *lblTime;//指示时间
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的箭头
@property (nonatomic,strong) IBOutlet UIImageView *imgViewStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//指示节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//节约或损失的数值
@property (nonatomic,strong) IBOutlet UILabel *lblUnit;//数值单位

@property (nonatomic,strong) IBOutlet UILabel *lblDetail;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewDetail;

//中间部分控件
@property (nonatomic,strong) IBOutlet UISegmentedControl *middleSegment;

//底部控件
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScorllView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
