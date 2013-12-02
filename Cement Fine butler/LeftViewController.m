//
//  LeftViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LeftViewController.h"
#import "InventoryColumnViewController.h"
#import "ProductColumnViewController.h"

//tableview cell高度为40
#define kTableViewCellHeight 40.f
//tableview header高度
#define kTableViewHeaderViewHeight 30.f
//tableview开始标记序号
#define kTableViewTag 11000

#define kBackgroundColor [UIColor colorWithRed:31/255.0 green:36/255.0 blue:43/255.0 alpha:1]

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat beginOrign = 0;
    CGFloat totalHeight =0;
    //设置tableview，每一个筛选条件就是一个tableview
    for (int i=0; i<self.conditions.count; i++) {
        NSString *key =[[[self.conditions objectAtIndex:i] allKeys] objectAtIndex:0];
        int cellCount = [[[self.conditions objectAtIndex:i] objectForKey:key] count];
        CGFloat tableViewHeight = cellCount*kTableViewCellHeight+kTableViewHeaderViewHeight;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginOrign, self.scrollView.frame.size.width, tableViewHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kBackgroundColor;
        tableView.bounces = NO;
        tableView.tag = kTableViewTag+i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.scrollView addSubview:tableView];
        beginOrign += tableViewHeight;
        totalHeight += tableViewHeight;
    }
    //设置scrollView高度
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    if (totalHeight>self.scrollView.contentSize.height) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, totalHeight);
    }
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableViewHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int index = tableView.tag-kTableViewTag;
    NSString *key = [[[self.conditions objectAtIndex:index] allKeys] objectAtIndex:0];
    return [[[self.conditions objectAtIndex:index] objectForKey:key] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [[[self.conditions objectAtIndex:(tableView.tag-kTableViewTag)] allKeys] objectAtIndex:0];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, kTableViewHeaderViewHeight)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17.f];
    label.text = [[[self.conditions objectAtIndex:(tableView.tag-kTableViewTag)] allKeys] objectAtIndex:0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReportTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    int index = tableView.tag-kTableViewTag;
    NSString *key = [[[self.conditions objectAtIndex:index] allKeys] objectAtIndex:0];
    cell.textLabel.text = [[[self.conditions objectAtIndex:index] objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = kRelativelyColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 125, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:57/255.0 alpha:1].CGColor;
    separatorView.layer.borderWidth = 1.0;
    [cell.contentView addSubview:separatorView];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RightViewController* realTimeReportsRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.sidePanelController.rightPanel = nil;
//    RightViewController* realTimeReportsRightController = (RightViewController *)self.sidePanelController.rightPanel;
    if (indexPath.row==0) {
        NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
        NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
        for (NSDictionary *line in lines) {
            NSString *name = [line objectForKey:@"name"];
            NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
            NSDictionary *dict = @{@"_id":_id,@"name":name};
            [lineArray addObject:dict];
        }
        NSArray *products = [kSharedApp.factory objectForKey:@"products"];
        NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
        for (NSDictionary *product in products) {
            NSString *name = [product objectForKey:@"name"];
            NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
            NSDictionary *dict = @{@"_id":_id,@"name":name};
            [productArray addObject:dict];
        }
        NSArray *timeArray = kCondition_Time_Array;
        ProductColumnViewController *productColumnViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
        realTimeReportsRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
        realTimeReportsRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
        UINavigationController *productColumnVCNav = [[UINavigationController alloc] initWithRootViewController:productColumnViewController];
        [self.sidePanelController setCenterPanel:productColumnVCNav];
        [self.sidePanelController setRightPanel:realTimeReportsRightController];
    }else if (indexPath.row==1){
        InventoryColumnViewController *inventoryColumnViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryColumnViewController"];
        UINavigationController *inventoryColumnVCNav = [[UINavigationController alloc] initWithRootViewController:inventoryColumnViewController];
        NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
        realTimeReportsRightController.conditions = @[@{@"库存类型":stockType}];
        [self.sidePanelController setCenterPanel:inventoryColumnVCNav];
        [self.sidePanelController setRightPanel:realTimeReportsRightController];
    }
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
