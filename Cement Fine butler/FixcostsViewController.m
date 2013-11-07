//
//  FixcostsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "FixcostsViewController.h"
#import "FixcostCell.h"
#import "FixCostOperateViewController.h"

@interface FixcostsViewController ()<MBProgressHUDDelegate,PassValueDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSUInteger currentSelectedIndex;//-1表示没有选择任何一个
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalCount;

@end

@implementation FixcostsViewController

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
    self.title = @"固定成本列表";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FixcostCell";
    FixcostCell *cell = (FixcostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[FixcostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    cell.lblName.text = [Tool stringToString:[info objectForKey:@"name"]];
    cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"price"] floatValue]];
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
    lblName.text = @"成本项";
    
    UILabel *lblInventory = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, viewHeight)];
    lblInventory.backgroundColor = [UIColor clearColor];
    lblInventory.textAlignment = UITextAlignmentCenter;
    lblInventory.font = [UIFont systemFontOfSize:12.f];
    lblInventory.textColor = [UIColor whiteColor];
    lblInventory.text = @"耗费(元)";
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 95, viewHeight)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textAlignment = UITextAlignmentCenter;
    lblDate.font = [UIFont systemFontOfSize:12.f];
    lblDate.textColor = [UIColor whiteColor];
    lblDate.text = @"时间";
    
    [view addSubview:lblName];
    [view addSubview:lblInventory];
    [view addSubview:lblDate];
    return view;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kSharedApp.multiGroup) {
        self.currentSelectedIndex = indexPath.row;
        FixCostOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fixCostOperateViewController"];
        nextViewController.fixcostInfo = [self.list objectAtIndex:indexPath.row];
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
    DDLogCInfo(@"******  Request URL is:%@  ******",kFixcostList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kFixcostList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"rows"];
//    [self.request setPostValue:@"" forKey:@"beginTime"];
//    [self.request setPostValue:@"" forKey:@"endTime"];
    [self.request setPostValue:@"0" forKey:@"subject"];
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
    FixCostOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fixCostOperateViewController"];
    nextViewController.delegate = self;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
