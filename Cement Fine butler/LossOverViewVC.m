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

@interface LossOverViewVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UIView *viewTop;
@property (nonatomic,retain) UITableView *tableView;
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
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:scrollView];
//    
//    CGRect topViewFrame = CGRectMake(0, 0, kScreenWidth, 60);
//    self.viewTop = [[UIView alloc] initWithFrame:topViewFrame];
//    UILabel *lblTotalLossAmount = [[UILabel alloc] initWithFrame:CGRectZero];
//    CGRect lblFrame = lblTotalLossAmount.frame;
//    lblFrame.size = CGSizeMake(300, 40);
//    lblTotalLossAmount.frame = lblFrame;
//    lblTotalLossAmount.center = self.viewTop.center;
//    [self.viewTop addSubview:lblTotalLossAmount];
//    [scrollView addSubview:self.viewTop];
//    
//    CGRect tableViewFrame = CGRectMake(0, topViewFrame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight-topViewFrame.size.height);
//    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [scrollView addSubview:self.tableView];
    
    
    CGRect topViewFrame = CGRectMake(0, 0, kScreenWidth, 60);
    UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
    topView.backgroundColor = [UIColor lightGrayColor];
    UILabel *lblTotalLossAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    lblTotalLossAmount.backgroundColor = [UIColor clearColor];
    lblTotalLossAmount.textAlignment = UITextAlignmentCenter;
    CGRect lblFrame = lblTotalLossAmount.frame;
    lblFrame.size = CGSizeMake(300, 40);
    lblTotalLossAmount.text = @"总损耗2400吨";
    lblTotalLossAmount.frame = lblFrame;
    lblTotalLossAmount.center = topView.center;
    [topView addSubview:lblTotalLossAmount];
    self.tableView.tableHeaderView = topView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2"]];
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
        cell.imgViewBubble.image= [UIImage imageNamed:@"bubble"];
        cell.imgViewMiddle.image = [UIImage imageNamed:@"trunk"];
        switch (indexPath.row) {
            case 1:
                cell.lblLossAmount.text = @"损耗1000吨";
                cell.lblLossType.text = @"物流损耗";
                break;
            case 3:
                cell.lblLossAmount.text = @"损耗80吨";
                cell.lblLossType.text = @"原材料损耗";
                break;
            case 5:
                cell.lblLossAmount.text = @"损耗300吨";
                cell.lblLossType.text = @"半成品损耗";
                break;
            case 7:
                cell.lblLossAmount.text = @"损耗100吨";
                cell.lblLossType.text = @"成品损耗";
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
        switch (indexPath.row) {
            case 1:
                
                break;
            case 3:
                
                break;
            case 5:
                
                break;
            case 7:
                
                break;
        }
    }
}

@end
