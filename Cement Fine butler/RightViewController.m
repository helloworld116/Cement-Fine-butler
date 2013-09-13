//
//  RightViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

//tag 从10000开始
#import "RightViewController.h"
#import "ConditionCell.h"

//tableview cell高度为40
#define kTableViewCellHeight 40.f
//tableview header高度为cell高度一半
#define kTableViewHeaderViewHeight kTableViewCellHeight/2
//tableview开始标记序号
#define kTableViewTag 10000
//勾选标记大小
#define kImageViewSize 30

@interface RightViewController ()

@end

@implementation RightViewController

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
    CGFloat beginOrign = self.topView.frame.size.height;
    CGFloat totalHeight = self.topView.frame.size.height;
    //设置tableview，每一个筛选条件就是一个tableview
    for (int i=0; i<self.conditions.count; i++) {
        NSString *key =[[[self.conditions objectAtIndex:i] allKeys] objectAtIndex:0];
        int cellCount = [[[self.conditions objectAtIndex:i] objectForKey:key] count];
        CGFloat tableViewHeight = cellCount*kTableViewCellHeight+kTableViewHeaderViewHeight;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginOrign, self.scrollView.frame.size.width, tableViewHeight) style:UITableViewStylePlain];
        tableView.bounces = NO;
        tableView.tag = kTableViewTag+i;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
        beginOrign += tableViewHeight;
        totalHeight += tableViewHeight;
    }
    //设置scrollView高度
    self.scrollView.frame = CGRectMake(kOrignX, self.scrollView.frame.origin.y, self.scrollView.frame.size.width-kOrignX, self.scrollView.frame.size.height);
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.conditions objectAtIndex:(tableView.tag-kTableViewTag)] allKeys] objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConditionCell";
    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int index = tableView.tag-kTableViewTag;
    NSString *key = [[[self.conditions objectAtIndex:index] allKeys] objectAtIndex:0];
    cell.label.text = [[[self.conditions objectAtIndex:index] objectForKey:key] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"right"];
    cell.imageView.hidden = YES;
    if (indexPath.row==0) {
        cell.imageView.hidden = NO;
    }
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
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        ConditionCell *cell = (ConditionCell *)[[tableView visibleCells] objectAtIndex:i];
        cell.imageView.hidden = YES;
    }
    ConditionCell *cell = (ConditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = NO;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTopView:nil];
    [super viewDidUnload];
}
@end
