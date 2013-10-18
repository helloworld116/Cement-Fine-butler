//
//  EquipmentDetailsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EquipmentDetailsViewController.h"

@interface EquipmentDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSN;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblSettingFlowRate;
@property (strong, nonatomic) IBOutlet UILabel *lblInstantFlowRate;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOutput;
@property (strong, nonatomic) IBOutlet UILabel *lblPartialOutput;
@property (strong, nonatomic) IBOutlet UILabel *lblStopCountMonthly;
@property (strong, nonatomic) IBOutlet UILabel *lblStopDurationMonthly;
@property (strong, nonatomic) IBOutlet UILabel *lblRunDuration;
@property (strong, nonatomic) IBOutlet UIButton *btnStopRecords;

- (IBAction)stopRecords:(id)sender;

@end

@implementation EquipmentDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.title = @"设备详情";
    
    self.lblName.text = [Tool stringToString:[self.data objectForKey:@"name"]];
    self.lblSN.text = [Tool stringToString:[self.data objectForKey:@"sn"]];
    self.lblStatus.text = [Tool stringToString:[self.data objectForKey:@"status"]];;
    self.lblSettingFlowRate.text = [NSString stringWithFormat:@"%2.f",[[self.data objectForKey:@"settingFlowRate"] doubleValue]];
    self.lblInstantFlowRate.text = [NSString stringWithFormat:@"%2.f",[[self.data objectForKey:@"instantFlowRate"] doubleValue]];
    self.lblTotalOutput.text = [NSString stringWithFormat:@"%2.f",[[self.data objectForKey:@"totalOutput"] doubleValue]];
    self.lblPartialOutput.text = [NSString stringWithFormat:@"%2.f",[[self.data objectForKey:@"partialOutput"] doubleValue]];
    self.lblStopCountMonthly.text = [NSString stringWithFormat:@"%d",[[self.data objectForKey:@"stopCountMonthly"] intValue]];
    self.lblStopDurationMonthly.text = [Tool longTimeToTimeDesc:[[self.data objectForKey:@"stopDurationMonthly"] longValue]];
    self.lblRunDuration.text = [Tool longTimeToTimeDesc:[[self.data objectForKey:@"runDuration"] longValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblName:nil];
    [self setLblSN:nil];
    [self setLblStatus:nil];
    [self setLblSettingFlowRate:nil];
    [self setLblInstantFlowRate:nil];
    [self setLblTotalOutput:nil];
    [self setLblPartialOutput:nil];
    [self setLblStopCountMonthly:nil];
    [self setLblStopDurationMonthly:nil];
    [self setLblRunDuration:nil];
    [self setBtnStopRecords:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stopRecords:(id)sender {
    
}
@end
