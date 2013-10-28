//
//  InventorySettingUpdateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventorySettingUpdateViewController.h"

@interface InventorySettingUpdateViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UITextField *textCaps;
@property (strong, nonatomic) IBOutlet UITextField *textLower;
@end

@implementation InventorySettingUpdateViewController

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
    self.lblName.text = [self.info objectForKey:@""];
    self.lblTotal.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@""] doubleValue]];
    self.textCaps.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@""] doubleValue]];
    self.textLower.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@""] doubleValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        case 1:
            [self.textLower resignFirstResponder];
            [self.textCaps resignFirstResponder];
            break;
        case 2:
            [self.textCaps becomeFirstResponder];
            break;
        case 3:
            [self.textLower becomeFirstResponder];
            break;
        default:
            [self.textLower resignFirstResponder];
            [self.textCaps resignFirstResponder];
            break;
    }
}
@end
