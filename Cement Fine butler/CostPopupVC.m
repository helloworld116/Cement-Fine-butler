//
//  CostPopupVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostPopupVC.h"
#import "CostPopupView.h"

@interface CostPopupVC ()<UITextFieldDelegate>

@end

@implementation CostPopupVC

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
//    CostPopupView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"CostPopupView" owner:self options:nil] objectAtIndex:0];
    CostPopupView *popupView = [[CostPopupView alloc] init];
    self.view.frame = popupView.frame;
    self.view.layer.cornerRadius = 5;
    [self.view addSubview:popupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
