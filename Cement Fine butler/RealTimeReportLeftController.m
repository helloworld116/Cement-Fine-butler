//
//  RealTimeReportLeftController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-6.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RealTimeReportLeftController.h"
#import "InventoryColumnViewController.h"
#import "ProductColumnViewController.h"

@interface RealTimeReportLeftController ()
@property (nonatomic,retain) UINavigationController *inventoryColumnNC;
@property (nonatomic,retain) UINavigationController *ProductColumnNC;
@end

@implementation RealTimeReportLeftController

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
    UIViewController *viewController = [viewControllers objectAtIndex:2];
    if (indexPath.row==0) {
        ProductColumnViewController *productColumnVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
        UINavigationController *productColumnNC = [[UINavigationController alloc] initWithRootViewController:productColumnVC];
        productColumnNC.tabBarItem.image = viewController.tabBarItem.image;
        productColumnNC.tabBarItem.title = viewController.tabBarItem.title;
        [newViewControllers replaceObjectAtIndex:2 withObject:productColumnNC];
    }else if (indexPath.row==1){
        InventoryColumnViewController *inventoryColumnVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"inventoryColumnViewController"];
        UINavigationController *inventoryColumnNC = [[UINavigationController alloc] initWithRootViewController:inventoryColumnVC];
        inventoryColumnNC.tabBarItem.image = viewController.tabBarItem.image;
        inventoryColumnNC.tabBarItem.title = viewController.tabBarItem.title;
        [newViewControllers replaceObjectAtIndex:2 withObject:inventoryColumnNC];
    }
    [tabbarController setViewControllers:newViewControllers];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

@end
