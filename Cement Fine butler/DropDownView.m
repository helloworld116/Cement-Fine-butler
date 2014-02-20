//
//  DropDownView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView()
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *btnSender;
@property (nonatomic,retain) NSArray *list;
@end

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)hideDropDown:(UIButton *)btn{
    CGRect btnRect = btn.superview.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(btnRect.origin.x, btn.superview.superview.frame.origin.y+ btnRect.origin.y+btnRect.size.height, btnRect.size.width, 0);
    self.tableview.frame = CGRectMake(0, 0, btnRect.size.width, 0);
    [UIView commitAnimations];
}

-(id)initWithDropDown:(UIButton *)btn height:(CGFloat)height list:(NSArray *)list{
    self.btnSender = btn;
    NSMutableArray *newList = [NSMutableArray arrayWithArray:list];
    [newList removeObject:btn.titleLabel.text];
    self = [super init];
    if (self) {
        CGRect btnRect = btn.superview.frame;
        
        self.frame = CGRectMake(btnRect.origin.x, btn.superview.superview.frame.origin.y+ btnRect.origin.y+btnRect.size.height, btnRect.size.width, 0);
        self.list = [NSArray arrayWithArray:newList];
        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btnRect.size.width, 0)];
        self.tableview.bounces = NO;
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
//        self.tableview.layer.cornerRadius = 5;
        self.tableview.backgroundColor = [Tool hexStringToColor:@"#93baeb"];
//        self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        self.tableview.separatorColor = [UIColor whiteColor];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(btnRect.origin.x, btn.superview.superview.frame.origin.y+ btnRect.origin.y+btnRect.size.height, btnRect.size.width, height);
        self.tableview.frame = CGRectMake(0, 0, btnRect.size.width, height);
        [UIView commitAnimations];
        
        [btn.superview.superview.superview addSubview:self];
        [self addSubview:self.tableview];
    }
    return self;
}


#pragma mark tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    separatorLineView.backgroundColor = [UIColor whiteColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
    cell.textLabel.text =[self.list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:self.btnSender];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = c.textLabel.text;
    [self.btnSender setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"今天"]) {
        self.timeType = 0;
    }else if ([title isEqualToString:@"昨天"]){
        self.timeType = 1;
    }else if ([title isEqualToString:@"本月"]){
        self.timeType = 2;
    }else if ([title isEqualToString:@"本年"]){
        self.timeType = 3;
    }
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate dropDownDelegateMethod:self];
}
@end
