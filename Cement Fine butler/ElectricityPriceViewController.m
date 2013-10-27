//
//  ElectricityPriceViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-25.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectricityPriceViewController.h"
#import "ElectricityCell.h"
#import "ElectrcityOperateViewController.h"

@interface ElectricityPriceViewController ()<SWTableViewCellDelegate>
@property (retain,nonatomic) NSMutableArray *list;
@end

@implementation ElectricityPriceViewController

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
    self.title = @"电力价格";
    self.tableView.rowHeight = 60.f;
    self.list = [@[@{@"id":@1,@"date":@"2013-09-22",@"value":@1.1f},@{@"id":@2,@"date":@"2013-09-23",@"value":@1.2f},@{@"id":@3,@"date":@"2013-09-24",@"value":@1.3f},@{@"id":@4,@"date":@"2013-09-25",@"value":@1.4f},@{@"id":@5,@"date":@"2013-09-26",@"value":@1.5f},@{@"id":@6,@"date":@"2013-09-27",@"value":@1.6f},@{@"id":@7,@"date":@"2013-09-28",@"value":@1.7f}] mutableCopy];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"ElectricityCell";
//    ElectricityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.delegate = self;
//    NSDictionary *data = self.list[indexPath.row];
//    cell.CellID = [[data objectForKey:@"id"] longValue];
//    cell.lblElectricityPrice = [data objectForKey:@"value"];
//    cell.lblDate = [data objectForKey:@"date"];
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ElectricityCell";
    ElectricityCell *cell = (ElectricityCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"修改"];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:251./255. green:34./255. blue:38./255. alpha:1.] title:@"删除"];
        cell = [[ElectricityCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:self.tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    NSDictionary *data = self.list[indexPath.row];
    cell.CellID = [[data objectForKey:@"id"] longValue];
    cell.lblElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[data objectForKey:@"value"] floatValue]];
    cell.lblDate.text = [data objectForKey:@"date"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat viewHeight = 21.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.66f;
    
    UILabel *lblElectricityPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, viewHeight)];
    lblElectricityPrice.backgroundColor = [UIColor clearColor];
    lblElectricityPrice.textAlignment = UITextAlignmentCenter;
    lblElectricityPrice.font = [UIFont systemFontOfSize:12.f];
    lblElectricityPrice.textColor = [UIColor whiteColor];
    lblElectricityPrice.text = @"电力价格	";
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, viewHeight)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textAlignment = UITextAlignmentCenter;
    lblDate.font = [UIFont systemFontOfSize:12.f];
    lblDate.textColor = [UIColor whiteColor];
    lblDate.text = @"时间";
    
    [view addSubview:lblElectricityPrice];
    [view addSubview:lblDate];
    
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

ElectricityCell *currentOperateCell;
- (void)swippableTableViewCell:(ElectricityCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
            nextViewController.electricityInfo = [self.list objectAtIndex:index];
            [self.navigationController pushViewController:nextViewController animated:YES];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            currentOperateCell = cell;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定删除该条记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    switch (buttonIndex) {
        case 0:
//            [currentOperateCell hideUtilityButtonsAnimated:YES];
            currentOperateCell=nil;
            break;
        case 1:{
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:currentOperateCell];
                [self.list removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                currentOperateCell = nil;
            }
            break;
        default:
            break;
    }
}

-(void)add:(id)sender{
    ElectrcityOperateViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"electrcityOperateViewController"];
    [self.navigationController pushViewController:nextViewController animated:YES];
}
//#pragma mark * DAContextMenuCell delegate
//- (void)contextMenuCellDidSelectDeleteOption:(ElectricityCell *)cell
//{
//    [super contextMenuCellDidSelectDeleteOption:cell];
//    [self.list removeObjectAtIndex:[self.tableView indexPathForCell:cell].row];
//    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
////    self.tableView insertRowsAtIndexPaths:(NSArray *) withRowAnimation:(UITableViewRowAnimation)
//}
//
//- (void)contextMenuCellDidSelectMoreOption:(ElectricityCell *)cell
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"Cancel"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"Reply", @"Forward", @"Flag", @"Mark as Unread", @"Move to Junk", @"Move Message...",  nil];
//    [actionSheet showInView:self.view];
//}

@end
