//
//  RawMaterialsCalViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-14.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCalViewController.h"
#import "RawMaterialsCalCell.h"

@interface RawMaterialsCalViewController ()
@property (retain,nonatomic) NSArray *data;
@end

@implementation RawMaterialsCalViewController

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
    self.data = @[
                  @{@"name":@"熟料",@"rate":@"75",@"financePrice":@"169",@"planPrice":@"169"},
                  @{@"name":@"石膏",@"rate":@"5",@"financePrice":@"18",@"planPrice":@"18"},
                  @{@"name":@"矿渣",@"rate":@"10",@"financePrice":@"56",@"planPrice":@"56"},
                  @{@"name":@"煤煤灰",@"rate":@"5",@"financePrice":@"60",@"planPrice":@"70"},
                  @{@"name":@"炉渣",@"rate":@"5",@"financePrice":@"20",@"planPrice":@"18"}
                ];
    
	// Do any additional setup after loading the view.
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    UIBarButtonItem *calBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calculate"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = calBarButtonItem;
    self.title = @"原材料成本计算器";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDirectUnitCost:nil];
    [self setPlanUnitCost:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"RawMaterialsCalCell";
    RawMaterialsCalCell *cell = (RawMaterialsCalCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
@end
