//
//  IndustryStandardViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "IndustryStandardViewController.h"
#import "IndustryStandardOperationViewController.h"

@interface IndustryStandardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndustryStandardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"行业数据";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    if (!kSharedApp.multiGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"ProductHistoryCell";
//    ProductHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // Configure the cell...
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:1];
//    }
//    NSDictionary *info = [self.list objectAtIndex:indexPath.row];
//    cell.lblLine.text = [Tool stringToString:[info objectForKey:@"name"]];
//    cell.lblProduct.text = [Tool stringToString:[info objectForKey:@"productZhDes"]];
//    cell.lblTime.text = [Tool stringToString:[info objectForKey:@"start_time_str"]];
//    if (!kSharedApp.multiGroup) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return cell;
    return nil;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender{
    IndustryStandardOperationViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"industryStandardOperationVC"];
//    nextViewController.delegate = self;
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}

@end
