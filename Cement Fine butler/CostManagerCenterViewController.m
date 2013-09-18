//
//  CostManagerCenterViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-18.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostManagerCenterViewController.h"

@interface CostManagerCenterViewController ()

@end

@implementation CostManagerCenterViewController

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
    // Do any additional setup after loading the view.
    //    LeftViewController* leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    //    NSArray *reportType = @[@"产量报表",@"库存报表"];
    //    leftController.conditions = @[@{@"实时报表":reportType}];
    RightViewController* rightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    NSArray *timeArray = @[@"本年",@"本季度",@"本月",@"自定义"];
    NSArray *lineArray = @[@"全部",@"1号线",@"2号线"];
    NSArray *productArray = @[@"全部",@"PC32.5",@"PC42.5"];
    rightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"costManagerNavigationController"];
    self.centerController = nav;
    self.leftSize = 100;
    self.leftController = nil;
    self.rightSize = kOrignX;
    self.rightController = rightController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
