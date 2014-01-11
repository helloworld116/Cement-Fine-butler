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

@interface LossOverViewVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) TitleView *titleView;
@property (strong, nonatomic) NSString *timeDesc;

//view
@property (nonatomic,retain) LossHeaderView *headerView;
@property (nonatomic,retain) UITableView *tableView;

//data
@property (nonatomic,retain) NSDictionary *overview;
@property (nonatomic,retain) NSArray *rawMaterials;
@property (nonatomic,retain) NSArray *semifinishedProduct;
@property (nonatomic,retain) NSArray *endProduct;
@property (nonatomic,retain) NSArray *logistics;
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
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"损耗总览";
    self.navigationItem.titleView = self.titleView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search_click"] target:self action:@selector(showSearch:)];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:1];
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    CGRect tableViewFrame = CGRectMake(0, self.headerView.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.headerView.frame.size.height-kTabBarHeight);
    self.tableView.frame = tableViewFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
    self.rightVC.currentSelectDict = @{kCondition_Time:@2};
    self.URL = kLoss;
    [self sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableviewdatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172.f;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
    switch (indexPath.row) {
        case 0:
            loss = [Tool doubleValue:[self.overview objectForKey:@"logisticsLoss"]];
            cell.lblLossType.text = @"物流损耗";
            cell.lblSide.text = @"供应方";
            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
            cell.imgViewCarOr.image = [UIImage imageNamed:@"car_icon"];
            break;
        case 1:
            loss = [Tool doubleValue:[self.overview objectForKey:@"rawMaterialsLoss"]];
            cell.lblLossType.text = @"原材料损耗";
            cell.lblSide.text = @"原材料仓";
            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
            break;
        case 2:
            loss = [Tool doubleValue:[self.overview objectForKey:@"semifinishedProductLoss"]];
            cell.lblLossType.text = @"半成品损耗";
            cell.lblSide.text = @"半成品仓";
            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
            break;
        case 3:
            loss = [Tool doubleValue:[self.overview objectForKey:@"endProductLoss"]];
            cell.lblLossType.text = @"成品损耗";
            cell.lblSide.text = @"成品仓";
            cell.imgViewPostion.image = [UIImage imageNamed:@"warehouse_icon"];
            break;
    }
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
    LossReportViewController *nextVC = [[LossReportViewController alloc] init];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.dateDesc = self.timeDesc;
    nextVC.data = self.data;
    nextVC.type = indexPath.row;
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    self.overview = [self.data objectForKey:@"overview"];
    if (self.overview&&[Tool doubleValue:[self.overview objectForKey:@"totalLoss"]]!=0) {
        self.tableView.hidden = NO;
        self.headerView.hidden = NO;
        double totalLoss = [Tool doubleValue:[self.overview objectForKey:@"totalLoss"]];
        [self.tableView reloadData];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.##"];
        NSString *lossStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalLoss]];
        self.headerView.lblTotalLoss.text = [lossStr stringByAppendingString:@"吨"];
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
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.timeDesc = [timeInfo objectForKey:@"timeDesc"];
    self.titleView.lblTimeInfo.text = [timeInfo objectForKey:@"timeDesc"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
}

-(void)clear{
    self.headerView.hidden = YES;
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
