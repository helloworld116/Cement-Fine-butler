//
//  ConditionTableView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ConditionTableView.h"
#import "ConditionCell.h"

@interface ConditionTableView ()

@end

@implementation ConditionTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCondition:(NSArray *)condition andCurrentSelectCellIndex:(NSUInteger)currentSelectCellIndex{
    self = [super init];
    if (self) {
        self.conditon = condition;
        self.currentSelectCellIndex = currentSelectCellIndex;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.conditon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConditionCell";
    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    // Configure the cell...
    NSDictionary *condtionDict = [self.conditon objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.font = [UIFont systemFontOfSize:14];
    cell.label.text = [condtionDict objectForKey:@"name"];
    cell.label.textColor = kUnSelectedColor;
    cell.selectedImgView.image = [UIImage imageNamed:@"checked"];
    cell.selectedImgView.hidden = YES;
    if (indexPath.row==self.currentSelectCellIndex) {
        [self setTableViewCellStyle:cell selected:YES];
    }
    
    //设置标识，以便选中时知道选中的是哪个
    cell.cellID = [[condtionDict objectForKey:@"_id"] intValue];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 240, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:57/255.0 alpha:1].CGColor;
    separatorView.layer.borderWidth = 1.0;
    [cell.contentView addSubview:separatorView];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        ConditionCell *cell = [[tableView visibleCells] objectAtIndex:i];
        [self setTableViewCellStyle:cell selected:NO];
    }
    ConditionCell *cell = (ConditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setTableViewCellStyle:cell selected:YES];
}

-(void)setTableViewCellStyle:(ConditionCell *)cell selected:(BOOL)selected{
    if (selected) {
        cell.selectedImgView.hidden = NO;
        cell.label.font = [UIFont boldSystemFontOfSize:14];
        cell.label.textColor = kGeneralColor;
    }else{
        cell.selectedImgView.hidden = YES;
        cell.label.font = [UIFont systemFontOfSize:14];
        cell.label.textColor = kRelativelyColor;
    }
}

@end