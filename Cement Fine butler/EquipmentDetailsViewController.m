//
//  EquipmentDetailsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EquipmentDetailsViewController.h"

@interface EquipmentDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgViewOfEquipment;
@property (strong, nonatomic) IBOutlet UILabel *lblBoxSN;
@property (strong, nonatomic) IBOutlet UILabel *lblSN;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblEquipmentType;
@property (strong, nonatomic) IBOutlet UILabel *lblLineName;
@property (strong, nonatomic) IBOutlet UILabel *lblMaterialName;

@property (strong, nonatomic) IBOutlet UILabel *lblSettingFlowRate;
@property (strong, nonatomic) IBOutlet UILabel *lblInstantFlowRate;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOutput;
@property (strong, nonatomic) IBOutlet UILabel *lblPartialOutput;

@property (strong, nonatomic) IBOutlet UILabel *lblCreatedTime;
@property (strong, nonatomic) IBOutlet UILabel *lblUploadTime;

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

    UIView *bview = [[UIView alloc] init];
    bview.backgroundColor = [Tool hexStringToColor:@"#f3f3f3"];
    self.tableView.backgroundView = bview;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.title = @"设备详情";
    
    NSString *imgName = [NSString stringWithFormat:@"%@%@",@"equipment_",[Tool stringToString:[self.data objectForKey:@"code"]]];
    self.imgViewOfEquipment.image = [UIImage imageNamed:imgName];
    self.lblSN.text = [Tool stringToString:[self.data objectForKey:@"sn"]];
    self.lblStatus.text = [Tool stringToString:[self.data objectForKey:@"statusLabel"]];
    self.lblEquipmentType.text = [Tool stringToString:[self.data objectForKey:@"typename"]];
    self.lblLineName.text = [Tool stringToString:[self.data objectForKey:@"linename"]];
    self.lblMaterialName.text = [Tool stringToString:[self.data objectForKey:@"materialName"]];
    self.lblSettingFlowRate.text = [NSString stringWithFormat:@"%.2f",[[self.data objectForKey:@"settingFlowRate"] doubleValue]];
    self.lblInstantFlowRate.text = [NSString stringWithFormat:@"%.2f",[[self.data objectForKey:@"instantFlowRate"] doubleValue]];
    self.lblTotalOutput.text = [NSString stringWithFormat:@"%.2f",[[self.data objectForKey:@"totalOutput"] doubleValue]];
    self.lblPartialOutput.text = [NSString stringWithFormat:@"%.2f",[[self.data objectForKey:@"partOutput"] doubleValue]];
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createdTime = [NSDate dateWithTimeIntervalSince1970:[Tool doubleValue:[self.data objectForKey:@"createdtime"]]/1000];
    NSDate *uploadTime = [NSDate dateWithTimeIntervalSince1970:[Tool doubleValue:[self.data objectForKey:@"uploadTime"]]/1000];
    self.lblCreatedTime.text = [objDateFormatter stringFromDate:createdTime];
    self.lblUploadTime.text = [objDateFormatter stringFromDate:uploadTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblSN:nil];
    [self setLblStatus:nil];
    [self setLblSettingFlowRate:nil];
    [self setLblInstantFlowRate:nil];
    [self setLblTotalOutput:nil];
    [self setLblPartialOutput:nil];
//    [self setLblStopCountMonthly:nil];
//    [self setLblStopDurationMonthly:nil];
//    [self setLblRunDuration:nil];
    [self setBtnStopRecords:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stopRecords:(id)sender {
    
}
@end
