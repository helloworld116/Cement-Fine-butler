//
//  InventorySettingListViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventorySettingListViewController.h"
#import "InventorySettingListCell.h"
#import "PassValueDelegate.h"
#import "InventorySettingUpdateViewController.h"

@interface InventorySettingListViewController ()<MBProgressHUDDelegate,PassValueDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSUInteger currentSelectedIndex;//-1表示没有选择任何一个
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalCount;
@end

@implementation InventorySettingListViewController

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
    static NSString *CellIdentifier = @"InventorySettingListCell";
    InventorySettingListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:1];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    if(![Tool isNullOrNil:[info objectForKey:@"material"]]){
        cell.lblName.text = [Tool stringToString:[[info objectForKey:@"material"] objectForKey:@"name"]];
    }
    cell.lblTotal.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"stock"] doubleValue]];
    cell.lblCaps.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"topLimit"] doubleValue]];
    cell.lblLower.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"lowerLimit"] doubleValue]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *CellIdentifier = @"InventorySettingListCell";
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    return view;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelectedIndex = indexPath.row;
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    InventorySettingUpdateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inventorySettingUpdateViewController"];
    nextViewController.info = info;
    nextViewController.delegate = self;
    [self.navigationController pushViewController:nextViewController animated:YES];

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
    DDLogCInfo(@"******  Request URL is:%@  ******",kInventorySettingList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kInventorySettingList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
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
    id topLimit = [newValue objectForKey:@"topLimit"];
    id lowerLimit = [newValue objectForKey:@"lowerLimit"];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.list[self.currentSelectedIndex]];
    [newDict setObject:topLimit forKey:@"topLimit"];
    [newDict setObject:lowerLimit forKey:@"lowerLimit"];
    [self.list replaceObjectAtIndex:self.currentSelectedIndex withObject:newDict];
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
