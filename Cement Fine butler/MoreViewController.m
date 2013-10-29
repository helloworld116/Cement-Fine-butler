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
                     @{@"name":@"生产记录",@"storyboard":@"productHistoryViewController"},
                     @{@"name":@"库存盘点",@"storyboard":@"inventoryViewController"},
                     @{@"name":@"库存设置",@"storyboard":@"inventorySettingListViewController"},
                     @{@"name":@"过磅录入",@"storyboard":@"weighViewController"},
                     @{@"name":@"固定成本管理",@"storyboard":@"fixedCostsViewController"},
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.options[indexPath.row] objectForKey:@"name"];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *controllerIdentifier = [self.options[indexPath.row] objectForKey:@"storyboard"];
    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
