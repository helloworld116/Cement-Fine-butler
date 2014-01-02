//
//  NavigationController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "NavigationController.h"
#import "RawMaterialCostViewController.h"
#import "RawMaterialsCostManagerViewController.h"

@interface NavigationController ()
@property (strong, readwrite, nonatomic) REMenu *menu;
@property (strong, nonatomic) RawMaterialCostViewController *rawMaterilCostVC;
@property (strong, nonatomic) RawMaterialsCostManagerViewController *rawMaterialsCostManagerVC;
@end

@implementation NavigationController

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
	__typeof (self) __weak weakSelf = self;
    REMenuItem *item1 = [[REMenuItem alloc] initWithTitle:@"原材料成本"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if (!self.rawMaterilCostVC) {
                                                              self.rawMaterilCostVC = [[RawMaterialCostViewController alloc] init];
                                                          }
                                                          [weakSelf setViewControllers:@[self.rawMaterilCostVC] animated:NO];
                                                      }];
    
    REMenuItem *item2 = [[REMenuItem alloc] initWithTitle:@"成本详情"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             if (!self.rawMaterialsCostManagerVC) {
                                                                 self.rawMaterialsCostManagerVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerViewController"];
                                                             }
                                                             [weakSelf setViewControllers:@[self.rawMaterialsCostManagerVC] animated:NO];
                                                     }];
    self.menu = [[REMenu alloc] initWithItems:@[item1, item2]];
    self.menu.backgroundColor = [UIColor whiteColor];
    self.menu.highlightedBackgroundColor = 
    self.menu.textColor = [UIColor darkGrayColor];
    self.menu.textShadowColor = [UIColor darkGrayColor];
    self.menu.separatorColor = [UIColor darkGrayColor];
    self.menu.separatorHeight = 1.0;
    self.menu.bounce = NO;
    
    // Background view
    self.menu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.menu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.menu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    
    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    // Blurred background in iOS 7
    //
    //self.menu.liveBlur = YES;
    //self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    //self.menu.liveBlurTintColor = [UIColor redColor];
    
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

@end
