//
//  InventoryViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface InventoryViewController ()

@end

@implementation InventoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//- (IIViewDeckController*)generateControllerStack {
//    
//    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:nav
//                                                                                    leftViewController:leftController
//                                                                                   rightViewController:rightController];
//    deckController.rightSize = 100;
//    return deckController;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    LeftViewController* leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    RightViewController* rightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryNavigationController"];
    self.centerController = nav;
    self.leftController = nil;
//    self.rightSize = 100;
    self.rightController = rightController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
