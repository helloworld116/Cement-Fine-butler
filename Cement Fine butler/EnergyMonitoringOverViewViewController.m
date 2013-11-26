//
//  EnergyMonitoringOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMonitoringOverViewViewController.h"
#import "EnergyMonitoringListViewController.h"

@interface EnergyMonitoringOverViewViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *lblTextCoalFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueCoalFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextCoalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueCoalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTextElectricityFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueElectricityFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextElectricityAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueElectricityAmount;
@end

@implementation EnergyMonitoringOverViewViewController

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
    self.topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *topTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoalInfo:)];
    [self.topView addGestureRecognizer:topTabGesture];
    self.bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bottomTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showElectricityInfo:)];
    [self.bottomView addGestureRecognizer:bottomTabGesture];
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height+1);
//    NSLog(@"%f",self.scrollView.bounds.size.height);
//    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCoalInfo:(id)sender{
    EnergyMonitoringListViewController *nextViewController = [[EnergyMonitoringListViewController alloc] initWithNibName:@"EnergyMonitoringListViewController" bundle:nil];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

-(void)showElectricityInfo:(id)sender{
    
}
@end
