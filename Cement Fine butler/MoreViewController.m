//
//  MoreViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-25.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MoreViewController.h"
#import "RawMaterialsCalViewController.h"
#import "ElectricityPriceViewController.h"
#import "PassValueDelegate.h"
#import "ChoiceFactoryViewController.h"
#import "ProductColumnViewController.h"

@interface MoreViewController ()<PassValueDelegate>
@property (nonatomic,retain) NSArray *options;
@end

@implementation MoreViewController

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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    self.navigationItem.title = @"更多操作";
//    self.tableView.bounces = NO;
    self.tableView.rowHeight = 60;
    self.options = @[
//         @{@"name":@"原材料成本计算器",@"storyboard":@"rawMaterialsCalViewController"},
         @{@"name":@"电力价格管理",@"storyboard":@"electricityPriceViewController"},
//         @{@"name":@"消息历史",@"storyboard":@"messageViewController"},
//         @{@"name":@"生产启动",@"storyboard":@"productionStartupViewController"},
         @{@"name":@"过磅管理",@"storyboard":@"weighViewController"},
         @{@"name":@"生产记录",@"storyboard":@"productHistoryViewController"},
         @{@"name":@"库存盘点",@"storyboard":@"inventoryViewController"},
         @{@"name":@"库位设置",@"storyboard":@"inventorySettingListViewController"},
         @{@"name":@"固定成本管理",@"storyboard":@"fixCostsViewController"},
         @{@"name":@"行业数据",@"storyboard":@"industryStandardVC"}
         ];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.sidePanelController setRightPanel:nil];
    [self.sidePanelController setLeftPanel:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 1;
    }else if(section==3) {
        return self.options.count;
    }else if(section==4){
        return 1;
    }else{
        //账号与安全
        return 2;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"当前工厂";
    }else if(section==1){
        return @"报表";
    }else if (section==2){
        return @"成本计算";
    }else if (section==3) {
        return @"数据录入";
    }else if (section==4) {
        return @"消息";
    }else{
        return @"账号与安全";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = [kSharedApp.factory objectForKey:@"name"];
        if (kSharedApp.factorys.count>1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.section==1){
        cell.textLabel.text = @"实时报表";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section==2){
        cell.textLabel.text = @"原材料成本计算器";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section==3) {
        cell.textLabel.text = [self.options[indexPath.row] objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section==4){
        cell.textLabel.text = @"消息列表";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section==5){
        if (indexPath.row==0) {
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==1){
            cell.textLabel.text = @"退出当前账号";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (kSharedApp.factorys.count>1) {
            ChoiceFactoryViewController *nextViewController = [[ChoiceFactoryViewController alloc] init];
            nextViewController.delegate = self;
            nextViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextViewController animated:YES];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }else if(indexPath.section==1){
        //实时报表
        ProductColumnViewController *productColumnVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
        productColumnVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productColumnVC animated:YES];
    }else if(indexPath.section==2){
        UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalViewController"];
        nextViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else if (indexPath.section==3) {
        NSString *controllerIdentifier = [self.options[indexPath.row] objectForKey:@"storyboard"];
        UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        nextViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else if(indexPath.section==4){
        UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"];
        nextViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else if(indexPath.section==5){
        if (indexPath.row==0) {
            UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"updatePasswordViewController"];
            nextViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextViewController animated:YES];
        }else if(indexPath.row==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"password"];
            //        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            //        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            kSharedApp.accessToken=nil;
            kSharedApp.expiresIn=0;
            kSharedApp.factorys=nil;
            kSharedApp.factory=nil;
            kSharedApp.user=nil;
            kSharedApp.multiGroup=NO;
            //取消自动登录服务
            [kSharedApp.loginTimer invalidate];
            //取消定时获取消息服务
            [kSharedApp.messageTimer invalidate];
            //取消所有本地通知
            NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
            for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
            LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            kSharedApp.window.rootViewController = loginViewController;
        }
            break;
        default:
            break;
    }
}

#pragma mark PassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text = [newValue objectForKey:@"name"];
}
@end
