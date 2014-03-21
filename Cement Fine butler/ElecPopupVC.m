//
//  ElecPopupVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-22.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElecPopupVC.h"
#import "ElecPopupView.h"

@interface ElecPopupVC ()
@property (nonatomic,strong) ElecPopupView *popupView;
@property (nonatomic) double defaultValue2;
@end

@implementation ElecPopupVC

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
    self.popupView = [[ElecPopupView alloc] initWithDefaultValue:self.defaultValue2];
    self.view.frame = self.popupView.frame;
    self.view.layer.cornerRadius = 5;
    [self.view addSubview:self.popupView];
}

-(void)setDefaultValue:(double)defaultValue{
    self.defaultValue2 = defaultValue;
    self.popupView.defaultValue = defaultValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
