//
//  InventoryViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryViewController.h"
#import "InventoryListViewController.h"

@interface InventoryViewController ()
@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) InventoryListViewController *materialListVC;
@property (nonatomic,retain) InventoryListViewController *semiListVC;
@property (nonatomic,retain) InventoryListViewController *endListVC;
@end

@implementation InventoryViewController

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
    self.title = @"库存盘点";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.list = @[@"原材料库存",@"半成品库存",@"成品库存"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            if (!self.materialListVC) {
               self.materialListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryListViewController"];
            }
            self.materialListVC.type = indexPath.row;
            [self.navigationController pushViewController:self.materialListVC animated:YES];
            break;
        case 1:
            if (!self.semiListVC) {
                self.semiListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryListViewController"];
            }
            self.semiListVC.type = indexPath.row;
            [self.navigationController pushViewController:self.semiListVC animated:YES];
            break;
        case 2:
            if (!self.endListVC) {
                self.endListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryListViewController"];
            }
            self.endListVC.type = indexPath.row;
            [self.navigationController pushViewController:self.endListVC animated:YES];
            break;
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
