//
//  MaterialWeighDetailViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-1.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MaterialWeighDetailViewController.h"
#import "AllMaterialsViewController.h"

@interface MaterialWeighDetailViewController ()<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *textTicketCode;
@property (strong, nonatomic) IBOutlet UITextField *textSupplyName;
@property (strong, nonatomic) IBOutlet UILabel *lblMaterialName;
@property (strong, nonatomic) IBOutlet UITextField *textGw;//毛重
@property (strong, nonatomic) IBOutlet UITextField *textTare;//皮重
@property (strong, nonatomic) IBOutlet UITextField *textNw;//净重
@property (strong, nonatomic) IBOutlet UITextField *textSupplierNw;//供方净重
@property (strong, nonatomic) IBOutlet UITextField *textAw;//实收重量
@property (strong, nonatomic) IBOutlet UITextField *textPrice;
@property (strong, nonatomic) IBOutlet UITextField *textAmout;
@property (strong, nonatomic) IBOutlet UITextField *textCarCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (nonatomic) long materialId;//物料id
@property (nonatomic,retain) NSString *materialCode;// ERP提供物料编码
@property (nonatomic,retain) AllMaterialsViewController *nextViewController;

@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;

- (IBAction)dateChange:(id)sender;
@end

@implementation MaterialWeighDetailViewController

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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    self.title = @"采购详情";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.datePicker.hidden = YES;
    self.tableView.bounces = NO;
    if (self.materialWeighInfo) {
        self.tableView.sectionFooterHeight -= 216.f;
        self.textTicketCode.enabled=NO;
        self.textSupplyName.enabled=NO;
        self.textCarCode.enabled=NO;
        self.textGw.enabled=NO;//毛重
        self.textTare.enabled=NO;//皮重
        self.textNw.enabled=NO;//净重
        self.textSupplierNw.enabled=NO;//供方净重
        self.textAw.enabled=NO;//实收重量
        self.textPrice.enabled=NO;
        self.textAmout.enabled=NO;
        self.textTicketCode.text = [Tool stringToString:[self.materialWeighInfo objectForKey:@"ticketCode"]];
        self.textSupplyName.text = [Tool stringToString:[self.materialWeighInfo objectForKey:@"supplyName"]];
        self.textCarCode.text = [Tool stringToString:[self.materialWeighInfo objectForKey:@"carCode"]];
        self.lblMaterialName.text = [Tool stringToString:[self.materialWeighInfo objectForKey:@"materialName"]];
        self.lblTime.text = [Tool stringToString:[self.materialWeighInfo objectForKey:@"createDate"]];
        double gw = 0;//毛重
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"gw"]]) {
            gw = [[self.materialWeighInfo objectForKey:@"gw"] doubleValue];
        }
        self.textGw.text = [NSString stringWithFormat:@"%.2f",gw];
        double tare = 0;//皮重
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"tare"]]) {
            tare = [[self.materialWeighInfo objectForKey:@"tare"] doubleValue];
        }
        self.textTare.text = [NSString stringWithFormat:@"%.2f",tare];
        double nw = 0;//净重
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"nw"]]) {
            nw = [[self.materialWeighInfo objectForKey:@"nw"] doubleValue];
        }
        self.textNw.text = [NSString stringWithFormat:@"%.2f",nw];
        double supplierNw = 0;//供方净重
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"supplierNw"]]) {
            supplierNw = [[self.materialWeighInfo objectForKey:@"supplierNw"] doubleValue];
        }
        self.textSupplierNw.text = [NSString stringWithFormat:@"%.2f",supplierNw];
        double aw = 0;//实收重量
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"aw"]]) {
            aw = [[self.materialWeighInfo objectForKey:@"aw"] doubleValue];
        }
        self.textAw.text = [NSString stringWithFormat:@"%.2f",aw];
        double price = 0;//单价
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"price"]]) {
            price = [[self.materialWeighInfo objectForKey:@"price"] doubleValue];
        }
        self.textPrice.text = [NSString stringWithFormat:@"%.2f",price];
        double amount = 0;//毛重
        if (![Tool isNullOrNil:[self.materialWeighInfo objectForKey:@"amount"]]) {
            amount = [[self.materialWeighInfo objectForKey:@"amount"] doubleValue];
        }
        self.textAmout.text = [NSString stringWithFormat:@"%.2f",amount];
    }else{
        self.lblMaterialName.text = @"请选择";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
        self.nextViewController = [[AllMaterialsViewController alloc] init];
        self.nextViewController.delegate = self;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.lblTime.text = [dateFormatter stringFromDate:[NSDate date]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.materialWeighInfo) {
        self.datePicker.hidden = YES;
        NSLog(@"row is %d",indexPath.row);
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:self.nextViewController animated:YES];
                break;
            case 1:
                [self.textTicketCode becomeFirstResponder];
                break;
            case 2:
                [self.textSupplyName becomeFirstResponder];
                break;
            case 3:
                [self.textGw becomeFirstResponder];
                break;
            case 4:
                [self.textTare becomeFirstResponder];
                break;
            case 5:
                [self.textNw becomeFirstResponder];
                break;
            case 6:
                [self.textSupplierNw becomeFirstResponder];
                break;
            case 7:
                [self.textAw becomeFirstResponder];
                break;
            case 8:
                [self.textPrice becomeFirstResponder];
                break;
            case 9:
                [self.textAmout becomeFirstResponder];
                break;
            case 10:
//                if (self.datePicker.hidden) {
//                    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-216);
//                }
                [self.textCarCode becomeFirstResponder];
                break;
            case 11:
                [self.textTicketCode resignFirstResponder];
                [self.textGw resignFirstResponder];
                [self.textTare resignFirstResponder];
                [self.textNw resignFirstResponder];
                [self.textSupplierNw resignFirstResponder];
                [self.textAw resignFirstResponder];
                [self.textPrice resignFirstResponder];
                [self.textAmout resignFirstResponder];
                [self.textCarCode resignFirstResponder];
                self.datePicker.hidden = NO;
//                if (!self.datePicker.hidden) {
//                    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+216);
//                }
                break;
        }
    }
}

