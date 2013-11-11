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

@interface EquipmentListViewController ()<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) LoadingView *loadingView;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,assign) int currentPage;
@end

@implementation EquipmentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设备列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapViewController:)];
    self.currentPage=1;
    self.list = [NSMutableArray array];
    [self sendRequest:self.currentPage withProgress:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMapViewController:(id)sender{
    EquipmentMapViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentMapViewController"];
    mapController.equipmentList = self.list;
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
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EquipmentListCell";
    EquipmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    cell.lblSeq.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    NSDictionary *equipmentInfo = [self.list objectAtIndex:indexPath.row];
    cell.lblStatus.text = [Tool stringToString:[equipmentInfo objectForKey:@"statusLabel"]];
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
    NSDictionary *equipmentDetails = [self.list objectAtIndex:indexPath.row];
    EquipmentDetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentDetailsViewController"];
    detailsViewController.data = equipmentDetails;
    detailsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}


#pragma mark 发送网络请求
-(void) sendRequest:(NSUInteger)currentPage withProgress:(BOOL)isProgress{
    if (isProgress) {
        //加载过程提示
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        self.progressHUD.labelText = @"加载中...";
        self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
        self.progressHUD.dimBackground = YES;
        self.progressHUD.opacity=1.0;
        self.progressHUD.delegate = self;
        [self.tableView addSubview:self.progressHUD];
        [self.progressHUD show:YES];
    }
    DDLogCInfo(@"******  Request URL is:%@  ******",kEquipmentList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kEquipmentList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:[[kSharedApp.factory objectForKey:@"id"] intValue]] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLong:kPageSize] forKey:@"count"];
    //暂时使用offset，后面改成page
    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
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
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==kErrorCode0) {
        if (self.currentPage==1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"equipments"]];
        self.totalCount = [[[dict objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
        [self.tableView reloadData];
    }else if(responseCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
    [self.progressHUD hide:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

#pragma mark - Refresh and load more methods
- (void) refreshTable
{
    //Code to actually refresh goes here.
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    //Code to actually load more data goes here.
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    self.currentPage = 1;
    [self sendRequest:self.currentPage withProgress:NO];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (self.totalCount>self.currentPage*kPageSize) {
        self.currentPage++;
        [self sendRequest:self.currentPage withProgress:NO];
    }
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

@end
