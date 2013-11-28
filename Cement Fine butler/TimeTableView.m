//
//  TimeTableView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "TimeTableView.h"
#import "TimeConditionCell.h"
#import "DatePickerViewController2.h"
#import "RightViewController.h"

@implementation TimeTableView

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
    TimeConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:1];
    }
    // Configure the cell...
    NSDictionary *condtionDict = [self.conditon objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.font = [UIFont systemFontOfSize:14];
    cell.label.text = [condtionDict objectForKey:@"name"];
    cell.label.textColor = [UIColor blackColor];
    cell.labelTime.font = [UIFont systemFontOfSize:10];
    NSDictionary *timeInfo = [Tool getTimeInfo:indexPath.row];
    cell.labelTime.text=[timeInfo objectForKey:@"timeDesc"];
    cell.labelTime.textColor = [UIColor blackColor];
    cell.selectedImgView.image = [UIImage imageNamed:@"checked"];
    cell.selectedImgView.hidden = YES;
    if (indexPath.row==self.currentSelectCellIndex) {
        [self setTableViewCellStyle:cell selected:YES];
    }
    //设置标识，以便选中时知道选中的是哪个
    cell.cellID = [[condtionDict objectForKey:@"_id"] intValue];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:57/255.0 alpha:1].CGColor;
    separatorView.layer.borderWidth = 1.0;
    [cell.contentView addSubview:separatorView];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<[[tableView visibleCells] count]; i++) {
        TimeConditionCell *cell = [[tableView visibleCells] objectAtIndex:i];
        [self setTableViewCellStyle:cell selected:NO];
    }
    TimeConditionCell *cell = (TimeConditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setTableViewCellStyle:cell selected:YES];
    //修改搜索条件
    if (indexPath.row==4) {
//        DatePickerViewController2 *datePickerViewController = (DatePickerViewController2 *)[kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController2"];
        UINavigationController *datePickerViewController = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController2"];
        [[self viewController] presentModalViewController:datePickerViewController animated:YES];
    }
}

-(void)setTableViewCellStyle:(TimeConditionCell *)cell selected:(BOOL)selected{
    if (selected) {
        cell.selectedImgView.hidden = NO;
        cell.label.font = [UIFont boldSystemFontOfSize:14];
        cell.label.textColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
        cell.labelTime.font = [UIFont boldSystemFontOfSize:10];
        cell.labelTime.textColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:38/255.0 alpha:1];
    }else{
        cell.selectedImgView.hidden = YES;
        cell.label.font = [UIFont systemFontOfSize:14];
        cell.label.textColor = [UIColor blackColor];
        cell.labelTime.font = [UIFont systemFontOfSize:10];
        cell.labelTime.textColor = [UIColor blackColor];
    }
}

- (RightViewController *)viewController {
    /// Finds the view's view controller.
    
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [RightViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (RightViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
@end