- (IBAction)dateChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *select = [self.datePicker date];
    NSString *dateString = [dateFormatter stringFromDate:select];
    self.lblTime.text = dateString;
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{
//    [self.textValue resignFirstResponder];
//    self.datePicker.hidden = YES;
    
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progressHUD.labelText = @"正在提交...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.tableView addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",url);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:self.lblTime.text forKey:@"createDate"];
    [self.request setPostValue:self.textTicketCode.text forKey:@"ticketCode"];
    [self.request setPostValue:self.textSupplyName.text forKey:@"supplyName"];
    [self.request setPostValue:self.materialCode forKey:@"materialCord"];
    [self.request setPostValue:self.lblMaterialName.text forKey:@"materialName"];
    [self.request setPostValue:self.textGw.text forKey:@"gw"];
    [self.request setPostValue:self.textTare.text forKey:@"tare"];
    [self.request setPostValue:self.textNw.text forKey:@"nw"];
    [self.request setPostValue:self.textSupplierNw.text forKey:@"supplierNw"];
    [self.request setPostValue:self.textPrice.text forKey:@"price"];
    [self.request setPostValue:self.textAmout.text forKey:@"amount"];
    [self.request setPostValue:self.textAw.text forKey:@"aw"];
    [self.request setPostValue:self.textCarCode.text forKey:@"carCode"];
    [self.request setPostValue:[NSNumber numberWithLong:self.materialId] forKey:@"materialId"];
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
        NSDictionary *dict = @{@"materialName": self.lblMaterialName.text,@"price": self.textPrice.text,@"amount": self.textAmout.text,@"createDate": self.lblTime.text,@"ticketCode":self.textTicketCode.text,@"supplyName":self.textSupplyName.text,@"gw":self.textGw.text,@"aw":self.textAw.text,@"tare":self.textTare.text,@"nw":self.textNw.text,@"supplierNw":self.textSupplierNw.text,@"carCode":self.textCarCode.text};
        [self.delegate passValue:dict];
        [self.navigationController popViewControllerAnimated:YES];
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

//#pragma mark UITextField Delegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [textField selectAll:self];
//}
//
//
-(void)add:(id)sender{
    [self sendRequest:kWeighMaterialAdd];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    self.materialId = [[newValue objectForKey:@"id"] longValue];
    self.materialCode = [newValue objectForKey:@"code"];
    self.lblMaterialName.text = [newValue objectForKey:@"name"];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextfield代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.datePicker.hidden) {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+216);
    }
}
@end
