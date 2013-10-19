//
//  EquipmentListViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EquipmentListViewController.h"
#import "EquipmentListCell.h"
#import "EquipmentMapViewController.h"
#import "EquipmentDetailsViewController.h"

@interface EquipmentListViewController ()
@property (nonatomic,retain) NSMutableArray *data;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) LoadingView *loadingView;
@property (nonatomic,assign) int totalCount;
@end

@implementation EquipmentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设备列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapViewController:)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self sendRequest:0];
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

-(void)showMapViewController:(id)sender{
    EquipmentMapViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentMapViewController"];
    mapController.equipmentList = self.data;
    mapController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapController animated:YES];
}


#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EquipmentListCell class]) owner:self options:nil] objectAtIndex:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EquipmentListCell class]) owner:self options:nil] objectAtIndex:1];
    return view.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EquipmentListCell class]) owner:self options:nil] objectAtIndex:0];
    return view.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EquipmentListCell";
    EquipmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    cell.lblSeq.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    NSDictionary *equipmentInfo = [self.data objectAtIndex:indexPath.row];
    cell.lblStatus.text = [Tool stringToString:[equipmentInfo objectForKey:@"status"]];
    cell.lblSN.text = [Tool stringToString:[equipmentInfo objectForKey:@"sn"]];

    cell.lblName.text= [Tool stringToString:[equipmentInfo objectForKey:@"name"]];
    cell.lblSettingFlowRate.text = [NSString stringWithFormat:@"%.2f",[[equipmentInfo objectForKey:@"settingFlowRate"] doubleValue]];
    cell.lblInstantFlowRate.text = [NSString stringWithFormat:@"%.2f",[[equipmentInfo objectForKey:@"instantFlowRate"] doubleValue]];
    cell.lblStopCount.text = [NSString stringWithFormat:@"%d",[[equipmentInfo objectForKey:@"stopCountMonthly"] intValue]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *equipmentDetails = [self.data objectAtIndex:indexPath.row];
    EquipmentDetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentDetailsViewController"];
    detailsViewController.data = equipmentDetails;
    detailsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}


#pragma mark 发送网络请求
-(void) sendRequest:(int)offset{
//    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startLoading];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    DDLogCInfo(@"******  Request URL is:%@  ******",kEquipmentList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kEquipmentList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:[[kSharedApp.factory objectForKey:@"id"] intValue]] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLong:kPageSize] forKey:@"count"];
    [self.request setPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
//    [self.loadingView successEndLoading];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==0) {
        self.data = [[dict objectForKey:@"data"] objectForKey:@"equipments"];
        self.totalCount = [[[dict objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
        [self.tableView reloadData];
    }else if(responseCode==-1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
