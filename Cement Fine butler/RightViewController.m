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
#import "SearchCondition.h"

//tableview cell高度为40
#define kTableViewCellHeight 30.f
//tableview header高度为cell高度一半
#define kTableViewHeaderViewHeight kTableViewCellHeight/2
//tableview开始标记序号
#define kTableViewTag 10000
//勾选标记大小
#define kImageViewSize 30

@interface RightViewController ()
@property (nonatomic,retain) SearchCondition *searchCondition;
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
    self.view.backgroundColor =[UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    
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
        tableView.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
        tableView.separatorColor = [UIColor colorWithPatternImage:self.separatorImage];
//        tableView.highlightedBackgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
//        tableView.highlightedSeparatorColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
//        //设置tableview样式
//        tableView.layer.cornerRadius = 4;
//        tableView.layer.shadowColor = [UIColor blackColor].CGColor;
//        tableView.layer.shadowOffset = CGSizeMake(0, 1);
//        tableView.layer.shadowOpacity = 1;
//        tableView.imageOffset = CGSizeMake(5, -1);
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
    //初始化搜索条件
    self.searchCondition = [[SearchCondition alloc] init];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kTableViewHeaderViewHeight)];
    view.backgroundColor = self.view.backgroundColor =[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, kTableViewHeaderViewHeight)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [[[self.conditions objectAtIndex:(tableView.tag-kTableViewTag)] allKeys] objectAtIndex:0];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    return view;
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
    cell.label.font = [UIFont systemFontOfSize:14];
    cell.label.text = [[[self.conditions objectAtIndex:index] objectForKey:key] objectAtIndex:indexPath.row];
    cell.label.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"right"];
    cell.imageView.hidden = YES;
    if (indexPath.row==0) {
        cell.imageView.hidden = NO;
    }
    //设置标识，以便选中时知道选中的是哪个
    cell.cellID = indexPath.row;
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
int inventoryType=0,timeType=0,lineID=0,productID=0;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        ConditionCell *cell = (ConditionCell *)[[tableView visibleCells] objectAtIndex:i];
        cell.imageView.hidden = YES;
    }
    ConditionCell *cell = (ConditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = NO;
    //修改搜索条件
    UITableViewHeaderFooterView *header = [tableView headerViewForSection:0];
    NSString *headerTitle = header.textLabel.text;
    if ([kCondition_InventoryType isEqualToString:headerTitle]) {
        inventoryType = cell.cellID;
    }else if ([kCondition_Time isEqualToString:headerTitle]) {
        timeType = cell.cellID;
    }else if ([kCondition_Lines isEqualToString:headerTitle]){
        lineID = cell.cellID;
    }else if ([kCondition_Products isEqualToString:headerTitle]){
        productID = cell.cellID;
    }
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTopView:nil];
    [super viewDidUnload];
}
- (IBAction)search:(id)sender {    
//    for (UIView *view in self.scrollView.subviews) {
//        if ([view isKindOfClass:[UITableView class]]) {
//            UITableView *tableView = (UITableView *)view;
//                    }
//    }
    self.searchCondition = [[SearchCondition alloc] initWithInventoryType:inventoryType timeType:timeType lineID:lineID productID:productID];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

#pragma mark Setting style

- (UIImage *)separatorImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 4));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 2));
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:79/255.0 green:79/255.0 blue:77/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, 3, 1, 2));
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:outputImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
}
@end
