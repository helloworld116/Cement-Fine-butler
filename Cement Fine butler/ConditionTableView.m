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
    cell.label.textColor = [UIColor blackColor];
    cell.selectedImgView.image = [UIImage imageNamed:@"checked"];
    cell.selectedImgView.hidden = YES;
    if (indexPath.row==self.currentSelectCellIndex) {
        [self setTableViewCellStyle:cell selected:YES];
    }
    
    //设置标识，以便选中时知道选中的是哪个
    cell.cellID = [[condtionDict objectForKey:@"_id"] intValue];
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
        cell.label.textColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
    }else{
        cell.selectedImgView.hidden = YES;
        cell.label.font = [UIFont systemFontOfSize:14];
        cell.label.textColor = [UIColor blackColor];
    }
}

@end