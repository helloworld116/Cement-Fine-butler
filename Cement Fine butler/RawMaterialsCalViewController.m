//
//  RawMaterialsCalViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-14.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCalViewController.h"
#import "RawMaterialsCalCell.h"
#import "RawMaterialsSettingViewController.h"
#import "RawMaterialsCalculateViewController.h"

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
                  @{@"name":@"熟料",@"rate":@"75",@"financePrice":@"169.79",@"planPrice":@"169",@"locked":[NSNumber numberWithBool:YES]},
                  @{@"name":@"石膏",@"rate":@"5",@"financePrice":@"18.32",@"planPrice":@"18"},
                  @{@"name":@"矿渣",@"rate":@"10",@"financePrice":@"56.66",@"planPrice":@"56"},
                  @{@"name":@"煤煤灰",@"rate":@"5",@"financePrice":@"60.45",@"planPrice":@"70"},
                  @{@"name":@"炉渣",@"rate":@"5",@"financePrice":@"20.67",@"planPrice":@"18"}
                ];
	// Do any additional setup after loading the view.
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    UIBarButtonItem *calBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calculate"] style:UIBarButtonItemStyleBordered target:self action:@selector(calculate:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = calBarButtonItem;
    self.title = @"原材料成本计算器";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //设置uitableviewcell长按事件
//    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    longPressReger.minimumPressDuration = 1.0;
//    [self.tableView addGestureRecognizer:longPressReger];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)calculate:(id)sender{
    RawMaterialsCalculateViewController *calculteResutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalculateViewController"];
    calculteResutViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:calculteResutViewController animated:YES];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"begin");
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"end");
    }else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"change");
    }
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath == nil){
        [self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"long press on table view but not on a row"); 
    }else{
        NSLog(@"long press on table view at row %d", indexPath.row); 
    }
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"RawMaterialsCalCell" owner:self options:nil] objectAtIndex:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
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
    NSDictionary *materialsInfo = [self.data objectAtIndex:indexPath.row];
    cell.lblName.text = [materialsInfo objectForKey:@"name"];
    cell.lblRate.text = [[materialsInfo objectForKey:@"rate"] stringByAppendingString:@"%"];
    cell.lblFinancePrice.text = [[materialsInfo objectForKey:@"financePrice"] stringByAppendingString:@"元/吨"];
    cell.lblPlanPrice.text = [[materialsInfo objectForKey:@"planPrice"] stringByAppendingString:@"元/吨"];
    BOOL isLocked = [[materialsInfo objectForKey:@"locked"] boolValue];
    if (isLocked) {
        cell.imgLockState.image = [UIImage imageNamed:@"lock-small"];
    }else{
        cell.imgLockState.image = [UIImage imageNamed:@"unlock-small"];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rawMaterials = [self.data objectAtIndex:indexPath.row];
    RawMaterialsSettingViewController *rawMaterialsSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsSettingViewController"];
    rawMaterialsSettingViewController.data = rawMaterials;
    rawMaterialsSettingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rawMaterialsSettingViewController animated:YES];
}
@end
