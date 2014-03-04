//
//  CalculateVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-27.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CalculateVC.h"
#import "CalculatePopupVC.h"

@interface CalculateVC ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (nonatomic,retain) NSArray *data;

@property (nonatomic,retain) NSMutableArray *cells;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) CalculateHeaderView *headerView;
@property (nonatomic) double sliderMaxValue;
@end

@implementation CalculateVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.title = @"原材料成本计算器";
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"CalculateCell" owner:self options:nil] objectAtIndex:1];
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    CGRect tableViewFrame = CGRectMake(0, self.headerView.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.headerView.frame.size.height);
    self.tableView.frame = tableViewFrame;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 130.f;
    [self.view addSubview:self.tableView];
    [self sendRequest];
    self.cells = [@[] mutableCopy];
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
    double total = 0;
    for (NSDictionary *dict in self.data) {
        if ([[dict objectForKey:@"locked"] boolValue]) {
            total += [[dict objectForKey:@"rate"] doubleValue];
        }
    }
    self.sliderMaxValue = 100.f-total;
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"CalculateCell";
    CalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CalculateCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setDefaultStyle];
    NSDictionary *data = [self.data objectAtIndex:indexPath.row];
//    NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:data];
//    [newData setValue:[NSNumber numberWithFloat:40.f] forKey:@"rate"];
    [cell setValueWithData:data withSliderMaxValue:self.sliderMaxValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //添加到缓存池
//    [self.cells addObject:cell];
    return cell;
}


-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 发送网络请求
-(void) sendRequest{
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kCalculator);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCalculator]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

-(void)setHeaderViewValue{
    double unitPrice=0,unitPlanPrice=0;
    for (int i=0; i<self.data.count; i++) {
        NSDictionary *dict = [self.data objectAtIndex:i];
        double rate = [[dict objectForKey:@"rate"] doubleValue];
        double financePrice = [[dict objectForKey:@"financePrice"] doubleValue];
        double planPrice = [[dict objectForKey:@"planPrice"] doubleValue];
        unitPrice+=(financePrice*rate)/100;
        unitPlanPrice+=(planPrice*rate)/100;
    }
    NSString *unitPriceString = [NSString stringWithFormat:@"%.2f",round(unitPrice*100)/100];
    NSString *unitPlanPriceString = [NSString stringWithFormat:@"%.2f",round(unitPlanPrice*100)/100];
    self.headerView.lblUnitPrice.text = unitPriceString;
    self.headerView.lblPlanUnitPrice.text = unitPlanPriceString;
}
@end

@implementation CalculateHeaderView



@end

@implementation CalculateCell


