//
//  CalculateVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-27.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CalculateVC.h"

@interface CalculateVC ()<MBProgressHUDDelegate>
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (nonatomic,retain) NSArray *data;
@end

@implementation CalculateVC

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

    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.title = @"原材料成本计算器";
    [self sendRequest];
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
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalculateCell";
    CalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CalculateCell" owner:self options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"CalculateCell" bundle:nil] forCellReuseIdentifier:@"CalculateCell"];
    }
    [cell setDefaultStyle];
    NSDictionary *data = [self.data objectAtIndex:indexPath.row];
    [cell setValueWithData:data];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.f;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

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


@end

@implementation CalculateCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [[[NSBundle mainBundle] loadNibNamed:@"CalculateCell" owner:self options:nil] objectAtIndex:0];
//    if (self) {
//
//    }
//    return self;
//}

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ItemCell"];
//}

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

-(void)setValueWithData:(NSDictionary *)data{
    self.lblMaterialName.text = [Tool stringToString:[data objectForKey:@"name"]];
    self.lblRatio.text = [NSString stringWithFormat:@"%.1f%@",[Tool doubleValue:[data objectForKey:@"rate"]],@"%"];
    self.lblFinancePrice.text = [NSString stringWithFormat:@"%.2f%@",[Tool doubleValue:[data objectForKey:@"financePrice"]],@"元"];
    self.lblPlanPrice.text = [NSString stringWithFormat:@"%.2f%@",[Tool doubleValue:[data objectForKey:@"planPrice"]],@"元"];
}

-(void)sliderValueChanged:(UISlider *)slider{
    CGRect lblValueFrame = self.lblValue.frame;
    self.lblValue.frame = CGRectMake(self.slider.frame.origin.x, lblValueFrame.origin.y, lblValueFrame.size.width, lblValueFrame.size.height);
    self.lblValue.text = [NSString stringWithFormat:@"%.1f%@",slider.value,@"%"];
}

-(void)sliderDragUp:(UISlider *)slider{
    self.lblRatio.text = [NSString stringWithFormat:@"%.1f%@",slider.value,@"%"];
}

-(IBAction)lockStateChange:(id)sender{
    
}


-(IBAction)showUpdateView:(id)sender{

}
@end
