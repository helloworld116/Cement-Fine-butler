//
//  LossOverViewVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossOverViewVC.h"
#import "LossDescCell.h"
#import "LossPlaceCell.h"
#import "LossReportViewController.h"

@interface LossOverViewVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) TitleView *titleView;
@property (strong, nonatomic) NSString *timeDesc;

@property (nonatomic,retain) UILabel *lblTotalLossAmount;
@property (nonatomic,retain) UITableView *tableView;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
    CGRect topViewFrame = CGRectMake(0, 0, kScreenWidth, 60);
    UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
    topView.backgroundColor = [UIColor lightGrayColor];
    self.lblTotalLossAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblTotalLossAmount.backgroundColor = [UIColor clearColor];
    self.lblTotalLossAmount.textAlignment = UITextAlignmentCenter;
    CGRect lblFrame = self.lblTotalLossAmount.frame;
    lblFrame.size = CGSizeMake(300, 40);
    self.lblTotalLossAmount.frame = lblFrame;
    self.lblTotalLossAmount.center = topView.center;
    [topView addSubview:self.lblTotalLossAmount];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    CGRect tableViewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.tableView.frame = tableViewFrame;
    self.tableView.tableHeaderView = topView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2"]];
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
    if (indexPath.row%2==0) {
        return 80.f;
    }else{
        return 120.f;
    }
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        static NSString *LossPlaceCellIdentifier = @"LossPlaceCell";
        LossPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:LossPlaceCellIdentifier];
        // Configure the cell...
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row/2) {
            case 0:
                cell.imgViewPlace.image = [UIImage imageNamed:@"warehouse"];
                cell.lblPlace.text = @"供应方";
                break;
            case 1:
                cell.imgViewPlace.image = [UIImage imageNamed:@"warehouse"];
                cell.lblPlace.text = @"原材料仓";
                break;
            case 2:
                cell.imgViewPlace.image = [UIImage imageNamed:@"warehouse"];
                cell.lblPlace.text = @"半成品仓";
                break;
            case 3:
                cell.imgViewPlace.image = [UIImage imageNamed:@"warehouse"];
                cell.lblPlace.text = @"成品仓";
                break;
        }
        return cell;
    }else{
        static NSString *LossDescCellIdentifier = @"LossDescCell";
        LossDescCell *cell = [tableView dequeueReusableCellWithIdentifier:LossDescCellIdentifier];
        // Configure the cell...
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgViewArrow.image = [UIImage imageNamed:@"arrow-down"];
        cell.imgViewBubble.image= [[UIImage imageNamed:@"bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(42,30,38,25)];//42,28,38,28
        cell.imgViewMiddle.image = [UIImage imageNamed:@"trunk"];
        switch (indexPath.row) {
            case 1:{
                    double logisticsLoss = [Tool doubleValue:[self.overview objectForKey:@"logisticsLoss"]];
                    cell.lblLossAmount.text = [NSString stringWithFormat:@"损耗%@吨",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:logisticsLoss]]];
                    cell.lblLossType.text = @"物流损耗";
                }
                break;
            case 3:{
                    double rawMaterialsLoss = [Tool doubleValue:[self.overview objectForKey:@"rawMaterialsLoss"]];
                    cell.lblLossAmount.text = [NSString stringWithFormat:@"损耗%@吨",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:rawMaterialsLoss]]];
                    cell.lblLossType.text = @"原材料损耗";
                }
                break;
            case 5:{
                    double semifinishedProductLoss = [Tool doubleValue:[self.overview objectForKey:@"semifinishedProductLoss"]];
                    cell.lblLossAmount.text = [NSString stringWithFormat:@"损耗%@吨",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:semifinishedProductLoss]]];
                    cell.lblLossType.text = @"半成品损耗";
                }
                break;
            case 7:{
                    double endProductLoss = [Tool doubleValue:[self.overview objectForKey:@"endProductLoss"]];
                    cell.lblLossAmount.text = [NSString stringWithFormat:@"损耗%@吨",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:endProductLoss]]];
                    cell.lblLossType.text = @"成品损耗";
                }
                break;
        }
        return cell;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2!=0) {
        LossReportViewController *nextVC = [[LossReportViewController alloc] init];
        nextVC.hidesBottomBarWhenPushed = YES;
        nextVC.dateDesc = self.timeDesc;
        nextVC.data = self.data;
        switch (indexPath.row) {
            case 1:
                if ([Tool doubleValue:[self.overview objectForKey:@"logisticsLoss"]]!=0) {
//                    nextVC.title = @"物流损耗";
//                    nextVC.dataArray = self.logistics;
                    nextVC.type = 0;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                break;
            case 3:
                if ([Tool doubleValue:[self.overview objectForKey:@"rawMaterialsLoss"]]!=0) {
//                    nextVC.title = @"原材料损耗";
//                    nextVC.dataArray = self.rawMaterials;
                    nextVC.type = 1;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                break;
            case 5:
                if ([Tool doubleValue:[self.overview objectForKey:@"semifinishedProductLoss"]]!=0) {
//                    nextVC.title = @"半成品损耗";
//                    nextVC.dataArray = self.semifinishedProduct;
                    nextVC.type = 2;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                break;
            case 7:
                if ([Tool doubleValue:[self.overview objectForKey:@"endProductLoss"]]!=0) {
//                    nextVC.title = @"成品损耗";
//                    nextVC.dataArray = self.endProduct;
                    nextVC.type = 3;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                break;
        }
    }
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    self.overview = [self.data objectForKey:@"overview"];
    if (self.overview&&[Tool doubleValue:[self.overview objectForKey:@"totalLoss"]]!=0) {
        double totalLoss = [Tool doubleValue:[self.overview objectForKey:@"totalLoss"]];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.lblTotalLossAmount.text = [NSString stringWithFormat:@"总损耗%@吨",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:totalLoss]]];
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
