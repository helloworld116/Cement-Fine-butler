//
//  LossNavigationController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossNavigationController.h"
#import "LossReportViewController.h"

@interface LossNavigationController ()
@property (strong, readwrite, nonatomic) REMenu *menu;
@end

@implementation LossNavigationController

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
    __typeof (self) __weak weakSelf = self;
    REMenuItem *item1 = [[REMenuItem alloc] initWithTitle:@"物流损耗"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                      [self navigtionController:weakSelf withType:0];
                                                   }];
    
    REMenuItem *item2 = [[REMenuItem alloc] initWithTitle:@"原材料损耗"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                      [self navigtionController:weakSelf withType:1];
                                                   }];
    
    REMenuItem *item3 = [[REMenuItem alloc] initWithTitle:@"半成品损耗"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       [self navigtionController:weakSelf withType:2];
                                                   }];
    
    REMenuItem *item4 = [[REMenuItem alloc] initWithTitle:@"成品损耗"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       [self navigtionController:weakSelf withType:3];
                                                   }];
    self.menu = [[REMenu alloc] initWithItems:@[item1, item2, item3, item4]];
    
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

-(void)navigtionController:(LossNavigationController *)weakSelf withType:(NSInteger)type{
    LossReportViewController *nextViewController = [[LossReportViewController alloc] init];
    NSMutableArray *newVCs;
    for (UIViewController *vc in weakSelf.viewControllers) {
        if([vc isKindOfClass:[LossReportViewController class]]){
            LossReportViewController *lvc =(LossReportViewController *)vc;
            nextViewController.dateDesc = lvc.dateDesc;
            nextViewController.data = lvc.data;
            nextViewController.type = type;
            newVCs = [NSMutableArray arrayWithArray:weakSelf.viewControllers];
            [newVCs removeObject:lvc];
            break;
        }
    }
    [weakSelf setViewControllers:newVCs animated:NO];
    nextViewController.hidesBottomBarWhenPushed = YES;
    [weakSelf pushViewController:nextViewController animated:NO];
}

@end
