//
//  InventoryListViewController.m
//  Cement Fine butler
//  原材料库存盘点
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryListViewController.h"
#import "InventoryCommonCell.h"

@interface InventoryListViewController ()<MBProgressHUDDelegate>
@property (nonatomic,retain) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSString *URL;
@property (nonatomic) NSUInteger currentPage;
@end
//kInventoryList
//accessToken=06275d466e14db86199ec030d46800a8&factoryId=2&page=1&rows=10&beginTime=1356969600000&endTime=1385827200000
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
    
    self.currentPage = 1;
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
    static NSString *CellIdentifier = @"Cell";
    InventoryCommonCell *cell = (InventoryCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (!cell) {
        cell = [[InventoryCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
    cell.lblName.text = [Tool stringToString:[info objectForKey:@"productName"]];
    cell.lblInventory.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"stock"] floatValue]];
    cell.lblDate.text = [Tool stringToString:[info objectForKey:@"strCreateTime"]];
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
    lblName.text = self.title;
    
    UILabel *lblInventory = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, viewHeight)];
    lblInventory.backgroundColor = [UIColor clearColor];
    lblInventory.textAlignment = UITextAlignmentCenter;
    lblInventory.font = [UIFont systemFontOfSize:12.f];
    lblInventory.textColor = [UIColor whiteColor];
    lblInventory.text = @"库存量(吨)";
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, viewHeight)];
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

#pragma UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSUInteger)currentPage{
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
    
    DDLogCInfo(@"******  Request URL is:%@  ******",self.URL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.URL]];
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
        [self.list addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"rows"] ];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
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


-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
