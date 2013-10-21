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
#import "DatePickerViewController.h"
#import "ConditionTableView.h"
#import "TimeConditionCell.h"
#import "TimeTableView.h"
#import "LineTableView.h"
#import "ProductTableView.h"
#import "StockTableView.h"
#import "UnitCostTableView.h"

//tableview cell高度为40
#define kTableViewCellHeight 40.f
//tableview header高度为cell高度一半
#define kTableViewHeaderViewHeight 30
//tableview开始标记序号
#define kTableViewTag 10000
//勾选标记大小
#define kImageViewSize 30

@interface RightViewController ()
@property (nonatomic,retain) SearchCondition *searchCondition;
@property (nonatomic,retain) StockTableView *stockTableView;
@property (nonatomic,retain) UnitCostTableView *unitCostTableView;
@property (nonatomic,retain) LineTableView *lineTableView;
@property (nonatomic,retain) ProductTableView *productTableView;
@property (nonatomic,retain) TimeTableView *timeTableView;
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
//    self.view.backgroundColor =[UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    //重新设置scrollView高度
    self.scrollView.frame = CGRectMake(kOrignX, self.scrollView.frame.origin.y, self.scrollView.frame.size.width-kOrignX, self.scrollView.frame.size.height);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self setTableViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return kTableViewCellHeight;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    int index = tableView.tag-kTableViewTag;
