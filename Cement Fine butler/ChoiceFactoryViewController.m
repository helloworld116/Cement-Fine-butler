//
//  ChoiceFactoryViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ChoiceFactoryViewController.h"
#import "ChoiceCell.h"

@interface ChoiceFactoryViewController ()
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
@property (nonatomic) NSUInteger currentSelectCellIndex;
@end

@implementation ChoiceFactoryViewController

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

    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.title = @"选择工厂";
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureChoice:)];
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
    return kSharedApp.factorys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChoiceCell";
    ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[ChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = kSharedApp.factorys[indexPath.row];
    cell._id = [[info objectForKey:@"id"] longValue];
    cell.lblName.text = [Tool stringToString:[info objectForKey:@"name"]];
    if ([[kSharedApp.factory objectForKey:@"id"] longValue] == [[info objectForKey:@"id"] longValue]) {
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
    if ([[kSharedApp.factorys[indexPath.row] objectForKey:@"id"] longValue]==[[kSharedApp.factory objectForKey:@"id"] longValue]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureChoice:(id)sender{
    NSDictionary *selectedFactory = kSharedApp.factorys[self.currentSelectCellIndex];
    kSharedApp.factory = selectedFactory;
    kSharedApp.startFactoryId = kSharedApp.finalFactoryId;
    kSharedApp.finalFactoryId = [[selectedFactory objectForKey:@"id"] intValue];
    [self.delegate passValue:selectedFactory];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
