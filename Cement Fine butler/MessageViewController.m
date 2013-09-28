//
//  MessgeViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

@interface MessageViewController ()

@end

@implementation MessageViewController


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"库存预警信息";
        notification.alertBody=@"熟料库存只剩300吨，已低于库存下限值600吨。请尽快补充物料";
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    UILocalNotification *notification2=[[UILocalNotification alloc] init];
    if (notification) {
        NSDate *now=[NSDate new];
        notification2.fireDate=[now dateByAddingTimeInterval:10];
        notification2.timeZone=[NSTimeZone defaultTimeZone];
        notification2.soundName = UILocalNotificationDefaultSoundName;
        notification2.alertAction = @"库存预警信息";
        notification2.alertBody=@"熟料库存只剩600吨，已低于库存下限值900吨。请尽快补充物料";
        //        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification2];
    }
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setlblTitleText:@"[库存预警消息]"];
    cell.lblTime.text=@"2013-08-30 09:37:45";
    cell.lblContent.text=@"熟料库存只剩300吨，已低于库存下限值600吨。请尽快补充物料";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
