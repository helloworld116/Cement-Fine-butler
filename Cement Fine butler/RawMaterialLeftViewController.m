//
//  RawMaterialLeftViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-6.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialLeftViewController.h"
#import "RawMaterialCostViewController.h"
#import "RawMaterialsCostManagerViewController.h"
#import "CostComparisonViewController.h"
#import "HistroyTrendsViewController.h"

@interface RawMaterialLeftViewController ()

@end

@implementation RawMaterialLeftViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITabBarController *tabbarController = (UITabBarController *)[self.sidePanelController centerPanel];
    NSArray *viewControllers = tabbarController.viewControllers;
    NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:viewControllers];
    UIViewController *viewController = [viewControllers objectAtIndex:0];
    if (indexPath.row==0) {
        RawMaterialCostViewController *rawMaterialCostVC = [[RawMaterialCostViewController alloc] initWithNibName:@"RawMaterialCostViewController" bundle:nil];
        UINavigationController *rawMaterialCostNC = [[UINavigationController alloc] initWithRootViewController:rawMaterialCostVC];
        rawMaterialCostNC.tabBarItem.image = viewController.tabBarItem.image;
        rawMaterialCostNC.tabBarItem.title = viewController.tabBarItem.title;
        [newViewControllers replaceObjectAtIndex:0 withObject:rawMaterialCostNC];
    }else if (indexPath.row==1){
        UINavigationController *rawMaterialCostManagerNC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerNavController"];
        rawMaterialCostManagerNC.tabBarItem.image = viewController.tabBarItem.image;
        rawMaterialCostManagerNC.tabBarItem.title = viewController.tabBarItem.title;
        [newViewControllers replaceObjectAtIndex:0 withObject:rawMaterialCostManagerNC];
    }
    [tabbarController setViewControllers:newViewControllers];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

@end
