//
//  ElectricityPriceViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-25.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectricityPriceViewController.h"
#import "ElectricityCell.h"
#import "ElectrcityOperateViewController.h"
#import "PassValueDelegate.h"

@interface ElectricityPriceViewController ()<PassValueDelegate,SWTableViewCellDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) NODataView *noDataView;
@property (nonatomic,assign) NSUInteger currentSelectedIndex;

@property (nonatomic) NSUInteger totalCount;
@property (nonatomic) NSUInteger currentPage;
@end

@implementation ElectricityPriceViewController

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
    self.title = @"电力价格";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    if (!kSharedApp.multiGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    }
    self.tableView.rowHeight = 60.f;
    //数据
    self.list = [NSMutableArray array];
    self.currentSelectedIndex = -1;
    //发送请求
    self.currentPage = 1;
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
    return self.list.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"ElectricityCell";
//    ElectricityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.delegate = self;
//    NSDictionary *data = self.list[indexPath.row];
//    cell.CellID = [[data objectForKey:@"id"] longValue];
//    cell.lblElectricityPrice = [data objectForKey:@"value"];
//    cell.lblDate = [data objectForKey:@"date"];
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ElectricityCell";
    ElectricityCell *cell = (ElectricityCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        if (!kSharedApp.multiGroup) {
            [rightUtilityButtons addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"修改"];
            [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:251./255. green:34./255. blue:38./255. alpha:1.] title:@"删除"];
        }
        cell = [[ElectricityCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:self.tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    NSDictionary *data = self.list[indexPath.row];
    cell.CellID = [[data objectForKey:@"id"] longValue];
    cell.lblElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[data objectForKey:@"price"] floatValue]];
    cell.lblDate.text = [data objectForKey:@"createTime_str"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat viewHeight = 21.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.66f;
    
    UILabel *lblElectricityPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, viewHeight)];
    lblElectricityPrice.backgroundColor = [UIColor clearColor];
    lblElectricityPrice.textAlignment = UITextAlignmentCenter;
    lblElectricityPrice.font = [UIFont systemFontOfSize:12.f];
    lblElectricityPrice.textColor = [UIColor whiteColor];
    lblElectricityPrice.text = @"电力价格	";
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, viewHeight)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textAlignment = UITextAlignmentCenter;
    lblDate.font = [UIFont systemFontOfSize:12.f];
    lblDate.textColor = [UIColor whiteColor];
    lblDate.text = @"时间";
    
    [view addSubview:lblElectricityPrice];
    [view addSubview:lblDate];
    
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kSharedApp.multiGroup) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.currentSelectedIndex = indexPath.row;
        ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
        nextViewController.electricityInfo = [self.list objectAtIndex:indexPath.row];
        nextViewController.delegate = self;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

ElectricityCell *currentOperateCell;
- (void)swippableTableViewCell:(ElectricityCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
            nextViewController.electricityInfo = [self.list objectAtIndex:index];
            [self.navigationController pushViewController:nextViewController animated:YES];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            currentOperateCell = cell;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定删除该条记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    switch (buttonIndex) {
        case 0:
//            [currentOperateCell hideUtilityButtonsAnimated:YES];
            currentOperateCell=nil;
            break;
        case 1:{
            [self deleteEle];
            }
            break;
        default:
            break;
    }
}

-(void)add:(id)sender{
    ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
    nextViewController.delegate = self;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSUInteger)currentPage withProgress:(BOOL)isProgress{
    //加载过程提示
    if (isProgress) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHUD.labelText = @"加载中...";
        self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
        self.progressHUD.dimBackground = YES;
        self.progressHUD.opacity=1.0;
        self.progressHUD.delegate = self;
        [self.view addSubview:self.progressHUD];
        [self.progressHUD show:YES];
    }
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kElectricityList);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kElectricityList]];
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
    if (errorCode==kErrorCode0) {
        if (self.currentPage==1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"rows"] ];
        self.totalCount = [[[dict objectForKey:@"data"] objectForKey:@"total"] integerValue];
        [self.tableView reloadData];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [kSharedApp.window performSelector:@selector(setRootViewController:) withObject:loginViewController afterDelay:3.f];
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

#pragma mark 删除电力价格
-(void) deleteEle{
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kElectricityDelete);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kElectricityDelete]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:kPageSize] forKey:@"ids"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(deleteRequestFailed:)];
    [self.request setDidFinishSelector:@selector(deleteRequestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) deleteRequestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
}

-(void) deleteRequestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:currentOperateCell];
        [self.list removeObjectAtIndex:cellIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        currentOperateCell = nil;
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [kSharedApp.window performSelector:@selector(setRootViewController:) withObject:loginViewController afterDelay:3.f];
    }else{
    }
    [self.progressHUD hide:YES];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark PassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    id databaseId = [newValue objectForKey:@"id"];
    id createTime_str = [newValue objectForKey:@"createTime_str"];
    id price = [newValue objectForKey:@"price"];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:databaseId forKey:@"id"];
    [newDict setObject:createTime_str forKey:@"createTime_str"];
    [newDict setObject:price forKey:@"price"];

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
@end
