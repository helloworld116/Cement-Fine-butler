//
//  MoreVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-27.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "MoreVC.h"
#import "AboutVC.h"
#import "CalculateVC.h"
#import "RealTimeReportVC.h"

@implementation MoreCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (!self) {
//        
//    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil] objectAtIndex:0];
    return self;
}
@end

@interface MoreVC ()

@end

@implementation MoreVC

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
    self.navigationItem.title = @"更多";
    self.tableView.separatorColor = [Tool hexStringToColor:@"#d3d5d7"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MoreCell";
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.lblTitle.text = @"实时报表";
            cell.imgViewLeft.image = [UIImage imageNamed:@"report_icon"];
            break;
        case 1:
            cell.lblTitle.text = @"成本计算";
            cell.imgViewLeft.image = [UIImage imageNamed:@"calculators_icon"];
            break;
        case 2:
            cell.lblTitle.text = @"关于";
            cell.imgViewLeft.image = [UIImage imageNamed:@"pertain_icon"];
            break;
        case 3:
            cell.lblTitle.text = @"消息";
            cell.imgViewLeft.image = [UIImage imageNamed:@"information_icon"];
            break;
        default:
            cell.lblTitle.text = @"成本计算";
            cell.imgViewLeft.image = [UIImage imageNamed:@"report_icon"];
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *nextViewController;
    switch (indexPath.row) {
        case 0:
//            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
            {
                UIStoryboard *realTimeReportStoryboard = [UIStoryboard storyboardWithName:@"RealTimeReport" bundle:nil];
                nextViewController = [realTimeReportStoryboard instantiateViewControllerWithIdentifier:@"RealTimeReportVC"];
            }
            break;
        case 1:
//            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalViewController"];
            nextViewController = [[CalculateVC alloc] init];
            break;
        case 2:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutVC"];
            break;
        case 3:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"];
            break;
        default:
            nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
            break;
    }
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    return view;
}
@end
