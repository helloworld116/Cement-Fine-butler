//
//  EnergyDetailVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-10.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyDetailVC.h"

@interface EnergyDetailVC ()
@property (nonatomic) double totalAmount,totalLossAmount;
@end

@implementation EnergyDetailVC

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
    self.navigationItem.title = @"电耗详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.tableView.backgroundColor = [Tool hexStringToColor:@"#eeeeee"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"EnergyDetailCell";
    EnergyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[EnergyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.data count]==indexPath.row) {
        cell.lblName.textColor = [Tool hexStringToColor:@"#49bbed"];
        cell.lblDetail.textColor = [Tool hexStringToColor:@"#49bbed"];
        cell.lblName.text = @"合计";
        NSString *status;
        if (self.totalLossAmount>=0) {
            status = @"损失";
        }else{
            self.totalLossAmount = -self.totalLossAmount;
            status = @"节约";
        }
        cell.lblDetail.text = [NSString stringWithFormat:@"使用%@度    %@%@度",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:self.totalAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:self.totalLossAmount]]];
    }else{
        NSDictionary *product = [self.data objectAtIndex:indexPath.row];
        cell.lblName.text = [product objectForKey:@"productName"];
        double elecAmount = [Tool doubleValue:[product objectForKey:@"elecAmount"]];
        self.totalAmount += elecAmount;
        double elecLossAmount = [Tool doubleValue:[product objectForKey:@"elecLossAmount"]];
        self.totalLossAmount += elecLossAmount;
        NSString *status;
        if (elecLossAmount>=0) {
            status = @"损失";
        }else{
            elecLossAmount = -elecLossAmount;
            status = @"节约";
        }
        cell.lblDetail.text = [NSString stringWithFormat:@"使用%@度    %@%@度",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecLossAmount]]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.f;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

@interface EnergyDetailCell()
@property (nonatomic,strong) IBOutlet UIView *viewContainer;
@end

@implementation EnergyDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnergyDetailCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
//        self.viewContainer.laye
        self.viewContainer.layer.borderWidth = 0.5f;
        self.viewContainer.layer.borderColor = [[Tool hexStringToColor:@"#e5e5e5"] CGColor];
    }
    return self;
}

@end
