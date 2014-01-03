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
@property (strong, nonatomic) UIBarButtonItem *rightButtonItem;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) PromptMessageView *messageView;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,retain) NSTimer *timer;
@end

@implementation EquipmentListViewController
//- (void)loadView {
//    self.view = [[UIView alloc] initWithFrame:CGRectZero];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    UITableView *tblView = [[UITableView alloc]
//                            initWithFrame:CGRectZero
//                            style:UITableViewStylePlain
//                            ];
//    
//    tblView.autoresizingMask =
//    UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleHeight
//    ;
//    
//    self.tableView = tblView;
//    [self.view addSubview:tblView];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.title = @"设备列表";
//    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapViewController:)];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.currentPage=1;
//    self.list = [NSMutableArray array];
//    [self sendRequest:self.currentPage withProgress:YES];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.separatorColor = [UIColor colorWithRed:132.0f/255.0f green:132.0f/255.0f blue:131.0f/255.0f alpha:1.0f];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if ((kSharedApp.startFactoryId!=kSharedApp.finalFactoryId)&&(self.list==nil)) {
        [self.list removeAllObjects];
        //send request
        [self sendRequest:self.currentPage withProgress:YES];
    }
    NSDictionary *info = @{@"page":[NSNumber numberWithInt:self.currentPage],@"isProgress":@NO};
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:info repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    [self.request clearDelegatesAndCancel];
}

-(void)onTimer:(NSTimer *)timer {
    NSDictionary *condition = [timer userInfo];
    [self sendRequest:[[condition objectForKey:@"page"] intValue] withProgress:[[condition objectForKey:@"isProgress"] boolValue]];
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
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EquipmentListCell class]) owner:self options:nil] objectAtIndex:1];
//    view.backgroundColor = kGeneralColor;
//    return view;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EquipmentListCell class]) owner:self options:nil] objectAtIndex:1];
//    return view.frame.size.height;
//}

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
    NSDictionary *equipmentInfo = [self.list objectAtIndex:indexPath.row];
    NSString *imgName = [NSString stringWithFormat:@"%@%@",@"equipment_",[Tool stringToString:[equipmentInfo objectForKey:@"code"]]];
    cell.imgView.image = [UIImage imageNamed:imgName];
    cell.lblEquipmentName.text = [NSString stringWithFormat:@"%@[%@]",[Tool stringToString:[equipmentInfo objectForKey:@"typename"]],[Tool stringToString:[equipmentInfo objectForKey:@"materialName"]]];
    cell.lblSN.text = [NSString stringWithFormat:@"%@%@",@"SN:",[Tool stringToString:[equipmentInfo objectForKey:@"sn"]]];
    cell.lblStatus.text = [NSString stringWithFormat:@"%@%@",@"状态:",[Tool stringToString:[equipmentInfo objectForKey:@"statusLabel"]]];
    cell.lblLineName.text = [NSString stringWithFormat:@"%@%@",@"产线:",[Tool stringToString:[equipmentInfo objectForKey:@"linename"]]];
    cell.lblInstantFlowRate.text = [NSString stringWithFormat:@"瞬时流量:%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:[Tool doubleValue:[equipmentInfo objectForKey:@"instantFlowRate"]]]],@"吨/时"];
    cell.lblSettingFlowRate.text = [NSString stringWithFormat:@"设定流量:%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:[Tool doubleValue:[equipmentInfo objectForKey:@"settingFlowRate"]]]],@"吨/时"];
    cell.lblPartOutput.text = [NSString stringWithFormat:@"分累积量:%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:[Tool doubleValue:[equipmentInfo objectForKey:@"partOutput"]]]],@"吨"];
    cell.lblTotalOutput.text = [NSString stringWithFormat:@"总累积量:%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:[Tool doubleValue:[equipmentInfo objectForKey:@"totalOutput"]]]],@"吨"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *equipmentInfo = [self.list objectAtIndex:indexPath.row];
//    int equipmentStatus = [[equipmentInfo objectForKey:@"status"] intValue];
//    if (equipmentStatus==0) {
//        cell.backgroundColor = [UIColor greenColor];
//    }else{
//        cell.backgroundColor = [UIColor redColor];
//    }
//}


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
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
//    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"count"];
    [self.request setPostValue:[NSNumber numberWithInt:100] forKey:@"count"];
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
    NSString *message = nil;
    if ([@"The request timed out" isEqualToString:[[request error] localizedDescription]]) {
        message = @"网络请求超时啦。。。";
    }else{
        message = @"网络出错啦。。。";
    }
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight) message:message];
    [self.view performSelector:@selector(addSubview:) withObject:self.messageView afterDelay:0.5];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==kErrorCode0) {
        if (self.currentPage==1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"equipments"]];
        if (self.list.count>0) {
            self.navigationItem.rightBarButtonItem = self.rightButtonItem;
        }
        self.totalCount = [[[dict objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
        [self.tableView reloadData];
    }else if(responseCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
    [self.progressHUD hide:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"touchesCancelled");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touchesEnded");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"touchesMoved");
}

@end
