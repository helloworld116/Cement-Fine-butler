//
//  InventoryOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryOperateViewController.h"
#import "InventoryChoiceViewController.h"

@interface InventoryOperateViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *lblTypeName;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *textValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) long _id;//原材料、半成品或成品id
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
- (IBAction)dateChange:(id)sender;

@end

@implementation InventoryOperateViewController

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
    NSString *title = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if (self.inventoryInfo) {
        title = @"修改";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(update:)];
        if (self.type==0) {
            [Tool longValue:[self.inventoryInfo objectForKey:@"xxxx"]];
            self._id = [Tool longValue:[self.inventoryInfo objectForKey:@"materialId"]];
//            self._id = [[self.inventoryInfo objectForKey:@"materialId"] longValue];
            self.lblName.text = [Tool stringToString:[self.inventoryInfo objectForKey:@"materialName"]];
        }else{
            self._id = [[self.inventoryInfo objectForKey:@"productId"] longValue];
            self.lblName.text = [Tool stringToString:[self.inventoryInfo objectForKey:@"productName"]];
        }
        NSString *inventoryDate = [Tool stringToString:[self.inventoryInfo objectForKey:@"strCreateTime"]];
        self.lblDate.text = inventoryDate;
        self.datePicker.date = [dateFormatter dateFromString:inventoryDate];
        self.textValue.text = [NSString stringWithFormat:@"%.2f",[[self.inventoryInfo objectForKey:@"stock"] doubleValue]];
    }else{
        title = @"添加";
        self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
        self.lblDate.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    switch (self.type) {
        case 0:
            self.lblTypeName.text = @"原材料";
            break;
        case 1:
            self.lblTypeName.text = @"半成品";
            break;
        case 2:
            self.lblTypeName.text = @"成品";
            break;
        default:
            self.lblTypeName.text = @"原材料";
            break;
    }
    self.title = [title stringByAppendingFormat:@"%@%@",self.lblTypeName.text,@"库存"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.textValue.delegate = self;
    if (IS_IPHONE_5) {
        self.tableView.sectionFooterHeight += 88;
    }
    [self.lblName addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textValue];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textValue];
}

-(void)textFieldChanged:(NSNotification *)notification{
    UITextField *textfield = (UITextField *)notification.object;
    if (![Tool isNullOrNil:textfield.text]&&self._id!=0) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![Tool isNullOrNil:self.textValue.text]&&self._id!=0) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
                self.datePicker.hidden = YES;
                [self.textValue resignFirstResponder];
                InventoryChoiceViewController *nextViewController = [[InventoryChoiceViewController alloc] init];
                nextViewController.type = self.type;
//                if (self.type==0) {
//                   nextViewController.inventoryId = [[self.inventoryInfo objectForKey:@"materialId"] intValue];
//                }else{
//                    nextViewController.inventoryId = [[self.inventoryInfo objectForKey:@"productId"] intValue];
//                }
                nextViewController.inventoryId = self._id;
                nextViewController.delegate = self;
                [self.navigationController pushViewController:nextViewController animated:YES];
            }
            break;
        case 1:
            self.datePicker.hidden = YES;
            [self.textValue becomeFirstResponder];
            break;
        case 2:
            self.datePicker.hidden = NO;
            [self.textValue resignFirstResponder];
            break;
    }
}
- (IBAction)dateChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *select = [self.datePicker date];
    NSString *dateString =  [dateFormatter stringFromDate:select];
    self.lblDate.text = dateString;
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{
    [self.textValue resignFirstResponder];
    self.datePicker.hidden = YES;
    
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
    [self.request setPostValue:[NSNumber numberWithLongLong:[self.datePicker.date timeIntervalSince1970]*1000] forKey:@"createTime"];
    [self.request setPostValue:self.textValue.text forKey:@"stock"];
    [self.request setPostValue:[NSNumber numberWithLong:[[self.inventoryInfo objectForKey:@"id"] longValue]] forKey:@"id"];
    if(self.type==0){
        [self.request setPostValue:[NSNumber numberWithLong:self._id] forKey:@"materialId"];
    }else{
        [self.request setPostValue:[NSNumber numberWithLong:self._id] forKey:@"productId"];
    }
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
        long databaseId;
        //修改操作
        if (self.inventoryInfo) {
            databaseId = [[self.inventoryInfo objectForKey:@"id"] longValue];
        }else{
            databaseId = [[dict objectForKey:@"data"] longValue];
        }
        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"name": self.lblName.text,@"inventoryId": [NSNumber numberWithLong:self._id],@"time": self.lblDate.text,@"stock": self.textValue.text};
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

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}

-(void)pop:(id)sender{
    [self.lblName removeObserver:self forKeyPath:@"text"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender{
    switch (self.type) {
        case 0:
            [self sendRequest:kInventoryMaterialAdd];
            break;
        case 1:
            [self sendRequest:kInventoryHalfAdd];
            break;
        case 2:
            [self sendRequest:kInventoryProductAdd];
            break;
    }
}

-(void)update:(id)sender{
    switch (self.type) {
        case 0:
            [self sendRequest:kInventoryMaterialUpdate];
            break;
        case 1:
            [self sendRequest:kInventoryHalfUpdate];
            break;
        case 2:
            [self sendRequest:kInventoryProductUpdate];
            break;
    }
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    self._id = [[newValue objectForKey:@"id"] longValue];
    self.lblName.text = [newValue objectForKey:@"name"];
}
@end
