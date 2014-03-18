//
//  BusinessInfoVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-6.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "BusinessInfoVC.h"

@interface BusinessInfoVC ()
@property (nonatomic,strong) IBOutlet UILabel *lblContractNumber;
@property (nonatomic,strong) IBOutlet UILabel *lblDateOfContract;
@property (nonatomic,strong) IBOutlet UILabel *lblInteractiveDate;
@property (nonatomic,strong) IBOutlet UILabel *lblWarrantyPeriod;
@end

@implementation BusinessInfoVC

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
    self.navigationItem.title = @"商务信息";
    self.lblContractNumber.text = [Tool stringToString:self.equipmentInfo[@"contractNo"]];
    self.lblDateOfContract.text = [Tool stringToString:self.equipmentInfo[@"signedTime"]];
    self.lblInteractiveDate.text = [Tool stringToString:self.equipmentInfo[@"payTime"]];
    self.lblWarrantyPeriod.text = [Tool stringToString:self.equipmentInfo[@"qualityPeroid"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
