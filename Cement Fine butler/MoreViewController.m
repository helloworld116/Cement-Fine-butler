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
#import "ChoiceCell.h"

@interface MoreViewController ()
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
    self.options = @[
         @{@"name":@"原材料成本计算器",@"storyboard":@"rawMaterialsCalViewController"},
         @{@"name":@"电力价格管理",@"storyboard":@"electricityPriceViewController"},
         @{@"name":@"消息",@"storyboard":@"messageViewController"},
         @{@"name":@"生产启动",@"storyboard":@"productionStartupViewController"},
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
        return kSharedApp.factorys.count;
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
    static NSString *CellIdentifier = @"ChoiceCell";
    ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[ChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        cell.lblName.text = [kSharedApp.factorys[indexPath.row] objectForKey:@"name"];
        if (indexPath.row==0) {
            cell.imgChecked.hidden = NO;
        }
    }else if(indexPath.section==1) {
        cell.lblName.text = [self.options[indexPath.row] objectForKey:@"name"];
    }else{
        cell.lblName.text = @"退出当前账号";
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        for (int i=0; i<[[tableView visibleCells] count]; i++) {
            ChoiceCell *cell = (ChoiceCell *)[[tableView visibleCells] objectAtIndex:i];
            cell.imgChecked.hidden = YES;
        }
        ChoiceCell *cell = (ChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgChecked.hidden = NO;
//        self.currentSelectCellIndex = indexPath.row;
    }else if (indexPath.section==1) {
        NSString *controllerIdentifier = [self.options[indexPath.row] objectForKey:@"storyboard"];
        UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        nextViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"username"];
        [defaults removeObjectForKey:@"password"];
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

@end