//    NSString *key = [[[self.conditions objectAtIndex:index] allKeys] objectAtIndex:0];
//    return [[[self.conditions objectAtIndex:index] objectForKey:key] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"ConditionCell";
//    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
//    }
//    // Configure the cell...
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    int index = tableView.tag-kTableViewTag;
//    NSString *key = [[[self.conditions objectAtIndex:index] allKeys] objectAtIndex:0];
//    cell.label.font = [UIFont systemFontOfSize:14];
//    cell.label.text = [[[[self.conditions objectAtIndex:index] objectForKey:key] objectAtIndex:indexPath.row] objectForKey:@"name"];
//    cell.label.textColor = [UIColor whiteColor];
//    cell.selectedImgView.image = [UIImage imageNamed:@"checked"];
//    cell.selectedImgView.hidden = YES;
//    UILabel *label = (UILabel *)[[tableView.tableHeaderView subviews] objectAtIndex:0];
//    NSString *headerTitle = label.text;
//    if ([kCondition_Time isEqualToString:headerTitle]) {
//        //默认选中本月
//        if (indexPath.row==2) {
//            cell.selectedImgView.hidden = NO;
//            cell.label.font = [UIFont boldSystemFontOfSize:14];
//            cell.label.textColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
//        }
//    }else{
//        if (indexPath.row==0) {
//            cell.selectedImgView.hidden = NO;
//            cell.label.font = [UIFont boldSystemFontOfSize:14];
//            cell.label.textColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
//        }
//    }
//    //设置标识，以便选中时知道选中的是哪个
//    cell.cellID = [[[[[self.conditions objectAtIndex:index] objectForKey:key] objectAtIndex:indexPath.row] objectForKey:@"_id"] longValue];
//    return cell;
//}
//
//#pragma mark - Table view delegate
//int stockType=0,timeType=0,lineID=0,productID=0;
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    for (int i=0; i<[[tableView visibleCells] count]; i++) {
//        ConditionCell *cell = (ConditionCell *)[[tableView visibleCells] objectAtIndex:i];
//        cell.selectedImgView.hidden = YES;
//        cell.label.font = [UIFont systemFontOfSize:14];
//        cell.label.textColor = [UIColor whiteColor];
//    }
//    ConditionCell *cell = (ConditionCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.selectedImgView.hidden = NO;
//    cell.label.font = [UIFont boldSystemFontOfSize:14];
//    cell.label.textColor= [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
//    //修改搜索条件
//    UILabel *label = (UILabel *)[[tableView.tableHeaderView subviews] objectAtIndex:0];
//    NSString *headerTitle = label.text;
//    if ([kCondition_StockType isEqualToString:headerTitle]) {
//        stockType = cell.cellID;
//    }else if ([kCondition_Time isEqualToString:headerTitle]) {
//        timeType = cell.cellID;
//        if (timeType==4) {//选中的是自定义时间
//            DatePickerViewController *datePickerViewController = (DatePickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController"];
//            [self presentModalViewController:datePickerViewController animated:YES];
//        }
//    }else if ([kCondition_Lines isEqualToString:headerTitle]){
//        lineID = cell.cellID;
//        if (lineID==0) {
//            
//        }else{
////            NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
////            NSArray *lineProducts;//产线下面的包含的产品
////            for (NSDictionary *line in lines) {
////                if (lineID==[[line objectForKey:@"id"] longValue]) {
////                    lineProducts = [line objectForKey:@"lineProducts"];
////                }
////            }
////            NSMutableArray *products = [NSMutableArray array];
////            for (NSDictionary *product in lineProducts) {
////                NSString *name = [product objectForKey:@"productname"];
////                NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"productid"] longValue]];
////                NSDictionary *dict = @{@"_id":_id,@"name":name};
////                [products addObject:dict];
////            }
////            NSMutableArray *newConditons = [NSMutableArray arrayWithArray:self.conditions];
////            for (int i=self.conditions.count-1; i>=0; i--) {
////                NSString *conditonTitle = [[[self.conditions objectAtIndex:i] allKeys] objectAtIndex:0];
////                if ([kCondition_Products isEqualToString:conditonTitle]) {
////                    NSDictionary *newProducts = @{kCondition_Products:products};
////                    [newConditons replaceObjectAtIndex:i withObject:newProducts];
////                    break;
////                }
////            }
////            [self resetConditions:newConditons];
//        }
//    }else if ([kCondition_Products isEqualToString:headerTitle]){
//        productID = cell.cellID;
//    }
//}
//
//- (void)viewDidUnload {
//    [self setScrollView:nil];
//    [self setTopView:nil];
//    [super viewDidUnload];
//}
//
//


//- (void)resetConditions:(NSArray *)conditions{
//    self.conditions = conditions;
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//    for (UIView *view in [self.scrollView subviews]) {
//        if ([view isKindOfClass:[UITableView class]]) {
//            [view removeFromSuperview];   
//        }
//    }
//    [self setTableviews];
//}
//
//-(void)setTableViews{
//    CGFloat beginOrign = self.topView.frame.size.height;
//    CGFloat totalHeight = self.topView.frame.size.height;
//    //设置tableview，每一个筛选条件就是一个tableview
//    for (int i=0; i<self.conditions.count; i++) {
//        NSString *key =[[[self.conditions objectAtIndex:i] allKeys] objectAtIndex:0];
//        int cellCount = [[[self.conditions objectAtIndex:i] objectForKey:key] count];
//        CGFloat tableViewHeight = cellCount*kTableViewCellHeight+kTableViewHeaderViewHeight;
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginOrign, self.scrollView.frame.size.width, tableViewHeight) style:UITableViewStylePlain];
//        tableView.bounces = NO;
//        tableView.tag = kTableViewTag+i;
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
//        tableView.separatorColor = [UIColor colorWithPatternImage:self.separatorImage];
//        //        tableView.highlightedBackgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
//        //        tableView.highlightedSeparatorColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
//        //        //设置tableview样式
//        //        tableView.layer.cornerRadius = 4;
//        //        tableView.layer.shadowColor = [UIColor blackColor].CGColor;
//        //        tableView.layer.shadowOffset = CGSizeMake(0, 1);
//        //        tableView.layer.shadowOpacity = 1;
//        //        tableView.imageOffset = CGSizeMake(5, -1);
//        
//        //table的headerview，用于放置条件说明
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kTableViewHeaderViewHeight)];
//        view.backgroundColor = self.view.backgroundColor =[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, kTableViewHeaderViewHeight)];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:13.f];
//        label.text = [[[self.conditions objectAtIndex:(tableView.tag-kTableViewTag)] allKeys] objectAtIndex:0];
//        label.backgroundColor = [UIColor clearColor];
//        [view addSubview:label];
//        tableView.tableHeaderView = view;
//        
//        [self.scrollView addSubview:tableView];
//        beginOrign += tableViewHeight;
//        totalHeight += tableViewHeight;
//    }
//    if (totalHeight>self.scrollView.contentSize.height) {
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, totalHeight);
//    }
//}
//
//- (IBAction)search:(id)sender {
////    self.searchCondition = [[SearchCondition alloc] initWithInventoryType:stockType timeType:timeType lineID:lineID productID:productID];
//    [self.sidePanelController showCenterPanelAnimated:YES];
//}
//
//#pragma mark风格线样式
//- (UIImage *)separatorImage
//{
//    UIGraphicsBeginImageContext(CGSizeMake(1, 4));
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, 1, 2));
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:79/255.0 green:79/255.0 blue:77/255.0 alpha:1].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 3, 1, 2));
//    UIGraphicsPopContext();
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return [UIImage imageWithCGImage:outputImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
//}



//int cellCount = [[[self.conditions objectAtIndex:i] objectForKey:key] count];
//        CGFloat tableViewHeight = cellCount*kTableViewCellHeight+kTableViewHeaderViewHeight;
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginOrign, self.scrollView.frame.size.width, tableViewHeight) style:UITableViewStylePlain];
//        tableView.bounces = NO;
//        tableView.tag = kTableViewTag+i;
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
//        tableView.separatorColor = [UIColor colorWithPatternImage:self.separatorImage];

- (void)resetConditions:(NSArray *)conditions{
    self.conditions = conditions;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    for (UIView *view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
        }
    }
    [self setTableViews];
}

