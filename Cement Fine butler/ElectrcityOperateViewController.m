//
//  ElectrcityOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectrcityOperateViewController.h"

@interface ElectrcityOperateViewController ()

@end

@implementation ElectrcityOperateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    if (self.electricityInfo) {
        self.title = @"修改电力价格";
        self.textElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[self.electricityInfo objectForKey:@"value"] floatValue]];
    }else{
        self.title = @"添加电力价格";
        [self.textElectricityPrice becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save:(id)sender{
    
}

@end
