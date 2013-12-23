//
//  REMenuReportVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "REMenuReportVC.h"
#import "InventoryColumnViewController.h"
#import "ProductColumnViewController.h"

@interface REMenuReportVC ()

@end

@implementation REMenuReportVC

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
	__weak UINavigationController *selfNC = self.navigationController;
    REMenuItem *productItem = [[REMenuItem alloc] initWithTitle:@"产量报表"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          ProductColumnViewController *productColumnVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
                                                          [selfNC setViewControllers:@[productColumnVC] animated:NO];
                                                      }];
    REMenuItem *inventoryItem = [[REMenuItem alloc] initWithTitle:@"产量报表"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             InventoryColumnViewController *inventoryColumnVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"inventoryColumnViewController"];
                                                             [selfNC setViewControllers:@[inventoryColumnVC] animated:NO];
                                                         }];
    
    self.menu = [[REMenu alloc] initWithItems:@[productItem, inventoryItem]];
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    ProductColumnViewController *productColumnVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
    [self.navigationController pushViewController:productColumnVC animated:NO];
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    [self.menu showFromNavigationController:self.navigationController];
}

@end
