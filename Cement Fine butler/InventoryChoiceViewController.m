//
//  InventoryChoiceViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryChoiceViewController.h"
#import "ChoiceCell.h"

@interface InventoryChoiceViewController ()<MBProgressHUDDelegate>
@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSUInteger firstSelectCellIndex;
@property (nonatomic) NSUInteger currentSelectCellIndex;
@end

@implementation InventoryChoiceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    NSString *title = nil;
    switch (self.type) {
        case 0:
            title = @"原材料";
            break;
        case 1:
            title = @"半成品";
            break;
        case 2:
            title = @"成品";
            break;
    }
    self.title = [NSString stringWithFormat:@"%@选择",title];
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureChoice:)];
    self.firstSelectCellIndex = -1;
//    self.navigationItem.rightBarButtonItem 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self sendRequest];
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
    static NSString *CellIdentifier = @"ChoiceCell";
    ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[ChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = self.list[indexPath.row];
    NSString *name;
    int inventoryId;
    if (self.type==0) {
        inventoryId = [[info objectForKey:@"materialId"] intValue];
        name = [info objectForKey:@"materialName"];
    }else{
        inventoryId = [[info objectForKey:@"productId"] intValue];
        name = [info objectForKey:@"productName"];
    }
    if (self.inventoryId == inventoryId) {
        self.firstSelectCellIndex = indexPath.row;
        cell.imgChecked.hidden = NO;
    }
    cell._id = inventoryId;
    cell.lblName.text = name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        ChoiceCell *cell = [[tableView visibleCells] objectAtIndex:i];
        cell.imgChecked.hidden = YES;
    }
    ChoiceCell *cell = (ChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgChecked.hidden = NO;
    self.currentSelectCellIndex = indexPath.row;
    if (self.currentSelectCellIndex==self.firstSelectCellIndex) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}


#pragma mark 发送网络请求
-(void) sendRequest{
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.tableView addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    switch (self.type) {
        case 0:
            DDLogCInfo(@"******  Request URL is:%@  ******",kInventoryAllMaterialList);
            self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kInventoryAllMaterialList]];
            break;
            
        case 1:
            DDLogCInfo(@"******  Request URL is:%@  ******",kInventoryAllHalfProductList);
            self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kInventoryAllHalfProductList]];
            break;
        case 2:
            DDLogCInfo(@"******  Request URL is:%@  ******",kInventoryAllProductList);
            self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kInventoryAllProductList]];
            break;
    }
    //设置缓存方式
    [self.request setDownloadCache:kSharedApp.myCache];
    //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
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
        self.list = [dict objectForKey:@"data"];
        [self.tableView reloadData];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
    [self.progressHUD hide:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureChoice:(id)sender{
    NSDictionary *oldDict = self.list[self.currentSelectCellIndex];
    NSString *_id,*_name;
    if (self.type==0) {
        _id = @"materialId";
        _name = @"materialName";
    }else{
        _id = @"productId";
        _name = @"productName";
    }
    NSDictionary *newDict = @{@"id":[oldDict objectForKey:_id],@"name":[oldDict objectForKey:_name]};
    [self.delegate passValue:newDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
