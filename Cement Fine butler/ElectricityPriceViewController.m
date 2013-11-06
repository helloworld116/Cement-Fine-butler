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

@interface ElectricityPriceViewController ()<SWTableViewCellDelegate,MBProgressHUDDelegate>
@property (retain,nonatomic) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
//@property (nonatomic) NSUInteger currentPage;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) NODataView *noDataView;
@property (retain,nonatomic) NSDictionary *requestCondition;
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
//    self.list = [@[@{@"id":@1,@"date":@"2013-09-22",@"value":@1.1f},@{@"id":@2,@"date":@"2013-09-23",@"value":@1.2f},@{@"id":@3,@"date":@"2013-09-24",@"value":@1.3f},@{@"id":@4,@"date":@"2013-09-25",@"value":@1.4f},@{@"id":@5,@"date":@"2013-09-26",@"value":@1.5f},@{@"id":@6,@"date":@"2013-09-27",@"value":@1.6f},@{@"id":@7,@"date":@"2013-09-28",@"value":@1.7f}] mutableCopy];
    self.requestCondition = @{@"currentPage": @1};
    //数据
    self.list = [NSMutableArray array];
    //发送请求
    [self sendRequest:self.requestCondition];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
    nextViewController.electricityInfo = [self.list objectAtIndex:indexPath.row];
//    ElectricityCell *cell = (ElectricityCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell hideUtilityButtonsAnimated:YES];
    [self.navigationController pushViewController:nextViewController animated:YES];
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
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:currentOperateCell];
                [self.list removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                currentOperateCell = nil;
            }
            break;
        default:
            break;
    }
}

-(void)add:(id)sender{
    ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
//    self.data = nil;
//    if (self.noDataView) {
//        [self.noDataView removeFromSuperview];
//        self.noDataView = nil;
//    }
    self.tableView.hidden=YES;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kElectricityList]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:[[condition objectForKey:@"currentPage"] intValue]] forKey:@"page"];
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
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"rows"] ];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }else if(errorCode==kErrorCodeNegative1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
//        self.data = nil;
//        [self.webView reload];
//        [self setBottomViewOfSubView];
//        self.noDataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
//        [self.view performSelector:@selector(addSubview:) withObject:self.noDataView afterDelay:0.5];
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}


-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
