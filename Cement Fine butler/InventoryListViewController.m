//
//  InventoryListViewController.m
//  Cement Fine butler
//  原材料库存盘点
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryListViewController.h"
#import "InventoryCommonCell.h"

@interface InventoryListViewController ()
@property (nonatomic,retain) NSMutableArray *list;
@end

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    cell.lblName.text = [info objectForKey:@""];
    cell.lblInventory.text = [info objectForKey:@""];
    cell.lblDate.text = [info objectForKey:@""];
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
    switch (self.type) {
        case 0:
            lblName.text = @"原材料库存";
            break;
        case 1:
            lblName.text = @"半成品库存";
            break;
        case 2:
            lblName.text = @"成品库存";
            break;
        default:
            lblName.text = @"原材料库存";
            break;
    }
    
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

@end
