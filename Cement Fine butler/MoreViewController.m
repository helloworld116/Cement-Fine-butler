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
    self.navigationItem.title = @"更多操作";
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 60;
    self.options = @[
         @{@"name":@"原材料成本计算器",@"storyboard":@"rawMaterialsCalViewController"},
         @{@"name":@"电力价格管理",@"storyboard":@"electricityPriceViewController"},
         @{@"name":@"消息",@"storyboard":@"messageViewController"},
//         @{@"name":@"生产启动",@"storyboard":@"productionStartupViewController"},
         @{@"name":@"过磅管理",@"storyboard":@"weighViewController"},
         @{@"name":@"生产记录",@"storyboard":@"productHistoryViewController"},
         @{@"name":@"库存盘点",@"storyboard":@"inventoryViewController"},
         @{@"name":@"库位设置",@"storyboard":@"inventorySettingListViewController"},
         @{@"name":@"固定成本管理",@"storyboard":@"fixCostsViewController"},
         @{@"name":@"修改密码",@"storyboard":@"updatePasswordViewController"}
         ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1) {
        return self.options.count;
    }else{
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"当前工厂";
    }else if (section==1) {
        return @"录入相关";
    }else{
        return @"账号";
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
    }else if(indexPath.section==1) {
        cell.textLabel.text = [self.options[indexPath.row] objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = @"退出当前账号";
        cell.accessoryType = UITableViewCellAccessoryNone;
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
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }else if (indexPath.section==1) {
        NSString *controllerIdentifier = [self.options[indexPath.row] objectForKey:@"storyboard"];
        UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        nextViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else{
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
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
}

#pragma mark PassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    kSharedApp.factory = newValue;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text = [newValue objectForKey:@"name"];
}
@end
