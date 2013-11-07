//
//  InventorySettingUpdateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventorySettingUpdateViewController.h"

@interface InventorySettingUpdateViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UITextField *textCaps;
@property (strong, nonatomic) IBOutlet UITextField *textLower;
@property (nonatomic) long _id;//物料id
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@end

@implementation InventorySettingUpdateViewController

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
    self.title = @"修改库位设置";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(update:)];
    self.textLower.delegate = self;
    self.textCaps.delegate = self;
    if(![Tool isNullOrNil:[self.info objectForKey:@"material"]]){
        self.lblName.text = [Tool stringToString:[[self.info objectForKey:@"material"] objectForKey:@"name"]];
    }
    self.lblTotal.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@"stock"] doubleValue]];
    self.textCaps.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@"topLimit"] doubleValue]];
    self.textLower.text = [NSString stringWithFormat:@"%.2f",[[self.info objectForKey:@"lowerLimit"] doubleValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        case 1:
            [self.textLower resignFirstResponder];
            [self.textCaps resignFirstResponder];
            break;
        case 2:
            [self.textCaps becomeFirstResponder];
            break;
        case 3:
            [self.textLower becomeFirstResponder];
            break;
        default:
            [self.textLower resignFirstResponder];
            [self.textCaps resignFirstResponder];
            break;
    }
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{
    [self.textCaps resignFirstResponder];
    [self.textLower resignFirstResponder];
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
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:self.textCaps.text forKey:@"topLimit"];
    [self.request setPostValue:self.textLower.text forKey:@"lowerLimit"];
    [self.request setPostValue:[NSNumber numberWithLong:[[self.info objectForKey:@"id"] longValue]] forKey:@"id"];
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
        NSDictionary *dict = @{@"topLimit":self.textCaps.text,@"lowerLimit":self.textLower.text};
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)update:(id)sender{
    [self sendRequest:kInventorySettingUpdate];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    self._id = [[newValue objectForKey:@"id"] longValue];
    self.lblName.text = [newValue objectForKey:@"name"];
}
@end
