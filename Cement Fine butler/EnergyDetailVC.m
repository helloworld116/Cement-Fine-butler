//
//  EnergyDetailVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-10.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyDetailVC.h"

@interface EnergyDetailVC ()

@end

@implementation EnergyDetailVC

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

@end

@interface EnergyDetailCell()
@property (nonatomic,strong) IBOutlet UIView *viewContainer;
@end

@implementation EnergyDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnergyDetailCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.viewContainer.layer.borderWidth = 1.0;
        self.viewContainer.layer.borderColor = [[Tool hexStringToColor:@"#e5e5e5"] CGColor];
    }
    return self;
}

@end
