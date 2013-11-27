//
//  EnergyMonitoringListViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMonitoringListViewController.h"

@interface EnergyMonitoringListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblValueFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAmount;

@property (strong, nonatomic) NSMutableArray *products;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation EnergyMonitoringListViewController

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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kNavBarHeight-kTabBarHeight+1);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60.f;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    if (self.type==0) {
        double coalFee = [[overview objectForKey:@"coalFee"] doubleValue];
        double coalAmount = [[overview objectForKey:@"coalAmount"] doubleValue];
        if (coalFee/10000>1) {
            coalFee/=10000;
            self.lblTextFee.text = @"今日煤费(万元)";
        }else{
            self.lblTextFee.text = @"今日煤费(元)";
        }
        NSString *coalFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueFee.text = coalFeeString;
        
        if (coalAmount/10000>1) {
            coalAmount/=10000;
            self.lblTextAmount.text = @"今日煤耗(万吨)";
        }else{
            self.lblTextAmount.text = @"今日煤耗(吨)";
        }
        NSString *coalAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
        self.lblValueAmount.text = coalAmountString;
    }else if(self.type==1){
        double electricityFee = [[overview objectForKey:@"electricityFee"] doubleValue];
        double electricityAmount = [[overview objectForKey:@"electricityAmount"] doubleValue];
        if (electricityFee/10000>1) {
            electricityFee/=10000;
            self.lblTextFee.text = @"今日电费(万元)";
        }else{
            self.lblTextFee.text = @"今日电费(元)";
        }
        NSString *eletricityFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
        self.lblValueFee.text = eletricityFeeString;
        
        if (electricityAmount/10000>1) {
            electricityAmount/=10000;
            self.lblTextAmount.text = @"今日电耗(万度)";
        }else{
            self.lblTextAmount.text = @"今日电耗(度)";
        }
        NSString *eletricityAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
        self.lblValueAmount.text = eletricityAmountString;
    }
    self.products = [self.data objectForKey:@"products"];
    self.selectedIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectedIndex && self.selectedIndex != -1 ) {
        if (self.isOpen == YES) {
            return 150.f;
        }else{
            return 60.f;
        }
    }
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChoiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = [product objectForKey:@"name"];
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
@end
