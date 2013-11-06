//
//  ProductHistoryViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductHistoryViewController.h"
#import "ProductHistoryCell.h"
#import "PassValueDelegate.h"
#import "ProductHistoryUpdateViewController.h"

@interface ProductHistoryViewController ()<MBProgressHUDDelegate,PassValueDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSUInteger currentSelectedIndex;//-1表示没有选择任何一个
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalCount;
@end

@implementation ProductHistoryViewController

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
    self.title = @"生产记录列表";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    if (!kSharedApp.multiGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    }
    self.tableView.rowHeight = 60.f;
    self.currentPage = 1;
    self.currentSelectedIndex = -1;
    self.list = [NSMutableArray array];
    [self sendRequest:self.currentPage withProgress:YES];
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
    static NSString *CellIdentifier = @"ProductHistoryCell";
    ProductHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:1];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    cell.lblLine.text = [Tool stringToString:[info objectForKey:@"name"]];
    cell.lblProduct.text = [Tool stringToString:[info objectForKey:@"productZhDes"]];
    cell.lblTime.text = [Tool stringToString:[info objectForKey:@"start_time_str"]];
    if (!kSharedApp.multiGroup) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *CellIdentifier = @"ProductHistoryCell";
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    return view;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kSharedApp.multiGroup) {
        self.currentSelectedIndex = indexPath.row;
        ProductHistoryUpdateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productHistoryUpdateViewController"];
        nextViewController.productHistoryInfo = [self.list objectAtIndex:indexPath.row];
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
    DDLogCInfo(@"******  Request URL is:%@  ******",kProductHistoryList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kProductHistoryList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"rows"];
    [self.request setPostValue:@"0" forKey:@"lineId"];
    [self.request setPostValue:@"0" forKey:@"productId"];
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
    }else if(errorCode==kErrorCodeNegative1){
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

#pragma mark PassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    id databaseId = [newValue objectForKey:@"id"];
    id productId = [newValue objectForKey:@"productId"];
    id productName = [newValue objectForKey:@"productName"];
    id lineId = [newValue objectForKey:@"lineId"];
    id lineName = [newValue objectForKey:@"lineName"];
    id time = [newValue objectForKey:@"time"];

    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:databaseId forKey:@"id"];
    [newDict setObject:productId forKey:@"productId"];
    [newDict setObject:productName forKey:@"productZhDes"];
    [newDict setObject:lineId forKey:@"lineId"];
    [newDict setObject:lineName forKey:@"name"];
    [newDict setObject:time forKey:@"start_time_str"];
    //之前没有选择，说明是进行添加操作
    if (self.currentSelectedIndex==-1) {
        [self.list insertObject:newDict atIndex:0];
        [self.tableView beginUpdates];
        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[self tableView] insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
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
    ProductHistoryUpdateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productHistoryUpdateViewController"];
    nextViewController.delegate = self;
    [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
