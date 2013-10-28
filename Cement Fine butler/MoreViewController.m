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
    self.options = @[@"计算器",@"电力价格管理",@"消息",@"生产记录",@"修改密码"];
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
    cell.textLabel.text = self.options[indexPath.row];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *nextViewController = nil;
    switch (indexPath.row) {
        case 0:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalViewController"];
            break;
        case 1:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electricityPriceViewController"];
            break;
        case 2:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"];
            break;
        case 3:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productHistoryViewController"];
            break;
        case 4:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"updatePasswordViewController"];
            break;
    }
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
