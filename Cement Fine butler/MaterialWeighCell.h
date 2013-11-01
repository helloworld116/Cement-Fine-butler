//
//  MaterialWeighCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-1.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialWeighCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMaterialName;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitPrice;

@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@end
