//
//  FixCostOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "FixCostOperateViewController.h"
#import "FixcostSubjectChoiceViewController.h"

@interface FixCostOperateViewController ()<UITextFieldDelegate,PassValueDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *textValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) long _id;//成本项id
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) FixcostSubjectChoiceViewController *nextViewController;
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
- (IBAction)dateChange:(id)sender;
@end

@implementation FixCostOperateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    NSString *title = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    if (self.fixcostInfo) {
        title = @"修改";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(update:)];
        self._id = [[self.fixcostInfo objectForKey:@"subject"] longValue];
        self.lblName.text = [Tool stringToString:[self.fixcostInfo objectForKey:@"name"]];
        NSString *createDate = [Tool stringToString:[self.fixcostInfo objectForKey:@"strCreateTime"]];
        self.lblDate.text = createDate;
        self.datePicker.date = [dateFormatter dateFromString:createDate];
        self.textValue.text = [NSString stringWithFormat:@"%.2f",[[self.fixcostInfo objectForKey:@"price"] doubleValue]];
    }else{
        title = @"添加";
        self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
        self.lblDate.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    self.title = [title stringByAppendingFormat:@"%@",@"固定成本"];
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
            if (!self.nextViewController) {
                self.nextViewController = [[FixcostSubjectChoiceViewController alloc] init];
                self.nextViewController.subjectId = self._id;
                self.nextViewController.delegate = self;
            }
            [self.navigationController pushViewController:self.nextViewController animated:YES];
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
    [dateFormatter setDateFormat:@"yyyy-MM"];
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
    [self.request setPostValue:self.lblDate.text forKey:@"strCreateTime"];
    [self.request setPostValue:self.textValue.text forKey:@"price"];
    [self.request setPostValue:[NSNumber numberWithLong:[[self.fixcostInfo objectForKey:@"id"] longValue]] forKey:@"id"];
    [self.request setPostValue:[NSNumber numberWithLong:self._id] forKey:@"subject"];
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
        if (self.fixcostInfo) {
            databaseId = [[self.fixcostInfo objectForKey:@"id"] longValue];
        }else{
            databaseId = [[dict objectForKey:@"data"] longValue];
        }
        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"name": self.lblName.text,@"subject": [NSNumber numberWithLong:self._id],@"strCreateTime": self.lblDate.text,@"price": self.textValue.text};
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
    [self sendRequest:kFixcostAdd];
}

-(void)update:(id)sender{
    [self sendRequest:kFixcostUpdate];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    self._id = [[newValue objectForKey:@"id"] longValue];
    self.lblName.text = [newValue objectForKey:@"name"];
}

@end
