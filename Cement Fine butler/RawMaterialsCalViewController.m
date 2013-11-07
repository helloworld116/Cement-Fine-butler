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

@interface RawMaterialsCalViewController ()<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPlanUnitPrice;
@property (nonatomic,retain) NSArray *defaultData;//用于保存原始数据，用于进行还原操作
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) NODataView *noDataView;
- (IBAction)calculate:(id)sender;
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
//    self.data = @[
//                  @{@"name":@"熟料",@"rate":[NSNumber numberWithDouble:75],@"financePrice":[NSNumber numberWithDouble:169.79],@"planPrice":[NSNumber numberWithDouble:169],@"locked":[NSNumber numberWithBool:YES]},
//                  @{@"name":@"石膏",@"rate":[NSNumber numberWithDouble:5],@"financePrice":[NSNumber numberWithDouble:18.32],@"planPrice":[NSNumber numberWithDouble:18],@"locked":[NSNumber numberWithBool:NO]},
//                  @{@"name":@"矿渣",@"rate":[NSNumber numberWithDouble:10],@"financePrice":[NSNumber numberWithDouble:23.56],@"planPrice":[NSNumber numberWithDouble:24],@"locked":[NSNumber numberWithBool:NO]},
//                  @{@"name":@"煤炭灰",@"rate":[NSNumber numberWithDouble:5],@"financePrice":[NSNumber numberWithDouble:67.90],@"planPrice":[NSNumber numberWithDouble:70],@"locked":[NSNumber numberWithBool:NO]},
//                  @{@"name":@"炉渣",@"rate":[NSNumber numberWithDouble:5],@"financePrice":[NSNumber numberWithDouble:89.55],@"planPrice":[NSNumber numberWithDouble:89],@"locked":[NSNumber numberWithBool:NO]}
//                ];
//    
//    self.defaultData = self.data;
    
	// Do any additional setup after loading the view.
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
//    UIBarButtonItem *calBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calculate"] style:UIBarButtonItemStyleBordered target:self action:@selector(calculate:)];
    UIBarButtonItem *calBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"还原" style:UIBarButtonItemStylePlain target:self action:@selector(revert:)];
//    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = calBarButtonItem;
//    self.navigationItem.rightBarButtonItem.
    self.navigationItem.title = @"原材料成本计算器";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //设置uitableviewcell长按事件
//    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    longPressReger.minimumPressDuration = 1.0;
//    [self.tableView addGestureRecognizer:longPressReger];
    
    [self sendRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
    [self setLblValue];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setLblUnitPrice:nil];
    [self setLblPlanUnitPrice:nil];
    [self setViewOfResult:nil];
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)revert:(id)sender{
    self.data = self.defaultData;
    [self setLblValue];
    [self.tableView reloadData];
}

-(void)setLblValue{
    double unitPrice=0,unitPlanPrice=0;
    for (int i=0; i<self.data.count; i++) {
        NSDictionary *dict = [self.data objectAtIndex:i];
        double rate = [[dict objectForKey:@"rate"] doubleValue];
        double financePrice = [[dict objectForKey:@"financePrice"] doubleValue];
        double planPrice = [[dict objectForKey:@"planPrice"] doubleValue];
        unitPrice+=(financePrice*rate)/100;
        unitPlanPrice+=(planPrice*rate)/100;
    }
    NSString *unitPriceString = [NSString stringWithFormat:@"%.2f",round(unitPrice*100)/100];
    NSString *unitPlanPriceString = [NSString stringWithFormat:@"%.2f",round(unitPlanPrice*100)/100];
    self.lblUnitPrice.text = unitPriceString;
    self.lblPlanUnitPrice.text = unitPlanPriceString;
}

-(IBAction)calculate:(id)sender{
    RawMaterialsCalculateViewController *calculteResutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalculateViewController"];
    calculteResutViewController.hidesBottomBarWhenPushed = YES;
    calculteResutViewController.data = self.data;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}

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
    cell.lblRate.text = [NSString stringWithFormat:@"%.2f",[[materialsInfo objectForKey:@"rate"] doubleValue]];
    cell.lblFinancePrice.text = [NSString stringWithFormat:@"%.2f",[[materialsInfo objectForKey:@"financePrice"] doubleValue]];
    cell.lblPlanPrice.text = [NSString stringWithFormat:@"%.2f",[[materialsInfo objectForKey:@"planPrice"] doubleValue]];
    BOOL isLocked = [[materialsInfo objectForKey:@"locked"] boolValue];
    if (isLocked) {
        cell.imgLockState.image = [UIImage imageNamed:@"lock-small"];
    }else{
        cell.imgLockState.image = [UIImage imageNamed:@"unlock-small"];
    }
    if ([[materialsInfo objectForKey:@"apportionRate"] doubleValue]!=0) {
        cell.lblApportionRate.text = [NSString stringWithFormat:@"%.2f",[[materialsInfo objectForKey:@"apportionRate"] doubleValue]];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *rawMaterials = [self.data objectAtIndex:indexPath.row];
    RawMaterialsSettingViewController *rawMaterialsSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsSettingViewController"];
//    rawMaterialsSettingViewController.data = rawMaterials;
    rawMaterialsSettingViewController.data = self.data;
    rawMaterialsSettingViewController.index = indexPath.row;
    rawMaterialsSettingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rawMaterialsSettingViewController animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest{
    //清除原数据
    self.data = nil;
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    self.tableView.hidden=YES;
    self.viewOfResult.hidden=YES;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kCalculator);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCalculator]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==0) {
        self.data = [dict objectForKey:@"data"];
        self.defaultData = self.data;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.viewOfResult.hidden = NO;
        [self setLblValue];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.data = nil;
        self.noDataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
        [self.view performSelector:@selector(addSubview:) withObject:self.noDataView afterDelay:0.5];
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}
@end
