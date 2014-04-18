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

//加载次数
@property (nonatomic) int loadTimes;
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
    self.headerView.hidden = YES;
    [self.headerView.btnChangeDate addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
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
    self.loadTimes=0;
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
    if (indexPath.row==0) {
        return 172.f;
    }
    return 344.f;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortLossData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LossDescCellIdentifier = @"LossDescCell";
    static NSString *LossDescCellIdentifier2 = @"LossDescCell2";
    LossDescCell *cell;
    if (indexPath.row==0) {
       cell = [tableView dequeueReusableCellWithIdentifier:LossDescCellIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:LossDescCellIdentifier2];
    }
    // Configure the cell...
    if (!cell) {
        if (indexPath.row==0) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:0];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LossCell" owner:self options:nil] objectAtIndex:2];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    double loss=0;
    //新接口
    NSDictionary *lossData = [self.sortLossData objectAtIndex:indexPath.row];
    NSString *type = [lossData objectForKey:@"type"];
    cell.imgViewPostion.image = [UIImage imageNamed:[kLossImageDict objectForKey:type]];
    loss = [Tool doubleValue:[lossData objectForKey:@"totalLoss"]];
    cell.lblLossType.text = [Tool stringToString:[lossData objectForKey:@"aliaName"]];
    cell.lblSide.text = [Tool stringToString:[lossData objectForKey:@"typeName"]];
    
    NSString *lossStr = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:loss]];
    cell.lblLossAmount.text = lossStr;
    if (indexPath.row!=0) {
        LossDescCell2 *cell2 = (LossDescCell2 *)cell;
        if ([type isEqualToString:@"yard"]) {
            cell2.imgViewPostion2.image = [UIImage imageNamed:@"mill_icon"];
            cell2.lblLossType2.text = @"磨机";
        }else if([type isEqualToString:@"product"]){
            cell2.imgViewPostion2.image = [UIImage imageNamed:@"packaging_icon"];
            cell2.lblLossType2.text = @"包装机、散装机";
        }else if([type isEqualToString:@"rawmaterial"]){
            cell2.imgViewPostion2.image = [UIImage imageNamed:@"kiln_icon"];;
            cell2.lblLossType2.text = @"回转窑";
        }else if([type isEqualToString:@"clinker"]){
            cell2.imgViewPostion2.image = [UIImage imageNamed:@"mill_icon"];
            cell2.lblLossType2.text = @"磨机";
        }
    }
    if ([self.sortLossData count]-1==indexPath.row) {
        CGRect frame = cell.lblArrow.frame;
        frame.size.height +=48;
        cell.lblArrow.frame = frame;
        cell.imgViewArrow.hidden = YES;
        cell.lblLine.hidden = YES;
    }
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
        if (self.loadTimes==0) {
            self.headerView.hidden = NO;
        }
        self.loadTimes++;
        self.totalLoss = [Tool doubleValue:[overview objectForKey:@"totalLoss"]];
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
    [super setRequestParams];
}

-(void)clear{
    [self.headerView.lblTotalLoss startFrom:0 end:0];
    self.tableView.hidden = YES;
}

#pragma mark
-(void)showSearch:(id)sender{
//    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 查询条件发生更改
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        self.condition = [change objectForKey:@"new"];
        [self sendRequest];
    }
}
@end