-(void)setDefaultStyle{
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"yellowbars"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[[UIImage imageNamed:@"graybars"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"slider_icon"];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [self.slider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setValueWithData:(NSDictionary *)data withSliderMaxValue:(double)maxValue{
    self.data = data;
    
    self.slider.value = [Tool floatValue:[data objectForKey:@"rate"]];
    self.slider.maximumValue = maxValue;
    self.slider.minimumValue = 0.f;
    self.lblMaterialName.text = [Tool stringToString:[data objectForKey:@"name"]];
    self.lblRatio.text = [NSString stringWithFormat:@"%.2f%@",[Tool doubleValue:[data objectForKey:@"rate"]],@"%"];
    self.lblFinancePrice.text = [NSString stringWithFormat:@"%.2f%@",[Tool doubleValue:[data objectForKey:@"financePrice"]],@"元"];
    self.lblPlanPrice.text = [NSString stringWithFormat:@"%.2f%@",[Tool doubleValue:[data objectForKey:@"planPrice"]],@"元"];
    [self setViewState:[[data objectForKey:@"locked"] boolValue]];
    //设置滑竿下的文字
//    UIImageView *imageView = [self.slider.subviews objectAtIndex:2];
//    
//    CGRect theRect = [self convertRect:imageView.frame fromView:imageView.superview];
//    
//    [self.lblValue setFrame:CGRectMake(theRect.origin.x+3, theRect.origin.y+30, self.lblValue.frame.size.width, self.lblValue.frame.size.height)];
    self.lblValue.text = [NSString stringWithFormat:@"%.2f%@",self.slider.value,@"%"];
}

-(void)sliderValueChanged:(UISlider *)slider{
    UIImageView *imageView = [self.slider.subviews objectAtIndex:2];
    CGRect theRect = [self convertRect:imageView.frame fromView:imageView.superview];
    
    [self.lblValue setFrame:CGRectMake(theRect.origin.x+3, theRect.origin.y+30, self.lblValue.frame.size.width, self.lblValue.frame.size.height)];
    self.lblValue.text = [NSString stringWithFormat:@"%.2f%@",slider.value,@"%"];
    [self updateDataSource];
}

-(void)sliderDragUp:(UISlider *)slider{
    self.lblRatio.text = [NSString stringWithFormat:@"%.2f%@",slider.value,@"%"];
//    [self updateDataSource];
}

-(IBAction)lockStateChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self setViewState:[btn.titleLabel.text isEqualToString:@"锁定"]];
    [self updateDataSource];
}

-(void)setViewState:(BOOL)isLocked{
    if (isLocked) {
        self.isLocked = YES;
        [self.btnLock setTitle:@"解锁" forState:UIControlStateNormal];
        self.slider.enabled = NO;
    }else{
        self.isLocked = NO;
        [self.btnLock setTitle:@"锁定" forState:UIControlStateNormal];
        self.slider.enabled = YES;
    }
}


-(IBAction)showUpdateView:(id)sender{
    CalculatePopupVC *popupVC = [[CalculatePopupVC alloc] init];
    popupVC.defaultValue = self.data;
    UITableView *tableView = (UITableView *)[self superview];
    CalculateVC *calculateVC = (CalculateVC *) tableView.dataSource;
    [calculateVC presentPopupViewController:popupVC animationType:MJPopupViewAnimationFade];
}

-(void)updateDataSource{
    UITableView *tableView = (UITableView *)[self superview];
    CalculateVC *calculateVC = (CalculateVC *) tableView.dataSource;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    NSInteger index = indexPath.row;
    NSArray *data = calculateVC.data;
    float rate = self.slider.value;
    NSDictionary *updateData = @{@"name":self.lblMaterialName.text,@"rate":[NSNumber numberWithFloat:rate],@"financePrice":[NSNumber numberWithDouble:[self.lblFinancePrice.text doubleValue]],@"planPrice":[NSNumber numberWithDouble:[self.lblPlanPrice.text doubleValue]],@"apportionRate":[NSNumber numberWithDouble:[self.lblAssessmentRate.text doubleValue]],@"locked":[NSNumber numberWithBool:self.isLocked]};
    self.data = updateData;
    NSMutableArray *newData = [NSMutableArray array];
    //
    double beginRate = [[[data objectAtIndex:index] objectForKey:@"rate"] doubleValue];
    double endRate = rate;
    double diff = beginRate-endRate;
    int j=0;//没有锁定并未设置分摊比率的个数
    double sureApporitionRate=0;//已经确定的
    double otherTotalRate = 0;//外部已经占有的比率
    for (int i=0; i<data.count; i++) {
        if (i!=index) {
            NSDictionary *rawMaterialsInfo = [data objectAtIndex:i];
            BOOL locked = [[rawMaterialsInfo objectForKey:@"locked"] boolValue];
            if (!locked) {
                double apportionRate = [[rawMaterialsInfo objectForKey:@"apportionRate"] doubleValue];
                otherTotalRate += [Tool doubleValue:[rawMaterialsInfo objectForKey:@"rate"]];
                if (apportionRate==0) {//分摊比不为0，则按改比率添加
                    j++;
                }else{
                    sureApporitionRate += apportionRate;
                }
            }
        }
    }
    int k=0;
    double otherValues=0;//已经分配了的
    for (int i=0; i<data.count; i++) {
        if (i!=index) {
            NSDictionary *rawMaterialsInfo = [data objectAtIndex:i];
            BOOL locked = [[rawMaterialsInfo objectForKey:@"locked"] boolValue];
            if (locked) {
                //锁定了不修改直接添加
                [newData addObject:rawMaterialsInfo];
            }else{
                NSMutableDictionary *newRawMaterialsInfo = [rawMaterialsInfo mutableCopy];
                double _apportionRate = [[rawMaterialsInfo objectForKey:@"apportionRate"] doubleValue];
                double defaultRate = [[rawMaterialsInfo objectForKey:@"rate"] doubleValue];
                double newRate = 0;
                if (_apportionRate!=0) {//分摊比不为0，则按改比率添加
                    newRate = defaultRate+_apportionRate/100*diff;
                    //                    otherValues += (_apportionRate/100*diff);
                    newRate = [[NSString stringWithFormat:@"%.2f",newRate] doubleValue];
                    otherValues += newRate;
                }else{
                    //分摊为空则其余的平摊
                    k++;
                    if (j==k) {
                        newRate = 100 - endRate - otherValues;
                    }else{
                        if (otherTotalRate) {
                            newRate = defaultRate+(100-sureApporitionRate)/100*diff/j;
                        }else{
                            newRate = defaultRate+((100-otherTotalRate)+diff)/j;
                        }
                        newRate = [[NSString stringWithFormat:@"%.2f",newRate] doubleValue];
                        otherValues += newRate;
                        
                    }
                }
                [newRawMaterialsInfo setObject:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",newRate] doubleValue]] forKey:@"rate"];
                [newData addObject:newRawMaterialsInfo];
            }
        }else{
            [newData addObject:updateData];
        }
    }
    calculateVC.data = newData;
    [calculateVC setHeaderViewValue];
    [tableView reloadData];
}
@end
