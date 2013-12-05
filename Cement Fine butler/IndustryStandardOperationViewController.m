//
//  IndustryStandardOperationViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "IndustryStandardOperationViewController.h"
#import "IndustryStandardTypeViewController.h"
#import "ProductChoiceViewController.h"

@interface IndustryStandardOperationViewController ()<PassValueDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblTypeName;
@property (strong, nonatomic) IBOutlet UITextField *textValue;

@property (nonatomic,retain) ProductChoiceViewController *productNextVC;
@property (nonatomic,retain) IndustryStandardTypeViewController *industryStandardTypeVC;
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;

@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;

@property (nonatomic,assign) long productId;//产品id
@property (nonatomic,assign) int typeId;//行业类型id，1标准成本、2煤业界均耗、3电业界均耗
@property (nonatomic,retain) NSString *val;//数值
@end

@implementation IndustryStandardOperationViewController

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

    self.title = @"行业数据添加";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textValue];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lblProductNameChanged:)
                                                 name:@"lblProductNameChanged"
                                               object:self.lblProductName];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lblTypeNameChanged:)
                                                 name:@"lblTypeNameChanged"
                                               object:self.lblTypeName];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textValue];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lblProductNameChanged" object:self.lblProductName];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lblTypeNameChanged" object:self.lblTypeName];
}

-(void)textFieldChanged:(NSNotification *)notification{
    UITextField *textfield = (UITextField *)notification.object;
    if (![textfield.text isEqualToString:@""]&&self.productId!=0&&self.typeId!=0) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)lblProductNameChanged:(NSNotification *)notification{
    NSLog(@"notification is %@",notification);
}

-(void)lblTypeNameChanged:(NSNotification *)notification{
    NSLog(@"notification is %@",notification);
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
            [self.textValue resignFirstResponder];
            if (!self.productNextVC) {
                self.productNextVC = [[ProductChoiceViewController alloc] init];
                self.productNextVC.productId = self.productId;
                self.productNextVC.delegate = self;
            }
            [self.navigationController pushViewController:self.productNextVC animated:YES];
        }
            break;
        case 1:{
            [self.textValue resignFirstResponder];
            if (!self.industryStandardTypeVC) {
                self.industryStandardTypeVC = [[IndustryStandardTypeViewController alloc] init];
                self.industryStandardTypeVC.typeId = self.productId;
                self.industryStandardTypeVC.delegate = self;
            }
            [self.navigationController pushViewController:self.industryStandardTypeVC animated:YES];
        }
            break;
        case 2:{
            [self.textValue becomeFirstResponder];
        }
            break;
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(id)sender{
    [self sendRequest:kIndustryStandardAdd];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{    
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
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:self.val forKey:@"val"];
    [self.request setPostValue:[NSNumber numberWithLong:self.productId] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:self.typeId] forKey:@"type"];
    [self.request setPostValue:[NSNumber numberWithLong:self.productId] forKey:@"productId"];
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
    if (errorCode==kErrorCode0) {
        long databaseId;
        //修改操作
        if (self.industryStandardDict) {
            databaseId = [[self.industryStandardDict objectForKey:@"id"] longValue];
        }else{
//            databaseId = [[dict objectForKey:@"data"] longValue];
            databaseId = 0;
        }
        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"typeId":[NSNumber numberWithInt:self.typeId],@"typeName": self.lblTypeName.text,@"productId": [NSNumber numberWithLong:self.productId],@"productName": self.lblProductName.text};
        [self.delegate passValue:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
    [self.progressHUD hide:YES];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    if ([newValue objectForKey:@"typeName"]) {
        self.typeId = [[newValue objectForKey:@"typeId"] intValue];
        self.lblTypeName.text = [newValue objectForKey:@"typeName"];
    }
    if ([newValue objectForKey:@"productName"]) {
        self.productId = [[newValue objectForKey:@"productId"] longValue];
        self.lblProductName.text = [newValue objectForKey:@"productName"];
    }
}
@end
