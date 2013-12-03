//
//  Cell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-20.
//  Copyright (c) 2013年 河南丰博自动化有限公司 rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblEquipmentName;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblLine;
@property (strong, nonatomic) IBOutlet UILabel *lblMaterial;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipmentType;
@property (strong, nonatomic) IBOutlet UILabel *lblBox;
@property (strong, nonatomic) IBOutlet UILabel *lblSN;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
