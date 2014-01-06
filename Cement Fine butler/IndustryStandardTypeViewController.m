//
//  IndustryStandardTypeViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "IndustryStandardTypeViewController.h"
#import "ChoiceCell.h"

@interface IndustryStandardTypeViewController ()
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;

@property (nonatomic,retain) NSArray *data;
@property (nonatomic) NSInteger currentSelectCellIndex;
@end

@implementation IndustryStandardTypeViewController

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
    self.data = @[@{@"id":@1,@"name":@"标准成本"},@{@"id":@2,@"name":@"煤业界均耗"},@{@"id":@3,@"name":@"电业界均耗"}];
    
    self.title = @"行业数据类型选择";
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.rightButtonItem = [[UIBarButtonItem alloc] initWithText:@"确定" target:self action:@selector(sureChoice:)];
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IndustryStandardTypeCell";
    ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[ChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = self.data[indexPath.row];
    cell._id = [[info objectForKey:@"id"] intValue];
    cell.lblName.text = [info objectForKey:@"name"];
    if (cell._id==self.typeId) {
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
    NSDictionary *info = self.data[self.currentSelectCellIndex];
    if (self.typeId==[[info objectForKey:@"id"] intValue]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureChoice:(id)sender{
    NSDictionary *oldDict = self.data[self.currentSelectCellIndex];
    NSDictionary *newDict = @{@"typeId":[oldDict objectForKey:@"id"],@"typeName":[oldDict objectForKey:@"name"]};
    [self.delegate passValue:newDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