-(void)setTableViews{
    CGFloat beginOrign = self.topView.frame.size.height;
    CGFloat totalHeight = self.topView.frame.size.height;
    UITableView *tableView;
    //设置tableview，每一个筛选条件就是一个tableview
    for (int i=0; i<self.conditions.count; i++) {
        NSDictionary *condition = [self.conditions objectAtIndex:i];
        NSString *conditionTitle = [[condition allKeys] objectAtIndex:0];
        if ([kCondition_StockType isEqualToString:conditionTitle]) {
            tableView = [[StockTableView alloc] initWithCondition:[condition objectForKey:conditionTitle] andCurrentSelectCellIndex:[self.currentSelectDict objectForKey:conditionTitle]];
            self.stockTableView = tableView;
        }else if ([kCondition_UnitCostType isEqualToString:conditionTitle]) {
            tableView = [[UnitCostTableView alloc] initWithCondition:[condition objectForKey:conditionTitle] andCurrentSelectCellIndex:[self.currentSelectDict objectForKey:conditionTitle]];
            self.unitCostTableView = tableView;
        }else if ([kCondition_Time isEqualToString:conditionTitle]) {
//            NSLog(@".... index is %d",[[self.currentSelectDict objectForKey:conditionTitle] intValue]);
            tableView = [[TimeTableView alloc] initWithCondition:[condition objectForKey:conditionTitle] andCurrentSelectCellIndex:[[self.currentSelectDict objectForKey:conditionTitle] intValue]];
            self.timeTableView = tableView;
        }else if ([kCondition_Lines isEqualToString:conditionTitle]) {
            tableView = [[LineTableView alloc] initWithCondition:[condition objectForKey:conditionTitle] andCurrentSelectCellIndex:[self.currentSelectDict objectForKey:conditionTitle]];
            self.lineTableView = tableView;
        }else if ([kCondition_Products isEqualToString:conditionTitle]) {
            tableView = [[ProductTableView alloc] initWithCondition:[condition objectForKey:conditionTitle] andCurrentSelectCellIndex:[self.currentSelectDict objectForKey:conditionTitle]];
            self.productTableView = tableView;
        }
        //table的headerview，用于放置条件说明
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kTableViewHeaderViewHeight)];
        view.backgroundColor = self.view.backgroundColor =[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, kTableViewHeaderViewHeight)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13.f];
        label.text = conditionTitle;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        tableView.tableHeaderView = view;
        //设置tableview大小
        CGFloat tableViewHeight = [[condition objectForKey:conditionTitle] count]*kTableViewCellHeight+kTableViewHeaderViewHeight;
        tableView.frame = CGRectMake(0, beginOrign, self.scrollView.frame.size.width, tableViewHeight);
        beginOrign+=tableViewHeight;
        totalHeight+=tableViewHeight;
        tableView.bounces=NO;
        [self.scrollView addSubview:tableView];
    }
    if (totalHeight>self.scrollView.contentSize.height) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, totalHeight);
    }
}

- (IBAction)search:(id)sender {
    NSIndexPath *stockSelectedIndexPath = [self.stockTableView indexPathForSelectedRow];
    ConditionCell *stockCell  = [self.stockTableView cellForRowAtIndexPath:stockSelectedIndexPath];
    
    NSIndexPath *unitCostSelectedIndexPath = [self.unitCostTableView indexPathForSelectedRow];
    ConditionCell *unitCostCell  = [self.unitCostTableView cellForRowAtIndexPath:unitCostSelectedIndexPath];
    
    NSIndexPath *lineSelectedIndexPath = [self.lineTableView indexPathForSelectedRow];
    ConditionCell *lineCell  = [self.lineTableView cellForRowAtIndexPath:lineSelectedIndexPath];
    
    NSIndexPath *productSelectedIndexPath = [self.productTableView indexPathForSelectedRow];
    ConditionCell *productCell  = [self.productTableView cellForRowAtIndexPath:productSelectedIndexPath];
    
    NSIndexPath *timeSelectedIndexPath = [self.timeTableView indexPathForSelectedRow];
    TimeConditionCell *timeCell  = [self.timeTableView cellForRowAtIndexPath:timeSelectedIndexPath];

    self.searchCondition = [[SearchCondition alloc] initWithInventoryType:stockCell.cellID timeType:timeCell.cellID lineID:lineCell.cellID productID:productCell.cellID unitCostType:unitCostCell.cellID];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

//-(void)setCurrentSelectDict:(NSDictionary *)currentSelectDict{
//    if (currentSelectDict) {
//        self.currentSelectDict = currentSelectDict;
//    }else{
//        self.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    }
//}//{:2,kCondition_Lines:0,kCondition_Products:0,kCondition_StockType:0,kCondition_UnitCostType:0}
@end
