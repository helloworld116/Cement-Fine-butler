//
//  EnergyMonitoringListViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMonitoringListViewController.h"
#import "HMSegmentedControl.h"
#import "EnergyOfProductViewController.h"

@interface EnergyMonitoringListViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lblValueFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueAmount;

@property (strong, nonatomic) HMSegmentedControl *segmented;
@property (strong, nonatomic) UIScrollView *scrollViewOfProducts;
@property (strong, nonatomic) TitleView *titleView;
@end

@implementation EnergyMonitoringListViewController

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
    // Do any additional setup after loading the view from its nib.
    self.titleView = [[TitleView alloc] initWithArrow:YES];
    self.titleView.lblTimeInfo.text = self.timeInfo;
    [self.titleView.bgBtn addTarget:self.navigationController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleView;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.topView.backgroundColor = kGeneralColor;
    self.lblTextAmount.textColor = [UIColor lightTextColor];
    self.lblTextFee.textColor = [UIColor lightTextColor];
    self.lblValueAmount.textColor = kRelativelyColor;
    self.lblValueFee.textColor = kRelativelyColor;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kNavBarHeight+1);
    
    self.scrollViewOfProducts = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height+self.segmented.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.topView.frame.size.height-self.segmented.frame.size.height-kTabBarHeight)];
    self.scrollViewOfProducts.pagingEnabled = YES;
    self.scrollViewOfProducts.showsHorizontalScrollIndicator = NO;
    self.scrollViewOfProducts.delegate = self;
    [self.scrollView addSubview:self.scrollViewOfProducts];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    if (self.type==0) {
        self.titleView.lblTitle.text = @"煤耗详情";
        double coalFee = [[overview objectForKey:@"coalFee"] doubleValue];
        double coalAmount = [[overview objectForKey:@"coalAmount"] doubleValue];
        if (coalFee/100000>1) {
            coalFee/=10000;
            self.lblTextFee.text = @"煤费(万元)";
        }else{
            self.lblTextFee.text = @"煤费(元)";
        }
        NSString *coalFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
        self.lblValueFee.text = coalFeeString;
        
        if (coalAmount/100000>1) {
            coalAmount/=10000;
            self.lblTextAmount.text = @"煤耗(万吨)";
        }else{
            self.lblTextAmount.text = @"煤耗(吨)";
        }
        NSString *coalAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
        self.lblValueAmount.text = coalAmountString;
    }else if(self.type==1){
        self.titleView.lblTitle.text = @"电耗详情";
        double electricityFee = [[overview objectForKey:@"electricityFee"] doubleValue];
        double electricityAmount = [[overview objectForKey:@"electricityAmount"] doubleValue];
        if (electricityFee/100000>1) {
            electricityFee/=10000;
            self.lblTextFee.text = @"电费(万元)";
        }else{
            self.lblTextFee.text = @"电费(元)";
        }
        NSString *eletricityFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
        self.lblValueFee.text = eletricityFeeString;
        
        if (electricityAmount/100000>1) {
            electricityAmount/=10000;
            self.lblTextAmount.text = @"电耗(万度)";
        }else{
            self.lblTextAmount.text = @"电耗(度)";
        }
        NSString *eletricityAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
        self.lblValueAmount.text = eletricityAmountString;
    }
    NSArray *products = [self.data objectForKey:@"products"];
    NSUInteger productCount = products.count;
    self.scrollViewOfProducts.contentSize = CGSizeMake(self.scrollViewOfProducts.frame.size.width*productCount, self.scrollViewOfProducts.frame.size.height);
    NSMutableArray *productNames = [NSMutableArray array];
    for (int i=0;i<productCount;i++) {
        NSDictionary *product = products[i];
        NSString *name = [product objectForKey:@"name"];
        [productNames addObject:name];
        EnergyOfProductViewController *viewController = [[EnergyOfProductViewController alloc] initWithNibName:@"EnergyOfProductViewController" bundle:nil];
        viewController.product = product;
        viewController.type = self.type;
        viewController.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollViewOfProducts.frame.size.height);
        [self.scrollViewOfProducts addSubview:viewController.view];
    }
    
    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, kScreenWidth, 40)];
    [self.segmented setScrollEnabled:YES];
    [self.segmented setBackgroundColor:kGeneralColor];
    [self.segmented setTextColor:[UIColor darkTextColor]];
    [self.segmented setSelectedTextColor:kRelativelyColor];
    [self.segmented setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.segmented setSelectionIndicatorHeight:3];
    [self.segmented setSelectionIndicatorColor:[UIColor yellowColor]];//kRelativelyColor
    [self.segmented setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmented.sectionTitles = productNames;
    [self.scrollView addSubview:self.segmented];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.products.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60.f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"ChoiceCell";
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
//    cell.textLabel.text = [product objectForKey:@"name"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == self.selectedIndex) {
//        self.isOpen = NO;
//        [self didSelectCellRowFirstDo:NO nextDo:NO];
//        self.selectedIndex = -1;
//    }
//    else
//    {
//        if (self.selectedIndex!=-1) {
//            self.selectedIndex = indexPath.row;
//            [self didSelectCellRowFirstDo:YES nextDo:NO];
//            
//        }
//        else
//        {
//            [self didSelectCellRowFirstDo:NO nextDo:YES];
//        }
//    }
//}
//- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
//{
//    self.isOpen = firstDoInsert;
//    if (nextDoInsert) {
//        self.isOpen = YES;
//        self.selectedIndex = [self.tableView indexPathForSelectedRow].row;
//        [self didSelectCellRowFirstDo:YES nextDo:NO];
//    }
//}
//
//
//#pragma mark UITableView Delegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SubCateViewController *subVc = [[SubCateViewController alloc]
//                                    initWithNibName:NSStringFromClass([SubCateViewController class])
//                                    bundle:nil];
//    subVc.type = self.type;
//    subVc.product = [self.products objectAtIndex:indexPath.row];
//    self.tableView.scrollEnabled = NO;
//    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
//    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
//                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                     // opening actions
//                                     //[self CloseAndOpenACtion:indexPath];
//                                 }
//                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                    // closing actions
//                                    //[self CloseAndOpenACtion:indexPath];
//                                    //[cell changeArrowWithUp:NO];
//                                }
//                           completionBlock:^{
//                               // completed actions
//                               self.tableView.scrollEnabled = YES;
//                           }];
//}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    self.scrollViewOfProducts.contentOffset = CGPointMake(segmentedControl.selectedSegmentIndex*kScreenWidth, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setSelectedSegmentIndex:page animated:YES];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
