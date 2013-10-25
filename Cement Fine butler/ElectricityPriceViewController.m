//
//  ElectricityPriceViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-25.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectricityPriceViewController.h"
#import "ElectricityCell.h"

@interface ElectricityPriceViewController ()
@property (assign, nonatomic) NSInteger rowsCount;
@end

@implementation ElectricityPriceViewController

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
    self.title = @"电力价格";
    self.rowsCount = 20;
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
    return self.rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ElectricityCell";
    ElectricityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50.f;
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
    self.rowsCount -= 1;
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Reply", @"Forward", @"Flag", @"Mark as Unread", @"Move to Junk", @"Move Message...",  nil];
    [actionSheet showInView:self.view];
}

@end
