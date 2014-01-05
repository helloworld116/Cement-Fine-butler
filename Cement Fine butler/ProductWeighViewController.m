//
//  ProductWeighViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-1.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductWeighViewController.h"
#import "PassValueDelegate.h"
#import "ProductWeighCell.h"

@interface ProductWeighViewController ()<MBProgressHUDDelegate,PassValueDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSUInteger currentSelectedIndex;//-1表示没有选择任何一个
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalCount;
@end

@implementation ProductWeighViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"销售记录";
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    if (!kSharedApp.multiGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus_icon"] highlightedImage:[UIImage imageNamed:@"plus_click_icon"] target:self action:@selector(add:)];
    }
    self.tableView.rowHeight = 50.f;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductWeighCell";
    ProductWeighCell *cell = (ProductWeighCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:1];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    cell.lblProductName.text = [Tool stringToString:[info objectForKey:@"productName"]];
    double unitPrice = 0;
    if (![Tool isNullOrNil:[info objectForKey:@"price"]]) {
        unitPrice = [[info objectForKey:@"price"] doubleValue];
    }
    cell.lblUnitPrice.text = [NSString stringWithFormat:@"%.2f",unitPrice];
    double totalPrice = 0;
    if (![Tool isNullOrNil:[info objectForKey:@"amount"]]) {
        totalPrice = [[info objectForKey:@"amount"] doubleValue];
    }
    cell.lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",totalPrice];
    cell.lblTime.text = [Tool stringToString:[info objectForKey:@"createDate"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *CellIdentifier = @"ProductWeighCell";
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    return view;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelectedIndex = indexPath.row;
    //    FixCostOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fixCostOperateViewController"];
    //    nextViewController.fixcostInfo = [self.list objectAtIndex:indexPath.row];
    //    nextViewController.delegate = self;
    //    [self.navigationController pushViewController:nextViewController animated:YES];
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
    DDLogCInfo(@"******  Request URL is:%@  ******",kWeighProductList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kWeighProductList]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"rows"];
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

#pragma mark PassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    id name = [newValue objectForKey:@"name"];
    id time = [newValue objectForKey:@"strCreateTime"];
    id price = [newValue objectForKey:@"price"];
    id _id = [newValue objectForKey:@"subject"];
    id databaseId = [newValue objectForKey:@"id"];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:name forKey:@"name"];
    [newDict setObject:_id forKey:@"subject"];
    [newDict setObject:time forKey:@"strCreateTime"];
    [newDict setObject:price forKey:@"price"];
    [newDict setObject:databaseId forKey:@"id"];
    
    [self.list insertObject:newDict atIndex:0];
    [self.tableView beginUpdates];
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[self tableView] insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender{
    //    self.currentSelectedIndex = -1;
    //    FixCostOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fixCostOperateViewController"];
    //    nextViewController.delegate = self;
    //    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
