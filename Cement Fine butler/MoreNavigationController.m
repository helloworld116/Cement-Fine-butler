//
//  MoreNavigationController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MoreNavigationController.h"
#import "ProductColumnViewController.h"
#import "InventoryColumnViewController.h"

@interface MoreNavigationController ()
@property (strong, readwrite, nonatomic) REMenu *menu;
@end

@implementation MoreNavigationController

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
    REMenuItem *item1 = [[REMenuItem alloc] initWithTitle:@"产量报表"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       [self navigtionController:weakSelf withType:0];
                                                   }];
    
    REMenuItem *item2 = [[REMenuItem alloc] initWithTitle:@"库存报表"
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       [self navigtionController:weakSelf withType:1];
                                                   }];

    self.menu = [[REMenu alloc] initWithItems:@[item1, item2]];
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

-(void)navigtionController:(MoreNavigationController *)weakSelf withType:(NSInteger)type{
    UIViewController *nextViewController;
    NSMutableArray *newVCs;
    if (type==0) {
        nextViewController = [kSharedApp.storyboard  instantiateViewControllerWithIdentifier:@"productColumnViewController"];
    }else{
        nextViewController = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"inventoryColumnViewController"];
    }
    newVCs = [NSMutableArray arrayWithArray:weakSelf.viewControllers];
    [newVCs removeObjectAtIndex:1];
    [weakSelf setViewControllers:newVCs animated:NO];
    nextViewController.hidesBottomBarWhenPushed = YES;
    [weakSelf pushViewController:nextViewController animated:NO];
}


@end
