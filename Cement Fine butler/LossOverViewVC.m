//
//  LossOverViewVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossOverViewVC.h"
#import "LossDescCell.h"
#import "LossHeaderView.h"
#import "LossReportViewController.h"
#import "DropDownView.h"

#define kLossImageDict @{@"logistics":@"supplyside_icon",@"yard":@"materials_icon",@"product":@"cement_icon",@"rawmaterial":@"rawmaterial_icon",@"clinker":@"clinker_icon"}

@interface LossOverViewVC ()<UITableViewDataSource,UITableViewDelegate,DropDownViewDeletegate>
@property (strong, nonatomic) TitleView *titleView;
@property (strong, nonatomic) NSString *timeDesc;

//view
@property (nonatomic,retain) LossHeaderView *headerView;
@property (nonatomic,retain) UITableView *tableView;

//data
@property (nonatomic) double totalLoss;
@property (nonatomic,strong) NSArray *sortLossData;
@property (nonatomic,strong) DropDownView *dropDownView;
@end

@implementation LossOverViewVC

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
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.title = @"损耗总览";
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search_click"] target:self action:@selector(showSearch:)];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:1];
    [self.view addSubview:self.headerView];
    [self.headerView.btnChangeDate addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    CGRect tableViewFrame = CGRectMake(0, self.headerView.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.headerView.frame.size.height-kTabBarHeight);
    self.tableView.frame = tableViewFrame;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
//    self.rightVC.currentSelectDict = @{kCondition_Time:@2};
    self.URL = kLoss;
    [self sendRequest];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if (self.totalLoss) {
//        [self.headerView.lblTotalLoss startFrom:0 end:self.totalLoss];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeDate:(id)sender {
    if (self.dropDownView) {
        [self.dropDownView hideDropDown:sender];
        self.dropDownView = nil;
    }else{
        self.dropDownView = [[DropDownView alloc] initWithDropDown:sender height:120.f list:@[@"今天",@"昨天",@"本月",@"本年"]];
        self.dropDownView.delegate = self;
    }
    //旋转代码
    CGAffineTransform transform = self.headerView.imgViewPullDown.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.headerView.imgViewPullDown.transform = transform;
}

-(void)dropDownDelegateMethod:(DropDownView *)sender{
    CGAffineTransform transform = self.headerView.imgViewPullDown.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.headerView.imgViewPullDown.transform = transform;
    self.timeType = sender.timeType;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self sendRequest];
    });
    self.dropDownView = nil;
}

#pragma mark tableviewdatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172.f;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortLossData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LossDescCellIdentifier = @"LossDescCell";
    LossDescCell *cell = [tableView dequeueReusableCellWithIdentifier:LossDescCellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    double loss=0;
//    switch (indexPath.row) {
//        case 0:
//            loss = [Tool doubleValue:[self.overview objectForKey:@"logisticsLoss"]];
//            cell.lblLossType.text = @"物流损耗";
//            cell.lblSide.text = @"供应方";
//            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
//            cell.imgViewCarOr.image = [UIImage imageNamed:@"car_icon"];
//            break;
//        case 1:
//            loss = [Tool doubleValue:[self.overview objectForKey:@"rawMaterialsLoss"]];
//            cell.lblLossType.text = @"原材料损耗";
//            cell.lblSide.text = @"原材料仓";
//            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
//            break;
//        case 2:
//            loss = [Tool doubleValue:[self.overview objectForKey:@"semifinishedProductLoss"]];
//            cell.lblLossType.text = @"半成品损耗";
//            cell.lblSide.text = @"半成品仓";
//            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
//            break;
//        case 3:
//            loss = [Tool doubleValue:[self.overview objectForKey:@"endProductLoss"]];
//            cell.lblLossType.text = @"成品损耗";
//            cell.lblSide.text = @"成品仓";
//            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
//            break;
//    }
    //新接口
    NSDictionary *lossData = [self.sortLossData objectAtIndex:indexPath.row];
    if ([[lossData objectForKey:@"type"] isEqualToString:@"logistics"]) {
        cell.imgViewCarOr.image = [UIImage imageNamed:@"car_icon"];
    }
    cell.imgViewPostion.image = [UIImage imageNamed:[kLossImageDict objectForKey:[lossData objectForKey:@"type"]]];
    loss = [Tool doubleValue:[lossData objectForKey:@"totalLoss"]];
    cell.lblLossType.text = [Tool stringToString:[lossData objectForKey:@"aliaName"]];
    cell.lblSide.text = [Tool stringToString:[lossData objectForKey:@"typeName"]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSString *lossStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:loss]];
    CGSize valueSize = [lossStr sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect lblLossAmountFrame = cell.lblLossAmount.frame;
    lblLossAmountFrame.size.width = valueSize.width;
    cell.lblLossAmount.frame = lblLossAmountFrame;
    cell.lblLossAmount.text = lossStr;
    
    CGRect unitFrame = cell.lblLossUnit.frame;
    unitFrame.origin.x = lblLossAmountFrame.origin.x+lblLossAmountFrame.size.width+5;
    cell.lblLossUnit.frame = unitFrame;
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LossReportViewController *nextVC = [[LossReportViewController alloc] init];
//    nextVC.hidesBottomBarWhenPushed = YES;
//    nextVC.dateDesc = self.timeDesc;
//    nextVC.data = self.data;
//    nextVC.type = indexPath.row;
//    [self.navigationController pushViewController:nextVC animated:YES];
    
    //新接口
    LossReportViewController *nextVC = [[LossReportViewController alloc] init];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.data = [self.sortLossData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    NSArray *lossData = [self.data objectForKey:@"lossData"];
    if (overview&&lossData) {
        self.totalLoss = [Tool doubleValue:[overview objectForKey:@"totalLoss"]];
//        NSString *lossStr = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:self.totalLoss]];
        [self.headerView.lblTotalLoss startFrom:0 end:self.totalLoss];
        if ([lossData count]) {
           self.tableView.hidden = NO;
            //对损失过程数据排序，以便按正确流程显示损失过程
            self.sortLossData = [lossData sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int first = [Tool intValue:[(NSDictionary *)a objectForKey:@"order"]];
                int second = [Tool intValue:[(NSDictionary *)b objectForKey:@"order"]];
                return first-second;
            }];
            [self.tableView reloadData];
        }
    }else{
        self.messageView.hidden = NO;
        self.messageView.labelMsg.text = @"没有满足条件的数据！！！";
        self.messageView.center = self.view.center;
    }
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
//    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
//    self.timeDesc = [timeInfo objectForKey:@"timeDesc"];
//    self.titleView.lblTimeInfo.text = [timeInfo objectForKey:@"timeDesc"];
//    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
//    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    //新接口
    [super setRequestParams];
}

-(void)clear{
    self.tableView.hidden = YES;
}

#pragma mark
-(void)showSearch:(id)sender{
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 查询条件发生更改
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        self.condition = [change objectForKey:@"new"];
        [self sendRequest];
    }
}
@end
