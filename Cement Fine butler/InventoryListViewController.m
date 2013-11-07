//
//  InventoryListViewController.m
//  Cement Fine butler
//  原材料库存盘点
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryListViewController.h"
#import "InventoryCommonCell.h"
#import "InventoryOperateViewController.h"
#import "InventoryPassValueDelegate.h"

@interface InventoryListViewController ()<MBProgressHUDDelegate,InventoryPassValueDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSString *URL;
@property (nonatomic) NSUInteger currentSelectedIndex;//-1表示没有选择任何一个
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalCount;
@end

@implementation InventoryListViewController

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
    if (!kSharedApp.multiGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    }
    switch (self.type) {
        case 0:
            self.title = @"原材料库存";
            self.URL = kInventoryMaterialList;
            break;
        case 1:
            self.title = @"半成品库存";
            self.URL = kInventoryHalfList;
            break;
        case 2:
            self.title = @"成品库存";
            self.URL = kInventoryProductList;
            break;
        default:
            self.title = @"原材料库存";
            self.URL = kInventoryMaterialList;
            break;
    }
    self.tableView.rowHeight = 60.f;
//    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
//    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
//    self.pullTableView.pullTextColor = [UIColor blackColor];
    
    self.currentPage = 1;
    self.currentSelectedIndex = -1;
    self.list = [NSMutableArray array];
    [self sendRequest:self.currentPage withProgress:YES];
//    if(!self.pullTableView.pullTableIsRefreshing) {
//        self.pullTableView.pullTableIsRefreshing = YES;
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
//    }
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
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryCommonCell";
    InventoryCommonCell *cell = (InventoryCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[InventoryCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    NSString *lblNameStr = nil;
    switch (self.type) {
        case 0:
            lblNameStr = [Tool stringToString:[info objectForKey:@"materialName"]];
            break;
        case 1:
        case 2:
            lblNameStr = [Tool stringToString:[info objectForKey:@"productName"]];
            break;
        default:
            lblNameStr = [Tool stringToString:[info objectForKey:@"materialName"]];
            break;
    }
    cell.lblName.text = lblNameStr;
    cell.lblInventory.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"stock"] floatValue]];
    cell.lblDate.text = [Tool stringToString:[info objectForKey:@"strCreateTime"]];
    if (!kSharedApp.multiGroup) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat viewHeight = 21.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.66f;
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, viewHeight)];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textAlignment = UITextAlignmentCenter;
    lblName.font = [UIFont systemFontOfSize:12.f];
    lblName.textColor = [UIColor whiteColor];
    switch (self.type) {
        case 0:
            lblName.text = @"原材料";
            break;
        case 1:
            lblName.text = @"半成品";
            break;
        case 2:
            lblName.text = @"成品";
            break;
        default:
            lblName.text = @"原材料";
            break;
    }
    
    UILabel *lblInventory = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, viewHeight)];
    lblInventory.backgroundColor = [UIColor clearColor];
    lblInventory.textAlignment = UITextAlignmentCenter;
    lblInventory.font = [UIFont systemFontOfSize:12.f];
    lblInventory.textColor = [UIColor whiteColor];
    lblInventory.text = @"库存量(吨)";
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 95, viewHeight)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textAlignment = UITextAlignmentCenter;
    lblDate.font = [UIFont systemFontOfSize:12.f];
    lblDate.textColor = [UIColor whiteColor];
    lblDate.text = @"盘点时间";
    
    [view addSubview:lblName];
    [view addSubview:lblInventory];
    [view addSubview:lblDate];
    
    return view;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kSharedApp.multiGroup) {
        self.currentSelectedIndex = indexPath.row;
        InventoryOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryOperateViewController"];
        nextViewController.type = self.type;
        nextViewController.inventoryInfo = [self.list objectAtIndex:indexPath.row];
        nextViewController.delegate = self;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
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
    DDLogCInfo(@"******  Request URL is:%@  ******",self.URL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.URL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"rows"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1356969600000] forKey:@"beginTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1385827200000] forKey:@"endTime"];
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
        self.totalCount = [[[dict objectForKey:@"data"] objectForKey:@"total"] intValue];
        if (self.currentPage==1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"rows"] ];
        [self.tableView reloadData];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{

    }
    [self.progressHUD hide:YES];
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
    self.currentPage = 1;
    [self sendRequest:self.currentPage withProgress:NO];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    //Code to actually load more data goes here.
    if (self.totalCount>self.currentPage*kPageSize) {
        self.currentPage++;
        [self sendRequest:self.currentPage withProgress:NO];
    }
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    id name = [newValue objectForKey:@"name"];
    id time = [newValue objectForKey:@"time"];
    id stock = [newValue objectForKey:@"stock"];
    id _id = [newValue objectForKey:@"inventoryId"];
    id databaseId = [newValue objectForKey:@"id"];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    if (self.type==0) {
       [newDict setObject:name forKey:@"materialName"];
        [newDict setObject:_id forKey:@"materialId"];
    }else{
        [newDict setObject:name forKey:@"productName"];
        [newDict setObject:_id forKey:@"productId"];
    }
    [newDict setObject:time forKey:@"strCreateTime"];
    [newDict setObject:stock forKey:@"stock"];
    [newDict setObject:databaseId forKey:@"id"];
    //之前没有选择，说明是进行添加操作
    if (self.currentSelectedIndex==-1) {
        [self.list insertObject:newDict atIndex:0];
        [self.tableView beginUpdates];
        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[self tableView] insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
//        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.list replaceObjectAtIndex:self.currentSelectedIndex withObject:newDict];
        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender{
    self.currentSelectedIndex = -1;
    InventoryOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryOperateViewController"];
    nextViewController.delegate = self;
    nextViewController.type = self.type;
    [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
