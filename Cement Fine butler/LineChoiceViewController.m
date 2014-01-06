//
//  LineChoiceViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LineChoiceViewController.h"
#import "ChoiceCell.h"

@interface LineChoiceViewController ()
@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
@property (nonatomic) NSUInteger currentSelectCellIndex;
@end

@implementation LineChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.navigationItem.title = @"选择产线";
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithText:@"确定" target:self action:@selector(sureChoice:)];
    self.list = [kSharedApp.factory objectForKey:@"lines"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChoiceCell";
    ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[ChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = self.list[indexPath.row];
    cell._id = [[info objectForKey:@"id"] longValue];
    cell.lblName.text = [Tool stringToString:[info objectForKey:@"name"]];
    if (self.lineId == [[info objectForKey:@"id"] longValue]) {
        cell.imgChecked.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        ChoiceCell *cell = [[tableView visibleCells] objectAtIndex:i];
        cell.imgChecked.hidden = YES;
    }
    ChoiceCell *cell = (ChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgChecked.hidden = NO;
    self.currentSelectCellIndex = indexPath.row;
    if ([[self.list[indexPath.row] objectForKey:@"id"] longValue]==self.lineId) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureChoice:(id)sender{
    NSDictionary *oldDict = self.list[self.currentSelectCellIndex];
    NSDictionary *newDict = @{@"lineId":[oldDict objectForKey:@"id"],@"lineName":[oldDict objectForKey:@"name"]};
    [self.delegate passValue:newDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
