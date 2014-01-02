//
//  WeighViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-1.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "WeighViewController.h"
#import "MaterialWeighListViewController.h"
#import "ProductWeighViewController.h"

@interface WeighViewController ()
@property (nonatomic,retain) NSArray *list;

@property (nonatomic, retain) MaterialWeighListViewController *materialWeighListVC;
@property (nonatomic, retain) ProductWeighViewController *productWeighVC;
@end

@implementation WeighViewController

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
    self.title = @"过磅管理";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.list = @[@"物料过磅",@"产品过磅"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if (!self.materialWeighListVC) {
            self.materialWeighListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"materialWeighListViewController"];
        }
        [self.navigationController pushViewController:self.materialWeighListVC animated:YES];
    }else if(indexPath.row==1){
        if (!self.productWeighVC) {
            self.productWeighVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productWeighViewController"];
        }
        [self.navigationController pushViewController:self.productWeighVC animated:YES];
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
